class AddColumnsToPicks < ActiveRecord::Migration
  def self.up
    add_column :picks, :team, :string
    add_column :picks, :spread, :float
    add_column :picks, :correct, :boolean
  end

  def self.down
    remove_column :picks, :correct
    remove_column :picks, :spread
    remove_column :picks, :team
  end
end
