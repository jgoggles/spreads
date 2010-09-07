class CreatePickSets < ActiveRecord::Migration
  def self.up
    create_table :pick_sets do |t|
      t.integer :user_id
      t.string :week

      t.timestamps
    end
  end

  def self.down
    drop_table :pick_sets
  end
end
