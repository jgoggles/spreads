require 'test_helper'

class TestControllerTest < ActionController::TestCase
  test "should get lines" do
    get :lines
    assert_response :success
  end

end
