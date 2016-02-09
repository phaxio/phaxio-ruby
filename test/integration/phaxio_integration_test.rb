require_relative '../test_helper'
require 'json'

class PhaxioIntegrationTest < MiniTest::Test
  def setup
    FakeWeb.clean_registry

    Phaxio.config do |config|
      config.api_key = ENV.fetch('PHAXIO_TEST_API_KEY')
      config.api_secret = ENV.fetch('PHAXIO_TEST_API_SECRET')
    end

    @fax_number = '2025550168'
    @responses_path = File.expand_path('../../support/responses/', __FILE__)
  end

  def test_resend_fax
    original_response = Phaxio.send_fax(
      to: @fax_number, string_data: 'test', test_fail: 'faxError'
    )
    original_fax_id = original_response['faxId']
    sleep(5)
    response = Phaxio.resend_fax(id: original_fax_id).to_h
    new_fax_id = response['data']['faxId']
    expected_string = File.read("#{@responses_path}/resend_success.json")
                          .gsub('FAX_ID', new_fax_id.to_s)
    expected = JSON.parse expected_string
    assert_equal expected, response
  end

  def test_delete_fax
    original_response = Phaxio.send_fax(to: @fax_number, string_data: 'test')
    id = original_response['faxId']
    sleep(5)
    expected = JSON.parse File.read("#{@responses_path}/delete_success.json")
    response = Phaxio.delete_fax(id: id).to_h
    assert_equal expected, response
  end
end
