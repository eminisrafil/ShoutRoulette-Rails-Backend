class UserSession < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :ip_address, :observing, :last_checked, :token_id

  def log_user(request, topic, params)
  	observe = params[:position] == 'observe' ? true : false
  	sess = UserSession.find(:first, :conditions=>{:ip_address => request.session_options[:id].to_s})
  	if !sess
  		UserSession.create({'topic_ic': topic.id, 'ip_address': request.session_options[:id].to_s, 'observing': observe})
  	else
  		sess.update_attributes('topic_id', topic.id, 'observing': observe)
  	end
  end
end
