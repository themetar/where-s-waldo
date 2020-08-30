class StaticPagesController < ApplicationController
  def home
    @scenes = Scene.all
  end
end
