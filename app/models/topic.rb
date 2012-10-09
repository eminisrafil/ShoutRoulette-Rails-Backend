class Topic < ActiveRecord::Base
  has_many :tags
  has_many :rooms
  has_many :user_sessions
  attr_accessible :title

  def self.top_popular
  	pop_count = 5
  	Topic.find_by_sql("SELECT topics.id, topics.title, count(rooms.id) as room_count FROM topics left join rooms on rooms.topic_id = topics.id GROUP BY topics.id, topics.title ORDER BY room_count desc LIMIT 5")
  end

  def self.sort_all(params)
    case params[:sort]
    	when 'popular'
    		topics = Topic.find_by_sql("SELECT topics.id, topics.title, count(rooms.id) as room_count FROM topics left join rooms on rooms.topic_id = topics.id GROUP BY topics.id, topics.title ORDER BY room_count desc")
    	when 'debaters'

    	when 'observers'

    else ##default most recent

    end
    topics = Topic.all(:order => 'id desc')
  end

end
