require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "tidies up the email" do
    client = Client.create!(name: "Maya", email: "  Maya@Example.COM ")
    assert_equal "maya@example.com", client.email
  end

  test "needs a real-looking email" do
    assert_not Client.new(name: "Maya", email: "not-an-email").valid?
  end

  test "can't be deleted while they have quotes" do
    client = Client.create!(name: "Maya", email: "maya@example.com")
    Quote.create!(client: client, title: "Brand refresh")
    assert_not client.destroy
  end
end
