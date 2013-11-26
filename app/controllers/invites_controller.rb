class InvitesController < ApplicationController
  def index
  	puts "###User Agent is coming up###"
    puts request.user_agent
    room_id = params[:room_id].to_i
    @path = "/room/#{room_id}/#{params[:room_position]}?q=#{params[:q]}"
    @topic_title = Room.find(room_id).topic.title
    @position = :room_position

    #check ios version: http://stackoverflow.com/questions/18905686/itunes-review-url-and-ios-7-ask-user-to-rate-our-app-appstore-show-a-blank-pag

    if iOS_user_agent?
      respond_to do |format|
        format.html { render "/invites/index.html.haml"}
      end
    else
      redirect_to @path
  	end
  end

  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.json { render :json => { message: "Not found, foghetaboutit"}, :status => 200}
      format.html { redirect_to '/', :flash => { :notice => "Room Not Found" }}
    end
  end
end
