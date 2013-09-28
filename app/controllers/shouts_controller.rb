class ShoutsController < ApplicationController
  require 'will_paginate/array'
  
  def index

    if params[:page].nil? || params[:page] ==0
      current_page = 1
    else
      current_page = params[:page].to_i
    end
    @topics = Topic.top_popular
    @all = Topic.sort_all(params).paginate(:page => current_page, :per_page => 20)
    @sorted = Topic.sort_limited.paginate(:page => current_page, :per_page => 20)

    #puts @all.to_json


#'Pagination' => ['total_pages' => @all.total_pages, 'current_page' => 20, 'page' => params[:page]]
    respond_to do |format|
      format.json { render :json => { 'Topics' => @all, 'Pagination' =>  ['total_pages' => @all.total_pages, 'current_page' => current_page, 'per_page' => 20, 'total_objects' => ((@all.count) * @all.total_pages)]}, :methods => [:agree_debaters, :disagree_debaters, :observers]}
  	  format.html # show.html.erb
	  end
  end


end