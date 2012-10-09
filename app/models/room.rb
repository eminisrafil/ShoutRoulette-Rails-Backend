class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :session_id, :position_1, :position_2, :closed

  def create_or_join(topic, params)

    position = params[:position] == 'agree' ? "position_2" : "position_1"
  	selected_room = Room.where("? is null", position).shuffle.first

    if !selected_room
    	session = session().to_s
      selected_room = topic.rooms.create({ session_id: session })
      selected_room[position] = generate_publisher(session)
      selected_room.save!
    else
      selected_room.update_attribute(position, generate_publisher(selected_room.session_id))
    end

    selected_room
  end

  def observe(params)



  end

  def session()
    return OTSDK.createSession()
  end
  
  
  def generate_token(session, role = 'PUBLISHER') ##role = PUBLISHER or SUBSCRIBER
    token = OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
    return token
  end

  def generate_subscriber(session)
    token = OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER
    return token
  end

end
