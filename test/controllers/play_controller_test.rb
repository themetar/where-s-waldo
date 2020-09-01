require 'test_helper'

class PlayControllerTest < ActionDispatch::IntegrationTest
  test "should get play scene" do
    get play_url(scenes(:beach))
    assert_response :success
    assert session[:game_data]
  end

  test "should make a guess" do
    get play_url(scenes(:beach))
    post guess_play_path(scenes(:beach)), xhr: true, params: {}
    assert_response :success
    assert_equal "application/json", @response.media_type
    assert session[:game_data]
  end
end
