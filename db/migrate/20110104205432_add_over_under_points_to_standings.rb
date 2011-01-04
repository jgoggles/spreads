class AddOverUnderPointsToStandings < ActiveRecord::Migration
  def self.up
    add_column :standings, :over_under_points, :integer
  end

  def self.down
    remove_column :standings, :over_under_points
  end
end
