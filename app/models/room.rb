class Room < ActiveRecord::Base
  # attr_accessible :title, :body
  def generate_session(request)
    # Creating Session object, passing request IP address to determine closest production server
    session_id = OTSDK.createSession(request.remote_ip)
    
    # Creating Session object with p2p enabled
    sessionProperties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}    # or disabled
    sessionId = OTSDK.createSession( @location, sessionProperties )
    return sessionId
  end
  
  
  def generate_publisher(session)
    # Generating a token
    token = OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER, :connection_data => "username=Bob,level=4"
    return token
  end
  def generate_subscriber(session)
    # Generating a token
    token = OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER, :connection_data => "username=Bob,level=4"
    return token
  end
end
