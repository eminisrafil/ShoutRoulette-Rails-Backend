class RoomsController < ApplicationController

  def show

    session['shouting'] ||= 0
    puts "session info => #{session}"
    if session['shouting'] > 10 and params[:position] != 'observe'
      redirect_to root_path, notice: "don't spread yourself too thin! one shout at a time" and return
    else
      if params[:position] != 'observe'
        session['shouting'] += 1
      end
    end

    @topics = Topic.top_popular
    @topic = Topic.find(params[:id])
    @room = Room.create_or_join(@topic, params, request)
    @position = params[:position]


    puts "position => #{@position}"


    if params[:position] == 'observe'
      redirect_to '/' and return if @room.nil?
      @token = Room.subscriber_token @room.session_id
      @observer = @room.add_observer
    else
      @token = Room.publisher_token(@room.session_id)
      puts "token => #{@token}"
      respond_to do |format|
        format.json { render :json => { 'Room' => {token: @token, session_id: @room.session_id} }
        format.html {@token}
      end
    end
  end

  def close
  	Room.find(params[:id]).close params[:position], params[:observer_id]
    if params[:position] != 'observe'
      session['shouting'] -= 1
    end
    render text: "room closed"
  end

end
