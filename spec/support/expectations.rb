module PhaxioExpectations
  def expect_api_request method, path, params = {}, options = {}
    expect(Phaxio::Client).to receive(:request).with(method, path, params, options).and_call_original
  end
end

RSpec.configure do |config|
  config.include PhaxioExpectations
end
