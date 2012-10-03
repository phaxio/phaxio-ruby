require_relative "test_helper"

class TestPhaxio < Test::Unit::TestCase
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
    @response = @client.send_fax(to: "0123456789", filename: "test.pdf")
    assert_equal true, @response["success"]
    assert_equal "Fax queued for sending", @response["message"]
    assert_equal 1234, @response["faxId"]
  end

  def test_test_receive
    @response = @client.test_receive(filename: "test_file.pdf")
    assert_equal true, @response["success"]
    assert_equal "Test fax received from 234567890. Calling back now...", @response["message"]
  end

  def test_get_fax_status
    @response = @client.get_fax_status(id: "123456")
    assert_equal true, @response["success"]
    assert_equal "Retrieved fax successfully", @response["message"]
  end

  def test_cancel_fax
    @response = @client.cancel_fax(id: "123456")
    assert_equal true, @response["success"]
    assert_equal "Fax canceled successfully.", @response["message"]
  end

  def test_get_account_status
    @response = @client.get_account_status
    assert_equal true, @response["success"]
    assert_equal "Account status retrieved successfully", @response["message"]
    assert_equal 120, @response["data"]["faxes_sent_this_month"]
  end
end
