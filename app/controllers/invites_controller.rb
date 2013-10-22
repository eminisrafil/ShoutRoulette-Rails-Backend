class InvitesController < ApplicationController
  def index
  	puts "###User Agent is coming up###"
    puts request.user_agent
    @path = "/room/#{params[:room_id]}/#{params[:room_position]}?sessionId=#{params[:sessionId]}"
    if request.user_agent.match(/iPhone/i) #&& !request.user_agent.match(/ShoutRoulette/i)
      puts "This nigga has an iphone"
      render "/invites/index.html.erb"
      #redirect_to "/invites/index.html.erb"
      # respond_to do |format|
      #   #format.json { render :json => { 'Room' => {token: @token, session_id: @room.session_id, room_id: @room.id, title: @topic.title}}}
      #   #format.html {@token}
      # end
    else
      puts "doesnt have an iphone"
      redirect_to @path
  	end
  end
end
