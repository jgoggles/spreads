require 'test_helper'

class PickSetsControllerTest < ActionController::TestCase
  setup do
    @pick_set = pick_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pick_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pick_set" do
    assert_difference('PickSet.count') do
      post :create, :pick_set => @pick_set.attributes
    end

    assert_redirected_to pick_set_path(assigns(:pick_set))
  end

  test "should show pick_set" do
    get :show, :id => @pick_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pick_set.to_param
    assert_response :success
  end

  test "should update pick_set" do
    put :update, :id => @pick_set.to_param, :pick_set => @pick_set.attributes
    assert_redirected_to pick_set_path(assigns(:pick_set))
  end

  test "should destroy pick_set" do
    assert_difference('PickSet.count', -1) do
      delete :destroy, :id => @pick_set.to_param
    end

    assert_redirected_to pick_sets_path
  end
end
