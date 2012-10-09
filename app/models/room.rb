class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :session_id, :agree, :disagree, :closed

  def self.create_or_join(topic, params, request)

    if params[:position] == 'observe'
      selected_room = Room.observe(topic)
    else
    	selected_room = Room.where("#{params[:position]} is null and topic_id = '#{topic.id}' and (closed = '0' or closed is null)").shuffle.first
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

  def close(position)
    update_column(position, nil)
    update_column('closed', true) if position_1.nil? and position_2.nil?
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
