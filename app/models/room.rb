# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  session_id :string(255)
#  topic_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  agree      :boolean
#  disagree   :boolean
#

class Room < ActiveRecord::Base
  belongs_to :topic
  has_many :observers
  attr_accessible :session_id, :agree, :disagree, :closed, :short_session_id

  def self.create_or_join(topic, params)

    if params[:position] == 'observe'
      selected_room = Room.find_observable_room(topic)
    else
      # find a room with an open seat for your position
      throw 'dont hack me bro' unless params[:position ] == 'agree' or params[:position] == 'disagree'

      #No one likes paying for Servers - Delete old records quickly not to go over 10,000 rows again///
      Room.where("created_at <= :time AND topic_id = :topic" , {:time => 6.minutes.ago, :topic =>topic.id}).destroy_all
    	selected_room = Room.where("#{params[:position]} is null and topic_id = '#{topic.id}'")
      selected_room = selected_room.shuffle.first
      
      # if there isn't one, create one. if there is, fill the position
      if !selected_room
        session_id_string = OTSDK.createSession.to_s
        selected_room = topic.rooms.create({ session_id: session_id_string, short_session_id: self.short_session(session_id_string), "#{params[:position]}" => true})
      else
        selected_room.update_attribute params[:position], true
      end
    end

    # return the room
    selected_room
  end

  def self.room_with_session_or_next_available(received_session_id, topic, params)
    room = find_room_with_session(received_session_id)
    if room.nil?
      room = create_or_join(topic, params)
    end
    room
  end

  def self.find_room_with_session(received_session_id)
    Room.where("short_session_id = ?", received_session_id).first
  end

  def close(position, observer_id)
    puts "closing in model observer_id: #{observer_id}"
    puts "Close:::Model::: self::#{self}"
    if position == 'observe'
      if observer_id.nil? 
        Observer.where("room_id =?", self.id).first.destroy
      else
        Observer.find(observer_id).destroy
      end
    else
      update_attribute position, nil unless self.nil?
    end
    self.destroy if (agree.nil? and disagree.nil? and !self.nil?)
  end

  def add_observer
    observers.create
  end

  def self.find_observable_room(topic)
    puts "topic ID :::: #{topic.id}"
    room = Room.where("(agree is not null and disagree is not null) and topic_id = ?", topic.id).shuffle.first
    return room unless room.nil?
    room = Room.where("(agree is not null or disagree is not null) and topic_id = ?", topic.id).shuffle.first
    puts "found room for observering:"
    puts room.topic.title unless room.nil?
    puts room.to_json
    room
  end

  def self.publisher_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def self.subscriber_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER
  end

  def self.short_session(session)
    session.to_s[-7..-2]
  end

end
