class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :session_id, :position_1, :position_2, :closed

  def create_or_join(topic, params)

    position = params[:position] == 'agree' ? "position_2" : "position_1"
  	selected_room = Room.where("? is null", position).shuffle.first

    if !selected_room
    	session = generate_session(params[:ip_address]).to_s
      selected_room = topic.rooms.create({ session_id: session, :"#{position}" => generate_publisher(session) })
    else
      selected_room.update_attribute(position, generate_publisher(selected_room.session_id))
    end

    selected_room
  end

  def generate_session(request)
    session_id = OTSDK.createSession(request)
    sessionProperties = { OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled" }
    sessionId = OTSDK.createSession @location, sessionProperties
  end
  
  
  def generate_publisher(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def generate_subscriber(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER, :connection_data => "username=Bob,level=4"
  end

end
