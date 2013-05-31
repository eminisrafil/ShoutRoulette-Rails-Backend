class TopicsController < ApplicationController

  def new
    newTopic = Topic.create({ title: params[:topic] })
    puts params.inspect
    puts "just created new topic\n\n"
    respond_to do |format|
    	#format.json { render :json => { 'Topics' => @all.to_json(methods:['agree_debaters'])}}
      format.json { render :json => { 'Topics' => newTopic}}
  	  format.html { redirect_to root_path}
	  end
    
  end

end
