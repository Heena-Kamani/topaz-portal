require "test_helper"

# Walks through the client's side: open the link, accept, see it locked.
class ClientAcceptsQuoteTest < ActionDispatch::IntegrationTest
  setup do
    client = Client.create!(name: "Maya Example", email: "maya@example.com")
    @quote = Quote.create!(client: client, title: "Brand refresh")
    @quote.line_items.create!(description: "Logo concepts", quantity: 1, unit_price: "1200")
  end

  test "a draft's link doesn't work yet" do
    get shared_quote_path(@quote.share_token)
    assert_response :not_found
  end

  test "a made-up link doesn't work" do
    @quote.send_to_client!
    get shared_quote_path("not-a-real-token")
    assert_response :not_found
  end

  test "the client opens their link and accepts" do
    @quote.send_to_client!

    get shared_quote_path(@quote.share_token)
    assert_response :success
    assert_select "h1", "Brand refresh"
    assert_select ".grand td", "$1,260.00"

    post accept_shared_quote_path(@quote.share_token), params: { name: "Maya Example" }
    follow_redirect!
    assert_select ".accepted-note", /Maya Example accepted this quote/
    assert_select "form.accept", count: 0
    assert @quote.reload.accepted?
  end

  test "accepting without a name shows a friendly message" do
    @quote.send_to_client!
    post accept_shared_quote_path(@quote.share_token), params: { name: "" }
    assert_response :unprocessable_entity
    assert_select ".flash-alert", /type your name/
    assert_not @quote.reload.accepted?
  end

  # With no-referrer, browsers send a "null" origin on the accept form and
  # Rails rejects it, so clients couldn't accept at all. Keep it same-origin.
  test "the client page keeps a referrer policy the accept form can work with" do
    @quote.send_to_client!
    get shared_quote_path(@quote.share_token)
    assert_select "meta[name=referrer][content=same-origin]"
    assert_select "meta[name=referrer][content=no-referrer]", count: 0
  end

  test "accepting twice doesn't change the record" do
    @quote.send_to_client!
    post accept_shared_quote_path(@quote.share_token), params: { name: "Maya Example" }
    post accept_shared_quote_path(@quote.share_token), params: { name: "Someone Else" }

    assert_equal "Maya Example", @quote.reload.accepted_by_name
  end
end
