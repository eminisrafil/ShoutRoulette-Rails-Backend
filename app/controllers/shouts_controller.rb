class ShoutsController < ApplicationController
  require 'will_paginate/array'
  
  def index
    @topics = Topic.top_popular
    @all = Topic.sort_all(params).paginate(:page => params[:page], :per_page => 10)
    @sorted = Topic.sort_limited.paginate(:page => params[:page], :per_page => 10)

    @sorted.map{|x| puts x.title}


    respond_to do |format|
      format.json { render :json => { 'Topics' => @sorted}, :methods => [:agree_debaters, :disagree_debaters, :observers]}
  	  format.html # show.html.erb
	  end
  end


end