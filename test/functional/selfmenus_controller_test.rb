require 'test_helper'

class SelfmenusControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:selfmenus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create selfmenu" do
    assert_difference('Selfmenu.count') do
      post :create, :selfmenu => { }
    end

    assert_redirected_to selfmenu_path(assigns(:selfmenu))
  end

  test "should show selfmenu" do
    get :show, :id => selfmenus(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => selfmenus(:one).id
    assert_response :success
  end

  test "should update selfmenu" do
    put :update, :id => selfmenus(:one).id, :selfmenu => { }
    assert_redirected_to selfmenu_path(assigns(:selfmenu))
  end

  test "should destroy selfmenu" do
    assert_difference('Selfmenu.count', -1) do
      delete :destroy, :id => selfmenus(:one).id
    end

    assert_redirected_to selfmenus_path
  end
end
