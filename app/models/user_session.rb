class UserSession < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :topic_id, :ip_address, :observing, :last_checked, :token_id, :room_id, :session_id

  def self.log_user(request, room, params)
  	observe = params[:position] == 'observe' ? true : false
  	sess = UserSession.find(:first, :conditions=>{:session_id => request.session_options[:id].to_s})
  	if !sess
  		UserSession.create({topic_id: room.topic_id, room_id: room.id, session_id: request.session_options[:id].to_s, observing: observe})
  	else
  		sess.update_attributes({topic_id: room.topic_id, room_id: room.id, observing: observe})
  	end
  end
  def self.close_sess(request)
    sess = UserSession.find(:first, :conditions=>{:session_id => request.session_options[:id].to_s})
    sess.delete
  end
end
