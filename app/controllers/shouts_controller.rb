class ShoutsController < ApplicationController
  
  def index
    @topics = Topic.top_popular
    @all = Topic.sort_all(params)
    respond_to do |format|
    	format.json { render :json => { 'Topics' => @all} }
  	  format.html # show.html.erb
  	 
	  end
  end
  
end