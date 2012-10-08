class AdminController < ApplicationController
  http_basic_authenticate_with :name => "hello", :password => "world"

  def index
    @topics = Topic.all  
  end

  def remove_topic
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to admin_path
  end

end
