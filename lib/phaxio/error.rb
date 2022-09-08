module Phaxio
  module Error
    PhaxioError = Class.new StandardError
    %w[
      AuthenticationError
      NotFoundError
      InvalidRequestError
      RateLimitExceededError
      ServiceUnavailableError
      GeneralError
      ApiConnectionError
    ].each { |error_klass_name| const_set error_klass_name, Class.new(PhaxioError) }
  end
end
