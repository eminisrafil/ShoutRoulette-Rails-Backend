class ShoutsController < ApplicationController
  require 'will_paginate/array'
  
  def index
    @topics = Topic.top_popular
    @all = Topic.sort_all(params).paginate(:page => params[:page], :per_page => 20)
    @sorted = Topic.sort_limited.paginate(:page => params[:page], :per_page => 20)

    @all.to_json


    respond_to do |format|
      format.json { render :json => { 'Topics' => @all, 'Total_Pages' => @all.total_pages}, :methods => [:agree_debaters, :disagree_debaters, :observers]}
  	  format.html # show.html.erb
	  end
  end


end