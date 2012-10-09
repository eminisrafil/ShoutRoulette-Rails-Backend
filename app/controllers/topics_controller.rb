class TopicsController < ApplicationController
	def newtopic
		topic = Topic.new({'title': params[:topic]})
		render :json => topic 
	end

end
