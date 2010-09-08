class ChangeWeekToWeekId < ActiveRecord::Migration
  def self.up
    remove_column :pick_sets, :week
    remove_column :games, :week
    add_column :pick_sets, :week_id, :integer
    add_column :games, :week_id, :integer
  end

  def self.down
    remove_column :pick_sets, :week_id
    remove_column :games, :week_id
    add_column :pick_sets, :week, :string
    add_column :games, :week, :string
  end
end
