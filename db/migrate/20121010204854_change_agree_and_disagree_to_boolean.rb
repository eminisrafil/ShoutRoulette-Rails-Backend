class ChangeAgreeAndDisagreeToBoolean < ActiveRecord::Migration
  def change
    change_column :rooms, :agree, :boolean
    change_column :rooms, :disagree, :boolean
  end
end
