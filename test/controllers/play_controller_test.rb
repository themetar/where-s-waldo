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

  test "should set session cookie" do
    scene = scenes(:beach)

    # navigate to game
    get play_path(scene)
    assert_equal  scene.id, session[:game_data]["scene"]
    assert_equal  ({"waldo" => false, "wenda" => false, "odlaw" => false, "wizard" => false}),
      session[:game_data]["found"]
    assert      session[:game_data]["start_time"]
    assert_not  session[:game_data]["end_time"]
    assert_nil  session[:game_data]["won"]
    
    # guess correctly for odlaw
    post guess_play_path(scene.id),
      params: {x: 265, y: 524, character: "odlaw"},
      xhr: true
    assert_equal  scene.id, session[:game_data]["scene"]
    assert_equal  ({"waldo" => false, "wenda" => false, "odlaw" => true, "wizard" => false}),
      session[:game_data]["found"]
    assert      session[:game_data]["start_time"]
    assert_not  session[:game_data]["end_time"]
    assert_nil  session[:game_data]["won"]

    # guess correctly for wizard and waldo
    post guess_play_path(scene.id),
      params: {x: 670, y: 542, character: "wizard"},
      xhr: true
    
    post guess_play_path(scene.id),
      params: {x: 1600, y: 600, character: "waldo"},
      xhr: true

    # guess correctly for wenda
    # game won
    post guess_play_path(scene.id),
      params: {x: 2010, y: 615, character: "wenda"},
      xhr: true
    assert_equal  scene.id, session[:game_data]["scene"]
    assert_equal  ({"waldo" => true, "wenda" => true, "odlaw" => true, "wizard" => true}),
      session[:game_data]["found"]
    assert  session[:game_data]["start_time"]
    assert  session[:game_data]["end_time"]
    assert  session[:game_data]["won"]
  end
end
