class AddShortSessionIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :short_session_id, :string
    add_index :rooms, :short_session_id
  end
end
