module Phaxio
  # @api private
  module MimeTypeHelper
    class << self
      def extension_for_mimetype mimetype
        MIME::Types[mimetype].first.extensions.first
      end

      def mimetype_for_file file_path
        MIME::Types.of(file_path).first.content_type
      end
    end
  end
end