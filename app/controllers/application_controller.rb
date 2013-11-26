class ApplicationController < ActionController::Base

	def iOS_user_agent?
		puts "yup it's an iphone"
		@user_agent ||= request.user_agent.try :match, /(iphone|ipod)/i 
	end

	helper_method :iOS_user_agent?
end
