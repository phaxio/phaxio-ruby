require_relative "test_helper"

class ClientTest < Test::Unit::TestCase
  def setup
    @client = Phaxio.client.config do |config|
      config.api_key = 10987654321
      config.api_secret = 12345678910
    end
  end

  def test_config
    assert_equal 10987654321, @client.api_key
    assert_equal 12345678910, @client.api_secret
  end

  def test_initialize
    assert_instance_of Phaxio::Client, @client
  end

  def test_send_fax
    assert_equal true, @client.send_fax(to: "0123456789", filename: "test.pdf").success?
  end

  def test_test_receive
    assert_equal true, @client.test_receive(filename: "test_file.pdf").success?
  end

  def test_get_fax_status
    assert_equal true, @client.get_fax_status(id: "123456").success?
  end

  def test_cancel_fax
    assert_equal true, @client.cancel_fax(id: "123456").success?
  end

  def test_get_account_status
    assert_equal true, @client.get_account_status.success?
  end
end
