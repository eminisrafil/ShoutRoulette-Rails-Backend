class ChangePositionsToEnglish < ActiveRecord::Migration

  def change
    rename_column :rooms, :position_1, :agree
    rename_column :rooms, :position_2, :disagree
  end

end
