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

  test "should list scenes scores" do
    get play_scores_path(scenes(:beach))
    assert_match "Player 3", response.body 
  end

  test "should sort scores by time" do
    get play_scores_path(scenes(:beach))
    assert_select "li:first-child", "Player 3 10"
  end

  test "should page scores" do
    get play_scores_path(scenes(:beach), page: 2)
    assert_select "li:first-child", "Player 31 290"
  end

  test "show should redirect to page of index" do
    score = scores(:score_70)
    get score_path(score)
    assert_response :redirect
    assert_redirected_to play_scores_path(score.scene, page: 3, anchor: score.id)
  end
end
