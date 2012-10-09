class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :session_id, :position_1, :position_2, :closed

  def self.create_or_join(topic, params)
    if params[:position] == 'observe'
      selected_room = Room.observe(topic)
    else
      position = params[:position] == 'agree' ? "position_2" : "position_1"
    	selected_room = Room.where("(? is null or ? = '') and topic_id = ? and closed = '0'", position, topic.id).shuffle.first
      session = !selected_room ? OTSDK.createSession.to_s : selected_room.session_id
      
      if !selected_room
        selected_room = topic.rooms.create({ session_id: session, :"#{position}" => publisher_token(session) })
      else
        selected_room.update_attribute(position, publisher_token(session))
      end
    end

    selected_room
  end

  def close(position)
    update_attribute(position, nil)
    update_attribute('closed', true) if position_1.nil? and position_2.nil?
  end

  def self.observe(topic)
    Room.where("position_1 is not null OR position_2 is not null and topic_id = ? and closed ='0'", topic.id).shuffle.first rescue nil
  end

  def self.publisher_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def self.subscriber_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER
  end

end
