class RoomsController < ApplicationController

  def show
    @topics = Topic.top_popular
    @topic = Topic.find(params[:id])
    @room = Room.create_or_join(@topic, params, request)
    @position = params[:position]
    if @room.nil?
      redirect_to '/' and return
    end
  end

  def close
    @room = Room.find(params[:id])
  	@room.close(params[:position])
    UserSession.close_sess(request)
    render text: "room closed"
  end

end
