require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  test "should get scene association" do
    assert_equal scenes(:beach), scores(:one).scene
  end
end
