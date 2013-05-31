class TopicsController < ApplicationController
	before_filter :check_params
  def new
    newTopic = Topic.create({ title: params[:topic] })

    respond_to do |format|
    	#format.json { render :json => { 'Topics' => @all.to_json(methods:['agree_debaters'])}}
      format.json { render :json => { 'Topics' => newTopic}}
  	  format.html { redirect_to root_path}
	  end
  end
  def check_params
  	redirect_to root_path unless params[:topic].length >3 && params[:topic].length <145
  end

end
