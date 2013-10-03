class RoomsController < ApplicationController

  def show
    puts params
    max_occupied_room_count()

    @topics = Topic.top_popular
    @topic = Topic.find(params[:id])

    received_session_id = params[:sessionId]

    if !received_session_id.nil? && received_session_id.length>10 && received_session_id.length<300 
      @room = Room.room_with_session_or_next_available(received_session_id, @topic, params)
    else
      @room = Room.create_or_join(@topic, params)
    end
    @position = params[:position]

    puts "CONTROLLER::::::::::::::::::::::::::::::::::::::::::::: show"
    puts @room.to_json
    puts @room.topic.title unless @room.topic.title.nil?



    if params[:position] == 'observe'
      observe()
    else
      @token = Room.publisher_token(@room.session_id)
      respond_to do |format|
        format.json { render :json => { 'Room' => {token: @token, session_id: @room.session_id, room_id: @room.id, title: @topic.title}}}
        format.html {@token}
      end
    end
  end

  def observe
    redirect_to '/' and return if @room.nil?
    @token = Room.subscriber_token @room.session_id

    puts "CONTROLLER:::: OBSERVE"
    puts @room.topic.title unless @room.topic.title.nil?
    puts @room.to_json
    @observer = @room.add_observer
    respond_to do |format|
      format.json { render :json => { 'Room' => {token: @token, session_id: @room.session_id, room_id: @room.id, title: @topic.title}}}
      format.html #{@token @observer}
    end
  end

  def close
    puts params
  	Room.find(params[:id]).close params[:position], params[:observer_id]
    if params[:position] != 'observe'
      session['shouting'] -= 1
    end
    render :text => "Room Closed", :status => 204
  end

  def max_occupied_room_count
    session['shouting'] ||= 0
    if session['shouting'] > 500 and params[:position] != 'observe'
      redirect_to root_path, notice: "don't spread yourself too thin! one shout at a time" and return
    else
      if params[:position] != 'observe'
        session['shouting'] += 1
      end
    end
  end

end
