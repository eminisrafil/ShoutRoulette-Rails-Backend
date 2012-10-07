class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :session_id
      t.string :position_1
      t.string :position_2
      t.boolean :closed
      t.references :topic

      t.timestamps
    end
  end
end
