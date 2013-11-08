class InvitesController < ApplicationController
  def index
  	puts "###User Agent is coming up###"
    puts request.user_agent
    @path = "/room/#{params[:room_id]}/#{params[:room_position]}?q=#{params[:q]}"
    #check ios version: http://stackoverflow.com/questions/18905686/itunes-review-url-and-ios-7-ask-user-to-rate-our-app-appstore-show-a-blank-pag
    if request.user_agent.match(/iPhone/i) 
      render "/invites/index.html.erb"
    else
      redirect_to @path
  	end
  end
end
