class AddOverUnderToPicks < ActiveRecord::Migration
  def self.up
    add_column :picks, :over_under, :float
    add_column :picks, :is_over, :boolean
  end

  def self.down
    remove_column :picks, :is_over
    remove_column :picks, :over_under
  end
end
