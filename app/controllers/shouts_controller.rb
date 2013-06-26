class ShoutsController < ApplicationController

  
  def index
    @topics = Topic.top_popular
    @all = Topic.sort_all(params)
    @sorted = Topic.sort_limited


    respond_to do |format|
      format.json { render :json => { 'Topics' => @sorted}, :methods => [:agree_debaters, :disagree_debaters, :observers]}
  	  format.html # show.html.erb
	  end
  end


end