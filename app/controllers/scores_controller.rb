class ScoresController < ApplicationController
  PER_PAGE = 30

  def index
    @scene = Scene.find(params[:play_id])
    page = (params[:page] || 1).to_i
    per_page = PER_PAGE
    @scores = @scene.scores.order(time: :ASC, created_at: :ASC, id: :ASC).limit(per_page).offset((page - 1) * per_page)
    total_scores = @scene.scores.count
    @pagination = {
      page: page,
      per_page: per_page,
      pages: total_scores / per_page + 1
    }
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
      redirect_to score_url(@score)
    else
      render :new
    end
  end

  def show
    score = Score.find(params[:id])
    count_so_far = Score.where("time < :game_time", {game_time: score.time})
                        .or(Score.where("time = :game_time AND created_at < :at_stamp",
                                          {game_time: score.time, at_stamp: score.created_at}))
                        .or(Score.where("time = :game_time AND created_at = :at_stamp AND id <= :id",
                                          {game_time: score.time, at_stamp: score.created_at, id: score.id}))
                        .count
    redirect_to play_scores_url(score.scene, page: count_so_far / PER_PAGE + 1, anchor: score.id)
  end
end
