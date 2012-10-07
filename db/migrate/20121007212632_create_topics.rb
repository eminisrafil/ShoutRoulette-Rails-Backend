class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.string :position_1
      t.string :position_2

      t.timestamps
    end
  end
end
