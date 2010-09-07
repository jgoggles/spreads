class AddGameIdToPicks < ActiveRecord::Migration
  def self.up
    add_column :picks, :game_id, :integer
  end

  def self.down
    remove_column :picks, :game_id
  end
end
