class ScoresController < ApplicationController
  def index
    @scene = Scene.find(params[:play_id])
    @page = (params[:page] || 1).to_i
    @per_page = 30
    @scores = @scene.scores.order(time: :ASC, created_at: :ASC).limit(@per_page).offset((@page - 1) * @per_page)
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

    @scene = Scene.find(scene_id)
    end_time = Time.parse(session[:game_data]["end_time"])
    start_time = Time.parse(session[:game_data]["start_time"])
    @score = @scene.scores.build(player_name: params[:player_name], time: (end_time - start_time).round)
    if @score.save
      session[:game_data] = nil # clear
      redirect_to play_scores_url(scene_id)
    else
      render :new
    end
  end
end
