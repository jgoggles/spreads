class ChangeTeamColumnInPicks < ActiveRecord::Migration
  def self.up
    remove_column :picks, :team
    add_column :picks, :is_home, :boolean
  end

  def self.down
    remove_column :picks, :is_home
    add_column :picks, :team, :string
  end
end
