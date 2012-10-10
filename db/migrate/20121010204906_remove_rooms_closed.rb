class RemoveRoomsClosed < ActiveRecord::Migration
  def change
    remove_column :rooms, :closed
  end
end
