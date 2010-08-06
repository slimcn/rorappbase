require 'test_helper'

class EmployesUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employes_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employes_user" do
    assert_difference('EmployesUser.count') do
      post :create, :employes_user => { }
    end

    assert_redirected_to employes_user_path(assigns(:employes_user))
  end

  test "should show employes_user" do
    get :show, :id => employes_users(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => employes_users(:one).id
    assert_response :success
  end

  test "should update employes_user" do
    put :update, :id => employes_users(:one).id, :employes_user => { }
    assert_redirected_to employes_user_path(assigns(:employes_user))
  end

  test "should destroy employes_user" do
    assert_difference('EmployesUser.count', -1) do
      delete :destroy, :id => employes_users(:one).id
    end

    assert_redirected_to employes_users_path
  end
end
