class ApplicationController < ActionController::Base

	def mobile_user_agent?
		#check user agents
		@mobile_user_agent ||= ( request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/] )
		session[:isMobile] = 1 
	end

	def iOS_user_agent?
		@user_agent ||= request.user_agent.try :match, /(iPhone|ipod)/i 
	end

	def prepare_for_mobile
		session[:isMobile] = params[:isMobile] if  params[:isMobile]
		request.format = :mobile if mobile_user_agent?
	end

	helper_method :iOS_user_agent?
end
