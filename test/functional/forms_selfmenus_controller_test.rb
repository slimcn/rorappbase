require 'test_helper'

class FormsSelfmenusControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forms_selfmenus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forms_selfmenu" do
    assert_difference('FormsSelfmenu.count') do
      post :create, :forms_selfmenu => { }
    end

    assert_redirected_to forms_selfmenu_path(assigns(:forms_selfmenu))
  end

  test "should show forms_selfmenu" do
    get :show, :id => forms_selfmenus(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => forms_selfmenus(:one).id
    assert_response :success
  end

  test "should update forms_selfmenu" do
    put :update, :id => forms_selfmenus(:one).id, :forms_selfmenu => { }
    assert_redirected_to forms_selfmenu_path(assigns(:forms_selfmenu))
  end

  test "should destroy forms_selfmenu" do
    assert_difference('FormsSelfmenu.count', -1) do
      delete :destroy, :id => forms_selfmenus(:one).id
    end

    assert_redirected_to forms_selfmenus_path
  end
end
