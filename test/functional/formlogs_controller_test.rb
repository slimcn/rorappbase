require 'test_helper'

class FormlogsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:formlogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create formlog" do
    assert_difference('Formlog.count') do
      post :create, :formlog => { }
    end

    assert_redirected_to formlog_path(assigns(:formlog))
  end

  test "should show formlog" do
    get :show, :id => formlogs(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => formlogs(:one).id
    assert_response :success
  end

  test "should update formlog" do
    put :update, :id => formlogs(:one).id, :formlog => { }
    assert_redirected_to formlog_path(assigns(:formlog))
  end

  test "should destroy formlog" do
    assert_difference('Formlog.count', -1) do
      delete :destroy, :id => formlogs(:one).id
    end

    assert_redirected_to formlogs_path
  end
end
