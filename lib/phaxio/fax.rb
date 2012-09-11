module Phaxio
  class Fax
    attr_accessor :id, :recipient, :filename, :string_data, :string_data_type,
                  :batch, :batch_delay, :batch_collision_avoidance,
                  :callback_url, :cancel_timeout, :api_key, :api_secret

  end
end
