class RoomsController < ApplicationController

  def show
    @topic = Topic.find(params[:id])
    @room = Room.create_or_join(@topic, params)
  end

end
