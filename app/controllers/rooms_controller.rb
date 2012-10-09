class RoomsController < ApplicationController

  def show
    @topic = Topic.find(params[:id])
    @room = Room.create_or_join(@topic, params)
  end

  def close ##recieves room_id and position as params
  	Room.close(params)
  end

end
