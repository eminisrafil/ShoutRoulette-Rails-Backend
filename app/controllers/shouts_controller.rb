class ShoutsController < ApplicationController
  
  def index
    @topics = Topic.all
  end
  
end