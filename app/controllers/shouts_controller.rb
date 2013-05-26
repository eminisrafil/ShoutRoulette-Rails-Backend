class ShoutsController < ApplicationController

  
  def index
    @topics = Topic.top_popular
    @all = Topic.sort_all(params)
    
    #puts "END => @TOPICS:           #{@topics} \n\n\n"
    #puts "END => @ALL:           #{@all} \n\n\n"
    respond_to do |format|
    	#format.json { render :json => { 'Topics' => @all.to_json(methods:['agree_debaters'])}}
      format.json { render :json => { 'Topics' => @all}, :methods => [:agree_debaters, :disagree_debaters, :observers]}
  	  format.html # show.html.erb
	  end
  end


end