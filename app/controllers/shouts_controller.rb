class ShoutsController < ApplicationController
  
  def index
    @topics = Topic.top_popular
    @all = Topic.sort_all(params)
  end

  def scroll
  	@topics = Topic.page(params)
  	render :json => @topics
  end
  
end