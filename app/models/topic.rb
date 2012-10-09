class Topic < ActiveRecord::Base
  has_many :tags
  has_many :rooms
  has_many :user_sessions
  attr_accessible :title

  def self.top_popular
  	pop_count = 5
    time_check = Time.now.to_formatted_s(:number).to_i - 600
  	Topic.find_by_sql("SELECT topics.id, topics.title, sum(case when user_sessions.observing = '1' then 1 else 0 end) as observer_count, sum(case when user_sessions.observing = '0' then 1 else 0 end) as debater_count, count(rooms.id) as room_count FROM topics left join rooms on rooms.topic_id = topics.id left join user_sessions on (user_sessions.topic_id = topics.id and user_sessions.room_id = rooms.id) GROUP BY topics.id, topics.title, rooms.topic_id ORDER BY room_count desc LIMIT 5")
  end

  def self.sort_all(params)
    time_check = Time.now.to_formatted_s(:number).to_i - 600
    case params[:sort]
    	when 'popular'
    		topics = Topic.find_by_sql("SELECT topics.id, topics.title, sum(case when user_sessions.observing = '1' then 1 else 0 end) as observer_count, sum(case when user_sessions.observing = '0' then 1 else 0 end) as debater_count, count(rooms.id) as room_count FROM topics left join rooms on rooms.topic_id = topics.id left join user_sessions on (user_sessions.topic_id = topics.id and user_sessions.room_id = rooms.id) GROUP BY topics.id, topics.title ORDER BY room_count desc")
    	when 'debaters'

    	when 'observers'

    else ##default most recent

    end
    topics = Topic.find_by_sql("SELECT topics.id, topics.title, sum(case when user_sessions.observing = '1' then 1 else 0 end) as observer_count, sum(case when user_sessions.observing = '0' then 1 else 0 end) as debater_count, count(rooms.id) as room_count FROM topics left join rooms on rooms.topic_id = topics.id left join user_sessions on (user_sessions.topic_id = topics.id and user_sessions.room_id = rooms.id) GROUP BY topics.id, topics.title ORDER BY topics.id desc")
  end

  def self.page(params)

  end

end
