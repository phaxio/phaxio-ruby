require_relative "test_helper"

class ClientTest < Test::Unit::TestCase
  def setup
    @client = Phaxio.client.config do |config|
      config.api_key = 10987654321
      config.api_secret = 12345678910
    end
  end

  def test_config
    assert_equal 10987654321, @client.config.api_key
    assert_equal 12345678910, @client.config.api_secret
  end

  def test_initialize
    assert_instance_of Phaxio::Client, @client
  end

  def test_send_fax
    assert_equal true, @client.send_fax(to: "0123456789", filename: "test.pdf", api_key: @client.api_key, api_secret: @client.api_secret).success?
  end
end
