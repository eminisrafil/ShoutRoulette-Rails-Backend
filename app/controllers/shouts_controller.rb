class ShoutsController < ApplicationController
  require 'will_paginate/array'
  
  def index
    @topics = Topic.top_popular
    @all = Topic.sort_all(params).paginate(:page => params[:page], :per_page => 20)
    @sorted = Topic.sort_limited.paginate(:page => params[:page], :per_page => 20)

    @all.to_json

#'Pagination' => ['total_pages' => @all.total_pages, 'current_page' => 20, 'page' => params[:page]]
    respond_to do |format|
      format.json { render :json => { 'Topics' => @all, 'Pagination' =>  ['total_pages' => @all.total_pages, 'current_page' => params[:page], 'per_page' => 20]}, :methods => [:agree_debaters, :disagree_debaters, :observers]}
  	  format.html # show.html.erb
	  end
  end


end