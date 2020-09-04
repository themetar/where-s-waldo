class PlayController < ApplicationController
  def show
    @scene = Scene.find(params[:id])
    session[:game_data] = {
      "scene" => @scene.id,
      "found" => @scene.character_locations.inject({}) { |acc, char_loc| acc[char_loc.character] = false; acc },
      "start_time" => Time.now
    }
  end

  def guess
    game_data = session[:game_data]
    scene = Scene.find(game_data["scene"])

    char_loc = scene.character_locations.find_by(character: params[:character])
    hit = char_loc && correct_guess?(char_loc.x, char_loc.y, params[:x].to_i, params[:y].to_i)

    game_data["found"][params[:character]] = hit
    remaining = game_data["found"].select { |k, v| !v }.keys

    if remaining.empty?
      game_data["end_time"] = Time.now
      game_data["won"] = true
    end

    session[:game_data] = game_data

    respond_to do |format|
      format.json do
        output = {}
        output[:result] = hit ? "hit" : "miss"
        output[:remaining] = remaining unless remaining.empty?
        output[:won] = true if remaining.empty?
        render json: output
      end
    end
  end

  private

    def correct_guess?(x1, y1, x2, y2)
      Math.sqrt((x1 - x2)**2 + (y1 - y2)**2) < 30 # 30 pixels radius
    end
end
