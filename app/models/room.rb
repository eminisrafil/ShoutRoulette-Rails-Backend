class Room < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :position_1, :position_2, :closed

  def create_or_join(params)
    selected_room = Room.find_all_by_topic(Topic.find(params[:id])).shuffle
    if !selected_room
      selected_room = Room.create({ something: params[:id], })
    else
      generate_token
      position = params[:position] == 'agree' ? :position_2 : :position_1
      selected_room.update_attribute(position, token)
    end
    selected_room
  end

  def generate_session(request)
    # Creating Session object, passing request IP address to determine closest production server
    session_id = OTSDK.createSession(request.remote_ip)
    
    # Creating Session object with p2p enabled
    sessionProperties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}    # or disabled
    sessionId = OTSDK.createSession( @location, sessionProperties )
    return sessionId
  end
  
  
  def generate_publisher(session)
    token = OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER, :connection_data => "username=Bob,level=4"
    return token
  end

  def generate_subscriber(session)
    token = OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER, :connection_data => "username=Bob,level=4"
    return token
  end

end
