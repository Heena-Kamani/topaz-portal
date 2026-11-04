require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  setup do
    @client = Client.create!(name: "Maya Example", email: "maya@example.com")
    @quote = Quote.create!(client: @client, title: "Brand refresh")
  end

  def add_line(quantity:, dollars:)
    @quote.line_items.create!(description: "Work", quantity: quantity, unit_price: dollars)
  end

  test "adds up lines, then 5% GST by default" do
    add_line(quantity: 2, dollars: "450")
    add_line(quantity: 1.5, dollars: "120.00")

    assert_equal 108_000, @quote.subtotal_cents
    assert_equal 5_400, @quote.tax_cents
    assert_equal 113_400, @quote.total_cents
  end

  test "rounds tax to the nearest cent" do
    add_line(quantity: 1, dollars: "0.99")
    assert_equal 5, @quote.tax_cents # 4.95 cents rounds up
  end

  test "gives every quote its own long private token" do
    other = Quote.create!(client: @client, title: "Second")
    assert_equal 32, @quote.share_token.length
    assert_not_equal @quote.share_token, other.share_token
  end

  test "can't be accepted while it's still a draft" do
    add_line(quantity: 1, dollars: "100")
    assert_raises(ArgumentError) { @quote.accept!(name: "Maya") }
  end

  test "needs a name to accept" do
    @quote.send_to_client!
    assert_raises(ArgumentError) { @quote.accept!(name: "   ") }
  end

  test "records who accepted and the exact total they saw" do
    add_line(quantity: 1, dollars: "1000")
    @quote.send_to_client!
    @quote.accept!(name: " Maya Example ")

    assert @quote.accepted?
    assert_equal "Maya Example", @quote.accepted_by_name
    assert_equal 105_000, @quote.accepted_total_cents
    assert_not_nil @quote.accepted_at
  end

  test "is locked once accepted" do
    add_line(quantity: 1, dollars: "1000")
    @quote.send_to_client!
    @quote.accept!(name: "Maya")

    assert_not @quote.update(title: "Sneaky change")
    assert_not @quote.reload.update(tax_rate_bps: 0)

    extra = @quote.line_items.build(description: "Extra", quantity: 1, unit_price: "50")
    assert_not extra.save

    assert_not @quote.line_items.first.destroy
    assert_not @quote.destroy
    assert_equal 105_000, @quote.reload.total_cents
  end
end
