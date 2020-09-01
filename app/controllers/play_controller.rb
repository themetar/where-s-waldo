class PlayController < ApplicationController
  def show
    @scene = Scene.find(params[:id])
    session[:game_data] = {}
  end

  def guess
    respond_to do |format|
      count = session[:game_data]["guess"]
      format.json do
        session[:game_data] = {}
        render json: {}
      end
    end
  end
end
