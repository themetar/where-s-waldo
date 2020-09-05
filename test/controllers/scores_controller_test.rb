require 'test_helper'

class ScoresControllerTest < ActionDispatch::IntegrationTest

  def guess_all(scene)
    scene.character_locations
      .map { |char_loc| {x: char_loc.x, y: char_loc.y, character: char_loc.character} }
      .each do |params|
        post guess_play_path(scene),
          params: params,
          xhr: true
      end
  end

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
    guess_all(scene)

    # game won
    # post score
    assert_difference "Score.count", 1 do
      post play_scores_path(scenes(:beach)), params: {player_name: "P. Erson"}
    end
    assert_response :redirect
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
