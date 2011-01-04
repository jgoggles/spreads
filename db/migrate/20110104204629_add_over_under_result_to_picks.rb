class AddOverUnderResultToPicks < ActiveRecord::Migration
  def self.up
    add_column :picks, :over_under_result, :integer
  end

  def self.down
    remove_column :picks, :over_under_result
  end
end
