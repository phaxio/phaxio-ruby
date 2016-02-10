require_relative '../test_helper'
require 'json'

class PhaxioIntegrationTest < MiniTest::Test
  def setup
    FakeWeb.clean_registry
    configure

    @fax_number = '2025550168'
  end

  def test_resend_fax
    send_fax(test_fail: 'faxError')
    response = Phaxio.resend_fax(id: @send_fax_response['faxId'])
    assert response['success']
    assert_equal 'Fax queued for resend', response['message']
    assert response['data']['faxId'].integer?
  end

  def test_delete_fax
    send_fax
    response = Phaxio.delete_fax(id: @send_fax_response['faxId'])
    assert response['success']
    assert_equal 'Deleted fax successfully!', response['message']
  end

  private

  def configure
    Phaxio.config do |config|
      config.api_key = ENV.fetch 'PHAXIO_TEST_API_KEY'
      config.api_secret = ENV.fetch 'PHAXIO_TEST_API_SECRET'
    end
  rescue KeyError
    raise(KeyError, 'You must set PHAXIO_TEST_API_KEY and ' \
      'PHAXIO_TEST_API_SECRET to run integration tests')
  end

  # Convenience method for actions requiring an existing fax
  def send_fax(options = {})
    params = options.merge(to: @fax_number, string_data: 'test')
    @send_fax_response = Phaxio.send_fax(params)
    sleep(5)
  end
end
