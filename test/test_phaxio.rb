require_relative "test_helper"

class TestPhaxio < MiniTest::Test
  def setup
    @callback_data = ['example.com', { test: true }]
  end

  def test_config
    assert_equal "12345678910", Phaxio.api_key
    assert_equal "10987654321", Phaxio.api_secret
  end

  def test_initialize
  end

  def test_send_fax
    @response = Phaxio.send_fax(to: "0123456789", file: "test.pdf")
    assert_equal true, @response["success"]
    assert_equal "Fax queued for sending", @response["message"]
    assert_equal 1234, @response["data"]["id"]
  end

  def test_resend_fax
    Phaxio.expects(:send_post).with('/faxes/1234/resend', {})
    Phaxio.resend_fax(id: 1234)
  end

  def test_test_receive
    Phaxio.expects(:send_post).with('/faxes', { to: "+18773346654", from: "+18773346654", file: "test_file.pdf", direction: "receive" })
    Phaxio.test_receive(to: "+18773346654", from: "+18773346654", file: "test_file.pdf", direction: "receive")
  end

  def test_provision_number
    @response = Phaxio.provision_number(country_code: 1, area_code: 847)
    assert_equal true, @response["success"]
    assert_equal "Number provisioned successfully!", @response["message"]
    assert_equal "Illinois", @response["data"]["state"]
  end

  def test_release_number
    @response = Phaxio.release_number(number: "8021112222")
    assert_equal true, @response["success"]
    assert_equal "Number released successfully!", @response["message"]
  end

  def test_list_numbers
    @response = Phaxio.list_numbers(country_code: 1, area_code: 802)
    assert_equal true, @response["success"]
    assert_equal "Retrieved user phone numbers successfully", @response["message"]
  end

  def test_get_fax_file
    @response_pdf = Phaxio.get_fax_file(id: 1234)
    assert_equal 6725, @response_pdf.size
  end

  def test_list_faxes
    @response = Phaxio.list_faxes(created_after: 1293861600, created_before: 1294034400)
    assert_equal true, @response["success"]
  end

  def test_get_fax_status
    @response = Phaxio.get_fax_status(id: 123456)
    assert_equal true, @response["success"]
    assert_equal "Metadata for fax", @response["message"]
  end

  def test_cancel_fax
    @response = Phaxio.cancel_fax(id: 123456)
    assert_equal true, @response["success"]
    assert_equal "Fax cancellation scheduled successfully.", @response["message"]
  end

  def test_delete_fax
    Phaxio.expects(:send_delete).with('/faxes/1234', {})
    Phaxio.delete_fax(id: 1234)
  end

  def test_get_account_status
    @response = Phaxio.get_account_status
    assert_equal true, @response["success"]
    assert_equal "Account status retrieved successfully", @response["message"]
    assert_equal 15, @response["data"]["faxes_this_month"]["sent"]
  end

  def test_generate_check_signature
    signature = Phaxio.generate_check_signature(*@callback_data)
    assert_equal '15adeecb7eca79676ece07ee4bc1bbba2c69eddd', signature
  end

  def test_valid_callback_signature?
    assert_equal true, Phaxio.valid_callback_signature?(
      '15adeecb7eca79676ece07ee4bc1bbba2c69eddd', *@callback_data)
    assert_equal false, Phaxio.valid_callback_signature?(
      'wrong', *@callback_data)
  end

  def test_create_phaxcode
    Phaxio.expects(:send_post).with('/phax_codes', {})
    Phaxio.create_phaxcode
  end

  def test_supported_countries
    Phaxio.expects(:get).with('/public/countries', query: {})
    Phaxio.supported_countries
  end

  def test_area_codes
    Phaxio.expects(:get).with('/public/area_codes', query: { country_code: 1, state: 'IL' })
    Phaxio.area_codes(country_code: 1, state: 'IL')
  end
end
