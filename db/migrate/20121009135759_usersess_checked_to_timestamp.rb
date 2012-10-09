class UsersessCheckedToTimestamp < ActiveRecord::Migration
  def change
    change_column :user_sessions, :last_checked, :datetime
  end
end
