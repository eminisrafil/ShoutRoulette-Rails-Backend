class RoomsController < ApplicationController

  def show
    @title = Topic.find(params[:id]).title
    @session = Room.get_session(params)
    @token = Room.get_token(params)
  end

end
