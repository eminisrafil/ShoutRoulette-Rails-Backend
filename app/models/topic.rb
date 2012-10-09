class Topic < ActiveRecord::Base
  has_many :tags
  has_many :rooms
  has_many :user_sessions
  attr_accessible :title

  def self.top_popular
  	pop_count = 5
  	Topic.select('`topics`.`id`, `topics`.`title`, count(`rooms`.`id`) as `room_count`').joins('left join `rooms` on `rooms`.`topic_id` = `topics`.`id`').group('`topics`.`id`, `topics`.`title`').order('room_count desc').limit(pop_count)
  end

  def self.sort_all(params)
    case params[:sort]
    	when 'popular'
    		topics = Topic.select('`topics`.`id`, `topics`.`title`, count(`rooms`.`id`) as `room_count`').joins('left join `rooms` on `rooms`.`topic_id` = `topics`.`id`').group('`topics`.`id`, `topics`.`title`').order('room_count desc')
    	when 'debaters'

    	when 'observers'

    else ##default most recent

    end
    topics = Topic.all(:order => 'id desc')
  end

end
