class UserSessionLastcheckeToInt < ActiveRecord::Migration
  def change
    change_column :user_sessions, :last_checked, :integer, :scale => 20
  end
end
