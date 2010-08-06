require 'test_helper'

class MenutreesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:menutrees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create menutree" do
    assert_difference('Menutree.count') do
      post :create, :menutree => { }
    end

    assert_redirected_to menutree_path(assigns(:menutree))
  end

  test "should show menutree" do
    get :show, :id => menutrees(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => menutrees(:one).id
    assert_response :success
  end

  test "should update menutree" do
    put :update, :id => menutrees(:one).id, :menutree => { }
    assert_redirected_to menutree_path(assigns(:menutree))
  end

  test "should destroy menutree" do
    assert_difference('Menutree.count', -1) do
      delete :destroy, :id => menutrees(:one).id
    end

    assert_redirected_to menutrees_path
  end
end
