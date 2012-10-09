class UserSessionAddRooms < ActiveRecord::Migration
  def change
  	add_column :user_sessions, :room_id, :integer
  end
end
