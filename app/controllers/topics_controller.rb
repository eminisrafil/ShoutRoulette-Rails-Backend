class TopicsController < ApplicationController

  def new
    Topic.create({ title: params[:topic] })
    redirect_to root_path
  end

end
