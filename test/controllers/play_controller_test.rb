require 'test_helper'

class PlayControllerTest < ActionDispatch::IntegrationTest
  test "should get play scene" do
    get play_url(scenes(:beach))
    assert_response :success
  end

end
