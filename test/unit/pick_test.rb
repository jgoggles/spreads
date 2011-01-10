require 'test_helper'

class PickTest < ActiveSupport::TestCase
  fixtures :picks
  fixtures :games
  fixtures :pick_sets
  
#  test "empty_attributes" do
#    pick = Pick.new
#    assert pick.invalid?
#    assert pick.errors[:spread].any?
#    assert pick.errors[:game_id].any?
#    assert pick.errors[:is_home].any?
#  end
#  
#  test "change_pick" do
#    game = Game.create!(:date => Time.now + 1.day, :home => "Home", :away => "Away", :week_id => "9999")
#    pick = Pick.create!(:spread => "-8.5", :pick_set_id => 1, :game_id => game.id, :is_home => true)
#    
#    assert_no_difference 'pick.game_id' do
#      pick.update_attributes(:game_id => games(:two).id)
#      pick.reload
#    end 
#    
#    assert_no_difference 'pick.spread' do
#      pick.update_attributes(:spread => (pick.spread.to_f + 1).to_s)
#      pick.reload
#    end
#    
#    assert_no_difference 'pick.pick_set_id' do
#      pick.update_attributes(:pick_set_id => pick.pick_set_id.to_i + 1)
#      pick.reload
#    end
#    
#    assert_no_difference '(pick.is_home) ? 1 : 0' do  # you're goddamn fucking right
#      pick.update_attributes(:is_home => !pick.is_home )
#      pick.reload
#    end
#    
#  end
#
#  test "pick_time_before_game_time" do 
#    pick = Pick.new(:spread => "-8.5", :pick_set_id => 1, :game_id => games(:one).id, :is_home => true)
#    assert pick.invalid?
#  end

  test "clone and delete duplicate pick" do
    o_pick = picks(:pick_one)
    pick = Pick.new(:over_under => "44.5", :is_over => 1, :pick_set_id => pick_sets(:pick_set_one).id, :game_id => games(:game_one).id)
    pick.save
    assert pick.spread == o_pick.spread
    assert pick.is_home == o_pick.is_home
    assert_raises(ActiveRecord::RecordNotFound) do
      picks(:pick_one).reload
    end
  end
  
  test "clone and delete duplicate pick 2" do
    o_pick = picks(:pick_two)
    pick = Pick.new(:spread => "5.0", :is_home => 1, :pick_set_id => pick_sets(:pick_set_one).id, :game_id => games(:game_two).id)
    pick.save
    assert pick.over_under == o_pick.over_under
    assert pick.is_over == o_pick.is_over
    assert_raises(ActiveRecord::RecordNotFound) do
      picks(:pick_two).reload
    end
  end

  test "team picked" do
    assert picks(:pick_one).team == games(:game_one).home
  end
end
