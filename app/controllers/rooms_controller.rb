class RoomsController < ApplicationController

  def show
    @topics = Topic.top_popular
    @topic = Topic.find(params[:id])
    @room = Room.create_or_join(@topic, params, request)
    if params[:position] == 'observe'
      if @room.nil?
        redirect_to '/' and return
      else
        @token = Room.subscriber_token(@room.session_id)
      end
    else
      @token = Room.publisher_token(@room.session_id)
    end
  end

  def close
    @room = Room.find(params[:id])
  	@room.close(params[:position])
    UserSession.close_sess(request)
    render text: "room closed"
  end

end
