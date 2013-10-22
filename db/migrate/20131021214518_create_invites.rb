class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :browser
      t.string :version
      t.string :platform
      t.string :ip
      t.string :region

      t.timestamps
    end
  end
end
