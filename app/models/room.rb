class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :session_id, :position_1, :position_2, :closed

	OTSDK = OpenTok::OpenTokSDK.new '20193772', 'cf90dfef4da7ba913239ee34e3d0a387411cd2e5'

  def create_or_join(params)

    @topic = Topic.find(params[:id])
    position = params[:position] == 'agree' ? "position_2" : "position_1"
  	selected_room = Room.where("#{position} is null").shuffle.first

    if !selected_room
    	session = generate_session(params[:ip_address]).to_s
      selected_room = @topic.rooms.create({ session_id: session })
      selected_room[position] = generate_publisher(session)
      selected_room.save!
    else
      selected_room.update_attribute(position, generate_publisher(selected_room.session_id))
    end

    selected_room
  end

  def generate_session(request)
    # Creating Session object, passing request IP address to determine closest production server
    session_id = OTSDK.createSession(request)
    
    # Creating Session object with p2p enabled
    sessionProperties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}    # or disabled
    sessionId = OTSDK.createSession( @location, sessionProperties )
    return sessionId
  end
  
  
  def generate_publisher(session)
    token = OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
    return token
  end

  def generate_subscriber(session)
    token = OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER, :connection_data => "username=Bob,level=4"
    return token
  end

end
