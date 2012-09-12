require "test_helper"

class TestClient < Test::Unit::TestCase
  def setup
    @client = Phaxio::Client.new("abc123", "def456")
  end
end
