class RoomsController < ApplicationController

  def show
    @topic = Topic.find(params[:id])
    if params[:position] == 'observe'
    	@room = Room.observe(@topic)
    else
    	@position = params[:position] == 'agree' ? "position_2" : "position_1"
    	@room = Room.create_or_join(@topic, params)
    end
  end

  def close
    @room = Room.find(params[:id])
  	@room.close(params[:position])
    render text: "room closed"
  end

end
