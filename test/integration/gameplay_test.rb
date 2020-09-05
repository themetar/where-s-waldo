require 'test_helper'

class GameplayTest < ActionDispatch::IntegrationTest
  test "should play a full game" do
    scene = scenes(:beach)

    # navigate to game
    get play_path(scene)
    assert_response :success

    # guess wrong for waldo
    post guess_play_path(scene.id),
      params: {x: 100, y: 100, character: "waldo"},
      xhr: true
    assert_response :success
    assert_equal ({"result" => "miss", "remaining" => scene.character_locations.map(&:character)}),
      JSON.parse(@response.body)
    
    # guess correctly for odlaw
    post guess_play_path(scene.id),
      params: {x: 265, y: 524, character: "odlaw"},
      xhr: true
    assert_response :success
    assert_equal ({"result" => "hit", "remaining" => ["waldo", "wenda", "wizard"]}),
      JSON.parse(@response.body)

    # guess wrongly for wenda
    post guess_play_path(scene.id),
      params: {x: 1000, y: 1000, character: "wenda"},
      xhr: true
    assert_response :success
    assert_equal ({"result" => "miss", "remaining" => ["waldo", "wenda", "wizard"]}),
      JSON.parse(@response.body)

    # guess correctly for wizard
    post guess_play_path(scene.id),
      params: {x: 670, y: 542, character: "wizard"},
      xhr: true
    assert_response :success
    assert_equal ({"result" => "hit", "remaining" => ["waldo", "wenda"]}),
      JSON.parse(@response.body)

    # guess correctly for waldo
    post guess_play_path(scene.id),
      params: {x: 1600, y: 600, character: "waldo"},
      xhr: true
    assert_response :success
    assert_equal ({"result" => "hit", "remaining" => ["wenda"]}),
      JSON.parse(@response.body)

    # guess correctly for wenda
    # game won
    post guess_play_path(scene.id),
      params: {x: 2010, y: 615, character: "wenda"},
      xhr: true
    assert_response :success
    response_data = JSON.parse(@response.body)
    assert_equal "hit", response_data["result"]
    assert_equal true, response_data["won"]
    assert_not_nil response_data["time"]
      
  end
end
