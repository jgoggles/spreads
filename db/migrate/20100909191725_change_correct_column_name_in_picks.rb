class ChangeCorrectColumnNameInPicks < ActiveRecord::Migration
  def self.up
    rename_column(:picks, :correct, :result)
  end

  def self.down
    rename_column(:picks, :result, :correct)
  end
end
