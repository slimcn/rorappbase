require 'test_helper'

class RolesUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roles_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roles_users" do
    assert_difference('RolesUsers.count') do
      post :create, :roles_users => { }
    end

    assert_redirected_to roles_users_path(assigns(:roles_users))
  end

  test "should show roles_users" do
    get :show, :id => roles_users(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => roles_users(:one).id
    assert_response :success
  end

  test "should update roles_users" do
    put :update, :id => roles_users(:one).id, :roles_users => { }
    assert_redirected_to roles_users_path(assigns(:roles_users))
  end

  test "should destroy roles_users" do
    assert_difference('RolesUsers.count', -1) do
      delete :destroy, :id => roles_users(:one).id
    end

    assert_redirected_to roles_users_path
  end
end
