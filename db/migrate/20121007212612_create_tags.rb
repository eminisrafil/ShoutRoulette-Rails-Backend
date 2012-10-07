class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :room
      t.string :tag

      t.timestamps
    end
  end
end
