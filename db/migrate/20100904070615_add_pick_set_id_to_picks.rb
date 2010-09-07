class AddPickSetIdToPicks < ActiveRecord::Migration
  def self.up
    add_column :picks, :pick_set_id, :integer
  end

  def self.down
    remove_column :picks, :pick_set_id
  end
end
