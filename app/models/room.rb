class Room < ActiveRecord::Base
  belongs_to :topic
  has_many :observers
  attr_accessible :session_id, :agree, :disagree, :closed

  def self.create_or_join(topic, params, request)

    if params[:position] == 'observe'
      selected_room = Room.find_observable_room(topic)
    else
      # find a room with an open seat for your position
      throw 'dont hack me bro' unless params[:position ] == 'agree' or params[:position] == 'disagree' 
    	selected_room = Room.where("#{params[:position]} = null and topic_id = '#{topic.id}'").shuffle.first

      # if there isn't one, create one. if there is, fill the position
      if !selected_room
        selected_room = topic.rooms.create({ session_id: OTSDK.createSession.to_s, :"#{params[:position]}" => true })
      else
        selected_room.update_attribute params[:position], true
      end
    end

    # return the room
    selected_room

  end

  def close(position, observer_id)
    if position == 'observe'
      Observer.find(observer_id).destroy
    else
      update_attribute position, nil
    end
    self.destroy if agree.nil? and disagree.nil?
  end

  def add_observer
    observers.create
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

end
