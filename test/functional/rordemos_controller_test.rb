require 'test_helper'

class RordemosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rordemos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rordemo" do
    assert_difference('Rordemo.count') do
      post :create, :rordemo => { }
    end

    assert_redirected_to rordemo_path(assigns(:rordemo))
  end

  test "should show rordemo" do
    get :show, :id => rordemos(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => rordemos(:one).id
    assert_response :success
  end

  test "should update rordemo" do
    put :update, :id => rordemos(:one).id, :rordemo => { }
    assert_redirected_to rordemo_path(assigns(:rordemo))
  end

  test "should destroy rordemo" do
    assert_difference('Rordemo.count', -1) do
      delete :destroy, :id => rordemos(:one).id
    end

    assert_redirected_to rordemos_path
  end
end
