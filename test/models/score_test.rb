require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  def setup
    @scene = scenes(:beach)
  end

  test "should get scene association" do
    assert_equal scenes(:beach), scores(:one).scene
  end

  test "should validate presence of time" do
    assert @scene.scores.build(player_name: "Test", time: 123).valid?
    assert @scene.scores.build(player_name: "Test").invalid?
  end

  test "should validate player name presenece and length" do
    assert @scene.scores.build(player_name: "Test", time: 123).valid?
    assert @scene.scores.build(time: 123).invalid?
    assert @scene.scores.build(player_name: "a"*140, time: 123).valid?
    assert @scene.scores.build(player_name: "a"*141, time: 123).invalid?
  end
end
