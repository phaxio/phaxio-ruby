require_relative "test_helper"

class TestPhaxio < MiniTest::Test
  def setup
    @callback_data = { url: 'example.com', params: { test: true } }
  end

  def test_config
    assert_equal "12345678910", Phaxio.api_key
    assert_equal "10987654321", Phaxio.api_secret
  end

  def test_initialize
  end

  def test_send_fax
    @response = Phaxio.send_fax(to: "0123456789", filename: "test.pdf")
    assert_equal true, @response["success"]
    assert_equal "Fax queued for sending", @response["message"]
    assert_equal 1234, @response["faxId"]
  end

  def test_resend_fax
    Phaxio.expects(:send_post).with('/resendFax', id: 1234)
    Phaxio.resend_fax(id: 1234)
  end

  def test_test_receive
    @response = Phaxio.test_receive(filename: "test_file.pdf")
    assert_equal true, @response["success"]
    assert_equal "Test fax received from 234567890. Calling back now...", @response["message"]
  end

  def test_provision_number
    @response = Phaxio.provision_number(area_code: 802)
    assert_equal true, @response["success"]
    assert_equal "Number provisioned successfully!", @response["message"]
    assert_equal "Vermont", @response["data"]["state"]
  end

  def test_release_number
    @response = Phaxio.release_number(number: "8021112222")
    assert_equal true, @response["success"]
    assert_equal "Number released successfully!", @response["message"]
  end

  def test_list_numbers
    @response = Phaxio.list_numbers(area_code: 802)
    assert_equal true, @response["success"]
    assert_equal "Retrieved user phone numbers successfully", @response["message"]
  end

  def test_get_fax_file
    @response_pdf = Phaxio.get_fax_file(id: 1234, type: p)
    assert_equal 6725, @response_pdf.size
  end

  def test_list_faxes
    @response = Phaxio.list_faxes(start: 1293861600, end: 1294034400)
    assert_equal true, @response["success"]
  end

  def test_get_fax_status
    @response = Phaxio.get_fax_status(id: 123456)
    assert_equal true, @response["success"]
    assert_equal "Retrieved fax successfully", @response["message"]
  end

  def test_cancel_fax
    @response = Phaxio.cancel_fax(id: 123456)
    assert_equal true, @response["success"]
    assert_equal "Fax canceled successfully.", @response["message"]
  end

  def test_delete_fax
    Phaxio.expects(:send_post).with('/deleteFax', id: 1234)
    Phaxio.delete_fax(id: 1234)
  end

  def test_get_account_status
    @response = Phaxio.get_account_status
    assert_equal true, @response["success"]
    assert_equal "Account status retrieved successfully", @response["message"]
    assert_equal 120, @response["data"]["faxes_sent_this_month"]
  end

  def test_generate_check_signature
    signature = Phaxio.generate_check_signature(**@callback_data)
    assert_equal '15adeecb7eca79676ece07ee4bc1bbba2c69eddd', signature
  end

  def test_valid_callback_signature?
    assert_equal true, Phaxio.valid_callback_signature?(
      @callback_data.merge(
        signature: '15adeecb7eca79676ece07ee4bc1bbba2c69eddd'))
    assert_equal false, Phaxio.valid_callback_signature?(
      @callback_data.merge(signature: 'wrong'))
  end

  def test_validate_callback_signature
    assert Phaxio.validate_callback_signature(
      @callback_data.merge(
        signature: '15adeecb7eca79676ece07ee4bc1bbba2c69eddd'))
    assert_raises(Phaxio::Client::InvalidCallbackSignature) do
      Phaxio.validate_callback_signature(
        @callback_data.merge(signature: 'wrong'))
    end
  end
end
