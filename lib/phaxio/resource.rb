module Phaxio
  class Resource
    attr_accessor :raw_data

    def initialize raw_data
      self.raw_data = raw_data
    end

    class << self
      def response_record raw_data
        new raw_data
      end

      def response_collection raw_data
        Collection.new raw_data
      end
    end

    class Collection
      attr_accessor :raw_data

      def initialize raw_data
        self.raw_data = raw_data
      end
    end
  end
end
