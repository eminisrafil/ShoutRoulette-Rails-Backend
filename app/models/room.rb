class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :session_id, :agree, :disagree, :closed

  def self.create_or_join(topic, params, request)

    if params[:position] == 'observe'
      selected_room = Room.find_observable_room(topic)
    else
      throw 'dont hack me bro' unless params[:position] == 'agree' or params[:position] == 'disagree' 
    	selected_room = Room.where("#{params[:position]} = null and topic_id = '#{topic.id}'").shuffle.first
      session = !selected_room ? OTSDK.createSession.to_s : selected_room.session_id
      if !selected_room
        selected_room = topic.rooms.create({ session_id: session, :"#{params[:position]}" => 'full' })
      else
        selected_room.update_column(params[:position], 'full')
      end
    end

    UserSession.log_user(request, selected_room, params)
    selected_room

  end

  def self.find_observable_room(topic)
    room = Room.where("agree != null and disagree != null and topic_id = ?", topic.id).shuffle.first
    room = Room.where("agree != null or disagree != null and topic_id = ?", topic.id).shuffle.first if room.nil?
  end

  def self.publisher_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def self.subscriber_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER
  end

  def close(position)
    update_attribute(position, nil) unless position == 'observe'
    update_attribute('closed', true) if agree.nil? and disagree.nil?
  end

end
