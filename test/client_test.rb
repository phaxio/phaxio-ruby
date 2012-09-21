require_relative "test_helper"

class ClientTest < Test::Unit::TestCase
  def setup
    @client = Phaxio::Client.new("abc123", "def456")
  end

  def test_initialize
    assert_instance_of Phaxio::Client, @client
  end

  def test_send_fax
    assert_equal true, @client.send_fax(to: "0123456789", filename: "test.pdf", api_key: @client.api_key, api_secret: @client.api_secret).success?
  end
end
