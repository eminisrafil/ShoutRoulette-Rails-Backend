class ChangeAgreeAndDisagreeToBoolean < ActiveRecord::Migration
  def change
    remove_column :rooms, :agree
    remove_column :rooms, :disagree
    add_column :rooms, :agree, :boolean
    add_column :rooms, :disagree, :boolean
  end
end
