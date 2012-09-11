module Phaxio
  class Fax
    attr_accessor :id, :to_number, :from_number, :filename, :string_data, :string_data_type,
                  :batch, :batch_delay, :batch_collision_avoidance,
                  :callback_url, :cancel_timeout

    def self.build(&block)
      Fax.new.tap do |fax|
        yield fax
      end
    end
  end
end
