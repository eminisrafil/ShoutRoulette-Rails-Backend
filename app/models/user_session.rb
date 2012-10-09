class UserSession < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :topic_id, :ip_address, :observing, :last_checked, :token_id

  def self.log_user(request, topic, params)
  	observe = params[:position] == 'observe' ? true : false
  	sess = UserSession.find(:first, :conditions=>{:ip_address => request.session_options[:id].to_s})
  	if !sess
  		UserSession.create({topic_id: topic.id, ip_address: request.session_options[:id].to_s, observing: observe, last_checked: Time.now})
  	else
  		sess.update_attributes({topic_id: topic.id, observing: observe, last_checked: Time.now})
  	end
  end
end
