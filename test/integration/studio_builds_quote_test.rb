require "test_helper"

# Walks through my side: add a client, build a quote, send it.
class StudioBuildsQuoteTest < ActionDispatch::IntegrationTest
  test "add a client, build a quote, mark it sent" do
    post clients_path, params: { client: { name: "Maya Example", email: "maya@example.com", company: "Juniper Cafe" } }
    client = Client.last
    assert_redirected_to new_quote_path(client_id: client.id)

    post quotes_path, params: { quote: { client_id: client.id, title: "Menu redesign", tax_rate_bps: 500 } }
    quote = Quote.last
    assert_redirected_to quote_path(quote)

    post quote_line_items_path(quote), params: { line_item: { description: "Menu layout", quantity: "2", unit_price: "300" } }
    post quote_line_items_path(quote), params: { line_item: { description: "Print-ready files", quantity: "1", unit_price: "150" } }
    assert_equal 2, quote.line_items.count
    assert_equal 78_750, quote.reload.total_cents

    post send_to_client_quote_path(quote)
    follow_redirect!
    assert_select "input.share-link[value=?]", shared_quote_url(quote.share_token)
  end

  test "a bad line shows why instead of failing quietly" do
    client = Client.create!(name: "Maya", email: "maya@example.com")
    quote = Quote.create!(client: client, title: "Menu redesign")

    post quote_line_items_path(quote), params: { line_item: { description: "", quantity: "1", unit_price: "10" } }
    follow_redirect!
    assert_select ".flash-alert", /Description can't be blank/
  end

  test "an accepted quote can't be edited through the app" do
    client = Client.create!(name: "Maya", email: "maya@example.com")
    quote = Quote.create!(client: client, title: "Menu redesign")
    quote.line_items.create!(description: "Layout", quantity: 1, unit_price: "300")
    quote.send_to_client!
    quote.accept!(name: "Maya")

    patch quote_path(quote), params: { quote: { title: "Changed" } }
    assert_response :unprocessable_entity
    assert_equal "Menu redesign", quote.reload.title

    delete quote_path(quote)
    assert Quote.exists?(quote.id)
  end
end
