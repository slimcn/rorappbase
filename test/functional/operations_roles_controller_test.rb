require 'test_helper'

class OperationsRolesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:operations_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create operations_roles" do
    assert_difference('OperationsRoles.count') do
      post :create, :operations_roles => { }
    end

    assert_redirected_to operations_roles_path(assigns(:operations_roles))
  end

  test "should show operations_roles" do
    get :show, :id => operations_roles(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => operations_roles(:one).id
    assert_response :success
  end

  test "should update operations_roles" do
    put :update, :id => operations_roles(:one).id, :operations_roles => { }
    assert_redirected_to operations_roles_path(assigns(:operations_roles))
  end

  test "should destroy operations_roles" do
    assert_difference('OperationsRoles.count', -1) do
      delete :destroy, :id => operations_roles(:one).id
    end

    assert_redirected_to operations_roles_path
  end
end
