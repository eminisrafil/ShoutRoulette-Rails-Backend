class ChangeTokensToText < ActiveRecord::Migration
  def change
    change_column :rooms, :position_1, :text
    change_column :rooms, :position_2, :text
  end
end
