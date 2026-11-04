require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  setup do
    client = Client.create!(name: "Maya Example", email: "maya@example.com")
    @quote = Quote.create!(client: client, title: "Brand refresh")
  end

  test "turns typed dollars into cents" do
    { "1,250.50" => 125_050, "$80" => 8_000, "19.999" => 2_000 }.each do |typed, cents|
      line = LineItem.new(unit_price: typed)
      assert_equal cents, line.unit_price_cents, "for #{typed.inspect}"
    end
  end

  test "rejects a price that isn't a number" do
    line = @quote.line_items.build(description: "Work", quantity: 1, unit_price: "lots")
    assert_not line.valid?
  end

  test "needs a description and a quantity above zero" do
    line = @quote.line_items.build(description: "", quantity: 0, unit_price: "10")
    assert_not line.valid?
    assert_includes line.errors.attribute_names, :description
    assert_includes line.errors.attribute_names, :quantity
  end
end
