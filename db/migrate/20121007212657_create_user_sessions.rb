class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions do |t|
      t.references :topic
      t.string :ip_address
      t.string :session_id
      t.boolean :observing
      t.datetime :last_checked

      t.timestamps
    end
  end
end
