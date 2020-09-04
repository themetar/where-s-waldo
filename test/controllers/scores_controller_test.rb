require 'test_helper'

class ScoresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get play_scores_path(scenes(:beach))
    assert_response :success
  end

  test "should get new" do
    get new_play_score_path(scenes(:beach))
    assert_response :success
  end

  test "should add a score" do
    scene = scenes(:beach)

    # navigate to game
    get play_path(scene)
    
    # guess correctly for odlaw, wizard, waldo and wenda
    post guess_play_path(scene.id),
      params: {x: 265, y: 524, character: "odlaw"},
      xhr: true
    post guess_play_path(scene.id),
      params: {x: 670, y: 542, character: "wizard"},
      xhr: true
    post guess_play_path(scene.id),
      params: {x: 1600, y: 600, character: "waldo"},
      xhr: true
    post guess_play_path(scene.id),
      params: {x: 2010, y: 615, character: "wenda"},
      xhr: true

    # game won
    # post score
    assert_difference "Score.count", 1 do
      post play_scores_path(scenes(:beach)), params: {player_name: "P. Erson"}
      assert_response :redirect
    end
    assert_nil session[:game_data]
  end

  test "should reject posting to other scene's scores" do
    scene = scenes(:beach)
    get play_path(scene)

    post play_scores_path(scene.id + 2), params: {player_name: "P. Erson"}
    assert_response :bad_request
  end

  test "should redirect to unfinished game" do
    scene = scenes(:beach)
    get play_path(scene)

    post play_scores_path(scene), params: {player_name: "P. Erson"}
    assert_response :redirect
    assert_redirected_to play_path(scene)
  end
end
