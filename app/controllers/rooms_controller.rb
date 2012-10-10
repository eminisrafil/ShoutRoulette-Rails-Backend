class RoomsController < ApplicationController

  def show
    @topics = Topic.top_popular
    @topic = Topic.find(params[:id])
    @room = Room.create_or_join(@topic, params, request)
    @position = params[:position]

    if params[:position] == 'observe'
      redirect_to '/' and return if @room.nil?
      @token = Room.subscriber_token @room.session_id
      @observer = @room.add_observer
    else
      @token = Room.publisher_token(@room.session_id)
    end

  end

  def close
  	Room.find(params[:id]).close params[:position], params[:observer_id]
    render text: "room closed"
  end

end
