class ChangeCorrectColumnInPicks < ActiveRecord::Migration
  def self.up
    change_column(:picks, :correct, :integer)
  end

  def self.down
    change_column(:picks, :correct, :boolean)
  end
end
