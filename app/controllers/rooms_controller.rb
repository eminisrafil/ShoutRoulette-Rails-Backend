class RoomsController < ApplicationController

  def show
    max_occupied_room_count()

    @topics = Topic.top_popular
    @topic = Topic.find(params[:id])

    received_session_id = params[:q]

    if !received_session_id.nil? && received_session_id.length>2 && received_session_id.length<10 
      @room = Room.room_with_session_or_next_available(received_session_id, @topic, params)
    else
      @room = Room.create_or_join(@topic, params)
    end
    @position = params[:position]

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
    if @room.nil?
      room_not_found
      return
    else
      @token = Room.subscriber_token @room.session_id
      @observer = @room.add_observer
      respond_to do |format|
        format.json { render :json => { 'Room' => {token: @token, session_id: @room.session_id, room_id: @room.id, title: @topic.title}}}
        format.html 
      end
    end
  end

  def room_not_found
    respond_to do |format|
      format.json { render :json => { 'Room' => {token: "", session_id: "", room_id:"", title: @topic.title}}}
      format.html {redirect_to '/'}
    end
  end

  def close
    puts "Close request is coming: #{request.fullpath}  ||| params: #{params}"
    if(params[:id].nil? or params[:position].nil?)
      return
    end
  	room = Room.find(params[:id])
    room.close params[:position], params[:observer_id] unless room.nil?
    if params[:position] != 'observe'
      session['shouting'] -= 1
    end

    respond_to do |format|
      format.json { render :json => { message: "ok"}, :status => 200}
      format.html { render :text => "Room Closed", :status => 204}
    end

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

  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.json { render :json => { message: "Not found, foghetaboutit"}, :status => 200}
      format.html {redirect_to '/'}
    end
  end
end
