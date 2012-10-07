class ShoutsController < ActionController::Base
  
  def index
    # @tags = Tag.find_by_sql("select *, count(id) as tag_count from tags group by tag order by tag_count desc limit 0, 50")
  end
  
  def choose
    if !params[:id].nil? && !params[:id].blank?
      @topic = Topic.find(:first, :conditions=>{:text_id => params[:id]}) rescue nil
      if @topic.position_1.blank?
        @topic.position_1 = 'Agree'
      end
      if @topic.position_2.blank?
        @topic.position_2 = 'Disagree'
      end
    end
    render :layout => 'blank'
  end
  
  def new_topic
    if !params[:id].nil? && !params[:id].blank?
      @topic = Topic.new
      @topic.title = params[:id]
      @topic.text_id = params[:id].gsub(/[^0-9A-Za-z]/, '').gsub(' ', '_').downcase
      logger.info params[:id]
      logger.info @topic.text_id
      @topic.save
    end
    render :layout => 'blank'
  end
  
  def sort_topics
    cur_time = Time.now
    logger.info cur_time.to_s
    cur_time = cur_time - 300
    logger.info cur_time.to_s
    #cur_time = curtime-5mins
    logger.info cur_time.to_s
    if !params[:t].nil? && params[:t].to_s != '0'
      where = "where tags.tag = '#{params[:t]}'"
    else
      where = ""
    end
    if !params[:id].nil? && !params[:id].blank?
      case params[:id]
        when 'po'
          sort_order = 'topics.id asc'
        when 'ne'
          sort_order = 'rooms.created_at desc'
          @topics = Topics.find_by_sql("select topics.*, sum(case when user_sessions.sit_stand = '1' and user_sessions.last_checked > '#{cur_time}' then 1 else 0 end) as observer_count, sum(case when user_sessions.sit_stand = '2' and user_sessions.last_checked > '#{cur_time}' then 1 else 0 end) as debater_count from topics left join tags on topics.id = tags.room_id left join user_sessions on user_sessions.topic_id = topics.id left join rooms on rooms.topic_id = topics.id #{where} group by topics.id order by #{sort_order} limit 0, 100")
        when 'de'
          sort_order = 'debater_count desc'
        when 'ob'
          sort_order = 'observer_count desc'
      else
        sort_order = 'topics.id asc'
      end
    else
      sort_order = 'topics.id asc'
    end
    
    if @topics.nil?
      @topics = Topic.find_by_sql("select topics.*, sum(case when user_sessions.sit_stand = '1' and user_sessions.last_checked > '#{cur_time}' then 1 else 0 end) as observer_count, sum(case when user_sessions.sit_stand = '2' and user_sessions.last_checked > '#{cur_time}' then 1 else 0 end) as debater_count from topics left join tags on topics.id = tags.room_id left join user_sessions on user_sessions.topic_id = topics.id #{where} group by topics.id order by #{sort_order} limit 0, 100")
    end

    render :layout => 'blank'
  end
  
  def tag_topic
    if !params[:id].nil? && !params[:id].blank? && !params[:tag].nil?
      @topic = Topic.find(:first, :conditions=>{:text_id => params[:id]}) rescue nil
      @tag = Tag.new
      @tag.room_id = @topic.id
      @tag.tag = params[:tag].gsub(' ', '_').downcase
      @tag.save
    end
    render :layout => 'blank'
  end
  
  def show_room
  @topic = Topic.find(:first, :conditions=>{:text_id => params[:id]}) rescue nil
  if !params[:p].nil? && !params[:p].blank?
    case params[:p].to_s
      when '0'
        pos = '0'
      when '1'
        pos = '1'
      when '2'
        pos = '2'
    else
      pos = '0'
    end
  else
    pos = '0'
  end
  if pos == '0'
    
    @room = Room.find(:first, :conditions=>"topics.text_id = '#{params[:id]}' and rooms.room_closed = '0'", :joins=>"join topics on topics.id = rooms.topic_id", :order=>"rand()") rescue nil
  else
    @room = Room.find(:first, :conditions=>"topics.text_id = '#{params[:id]}' and rooms.position_#{pos} is null and rooms.room_closed = '0'", :joins=>"join topics on topics.id = rooms.topic_id", :order=>"rand()")
  end
    if (@room.nil? || @room.blank?) && pos != '0'
      
      if !@topic.nil? && !@topic.blank?
        @room = Room.new
        @room.topic_id = @topic.id
        @room.session_id = @room.generate_session(request).to_s
        @room.created_at = Time.now
        @room.save
      end
    else
      @room = Room.find(:first, :conditions=>{:id => @room.id})
    end
    @room_gen = Room.new
    ##if room now exists, sit down
    token = @room_gen.generate_publisher(session)
    if pos == '1'
      @room.position_1 = token
    elsif pos == '2'
      @room.position_2 = token
    end
    @room.save
    @session = UserSession.find(:first, :conditions=>{:session_id => request.session_options[:id]}) rescue nil
    if @session.nil?
      @session = UserSession.new
      @session.session_id = request.session_options[:id].to_s
      @session.ip_address = request.remote_ip.to_s
      @session.time_created = Time.now
    end
  @session.topic_id = @room.topic_id
  @session.room_id = @room.id
  @session.last_checked = Time.now
  @session.token_id = token
  if pos == '0'
    @session.sit_stand = 1
  else
    @session.sit_stand = 0
  end
  @session.save

    render :layout => 'blank'
  end
  
end