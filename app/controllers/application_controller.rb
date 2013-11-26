class ApplicationController < ActionController::Base

	def iOS_user_agent?
		@user_agent ||= request.user_agent.try :match, /(iphone|ipod)/i 
		puts "@user_agent: #{@user_agent}"
		puts "request.user_agent: #{@request.user_agent}" 
	end

	helper_method :iOS_user_agent?
end
