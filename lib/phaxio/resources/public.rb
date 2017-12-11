module Phaxio
  module Resources
    module Public
    end
  end
end

Dir[File.expand_path(File.join('..', 'public', '*.rb'), __FILE__)].each { |file| require file }
