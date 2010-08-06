require 'test_helper'

class DepartmentmanagersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:departmentmanagers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create departmentmanager" do
    assert_difference('Departmentmanager.count') do
      post :create, :departmentmanager => { }
    end

    assert_redirected_to departmentmanager_path(assigns(:departmentmanager))
  end

  test "should show departmentmanager" do
    get :show, :id => departmentmanagers(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => departmentmanagers(:one).id
    assert_response :success
  end

  test "should update departmentmanager" do
    put :update, :id => departmentmanagers(:one).id, :departmentmanager => { }
    assert_redirected_to departmentmanager_path(assigns(:departmentmanager))
  end

  test "should destroy departmentmanager" do
    assert_difference('Departmentmanager.count', -1) do
      delete :destroy, :id => departmentmanagers(:one).id
    end

    assert_redirected_to departmentmanagers_path
  end
end
