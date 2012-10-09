class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :session_id, :position_1, :position_2, :closed
	API_KEY = '20193772'                # should be a string
	API_SECRET = 'cf90dfef4da7ba913239ee34e3d0a387411cd2e5' 	           # should be a string
	OTSDK = OpenTok::OpenTokSDK.new API_KEY, API_SECRET
  def create_or_join(params)
	position = params[:position] == 'agree' ? "position_2" : "position_1"
  	selected_room = Room.where("#{position} is null").shuffle.first
    if !selected_room
    	session = generate_session(params[:ip_address]).to_s
      selected_room = Topic.find(params[:id]).rooms.create({ session_id: session })
      selected_room[position] = generate_publisher(session)
      selected_room.save!
    else
      selected_room.update_attribute(position, generate_publisher(selected_room.session_id))
    end
    return selected_room
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

  def get_session
    # write this method
  end

  def get_token
    # write this method
  end

end
