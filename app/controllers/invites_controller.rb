class InvitesController < ApplicationController
  def index
  	puts "###User Agent is coming up###"
    puts request.user_agent
    room_id = params[:room_id].to_i
    @path = "/room/#{room_id}/#{params[:room_position]}?q=#{params[:q]}"
    @topic_title = Room.find(room_id).topic.title
    @position = :room_position
    puts "@topic_title #{@topic_title}"
    puts "iOS_user_agent? : #{iOS_user_agent?}"
    #check ios version: http://stackoverflow.com/questions/18905686/itunes-review-url-and-ios-7-ask-user-to-rate-our-app-appstore-show-a-blank-pag

    if iOS_user_agent?
      respond_to do |format|
        puts "rendering invites.html.haml!"
        format.html { render "/invites/index.html.haml"}
      end
    else
      puts "REDIRECTING TO @PATH #### #{iOS_user_agent?}" 
      redirect_to @path
  	end
  end

  rescue_from ActiveRecord::RecordNotFound do
    @topic_title = "Click here to start shouting!"
    puts "ACTIVE RECORD FAILED TO FIND THAT SHIT"
    puts "iOS_user_agent? : #{iOS_user_agent?}"
    if iOS_user_agent?
      respond_to do |format|
        format.html { render "/invites/index.html.haml"}
      end
    else
      puts "REDIRECTING TO @PATH #### #{iOS_user_agent?}" 
      redirect_to @path
    end
  end
end
