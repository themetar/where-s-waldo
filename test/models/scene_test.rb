require 'test_helper'

class SceneTest < ActiveSupport::TestCase
  test "should get character locations" do
    beach = scenes(:beach)
    assert_equal 4, beach.character_locations.size
  end

  test "should get scores" do
    assert_equal 2, scenes(:beach).scores.size
  end

  test "should create new score" do
    assert_difference "Score.count", 1 do
      scenes(:beach).scores.create({player_name: "Harry LeSape", time: 200})
    end
  end
end
