class ScoresController < ApplicationController
  def index
  end

  def new
  end

  def create
    scene_id = params[:play_id].to_i

    if scene_id != session[:game_data]["scene"]
      head :bad_request and return
    end

    unless session[:game_data]["won"]
      redirect_to play_path(scene_id) and return
    end

    scene = Scene.find(scene_id)
    end_time = Time.parse(session[:game_data]["end_time"])
    start_time = Time.parse(session[:game_data]["start_time"])
    scene.scores.create(player_name: params[:player_name], time: (end_time - start_time).round)
    session[:game_data] = nil # clear
    redirect_to play_scores_url(scene_id)
  end
end
