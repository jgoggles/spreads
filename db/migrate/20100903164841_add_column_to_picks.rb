class AddColumnToPicks < ActiveRecord::Migration
  def self.up
    add_column :picks, :user_id, :integer
  end

  def self.down
    remove_column :picks, :user_id
  end
end
