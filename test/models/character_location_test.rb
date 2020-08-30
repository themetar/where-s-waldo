require 'test_helper'

class CharacterLocationTest < ActiveSupport::TestCase
  test "should get scene" do
    waldo_loc = character_locations(:beach_waldo)
    assert_equal scenes(:beach), waldo_loc.scene
  end
end
