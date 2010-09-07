require 'test_helper'

class FlownodesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flownodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flownode" do
    assert_difference('Flownode.count') do
      post :create, :flownode => { }
    end

    assert_redirected_to flownode_path(assigns(:flownode))
  end

  test "should show flownode" do
    get :show, :id => flownodes(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => flownodes(:one).id
    assert_response :success
  end

  test "should update flownode" do
    put :update, :id => flownodes(:one).id, :flownode => { }
    assert_redirected_to flownode_path(assigns(:flownode))
  end

  test "should destroy flownode" do
    assert_difference('Flownode.count', -1) do
      delete :destroy, :id => flownodes(:one).id
    end

    assert_redirected_to flownodes_path
  end
end
