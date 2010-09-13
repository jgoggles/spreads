class CreateStandings < ActiveRecord::Migration
  def self.up
    create_table :standings do |t|
      t.integer :user_id
      t.integer :week_id
      t.integer :wins
      t.integer :losses
      t.integer :pushes
      t.integer :points

      t.timestamps
    end
  end

  def self.down
    drop_table :standings
  end
end
