class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :session_id, :position_1, :position_2, :closed

  def create_or_join(topic, params)

    position = params[:position] == 'agree' ? "position_2" : "position_1"
  	selected_room = Room.where("? is null", position).shuffle.first

    if !selected_room
    	session = session().to_s
      selected_room = topic.rooms.create({ session_id: session, :"#{position}" => generate_publisher(session) })
    else
      selected_room.update_attribute(position, generate_publisher(selected_room.session_id))
    end

    selected_room
  end

  def observe(params)
    Room.where("position_1 is not null OR position_2 is not null").shuffle.first rescue nil
  end

  def session()
    OTSDK.createSession()
  end
  
  def publisher_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def subscriber_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER
  end

end
