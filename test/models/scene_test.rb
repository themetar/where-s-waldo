require 'test_helper'

class SceneTest < ActiveSupport::TestCase
  test "should get character locations" do
    beach = scenes(:beach)
    assert_equal 4, beach.character_locations.size
  end
end
