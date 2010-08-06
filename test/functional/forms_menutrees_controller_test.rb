require 'test_helper'

class FormsMenutreesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forms_menutrees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forms_menutree" do
    assert_difference('FormsMenutree.count') do
      post :create, :forms_menutree => { }
    end

    assert_redirected_to forms_menutree_path(assigns(:forms_menutree))
  end

  test "should show forms_menutree" do
    get :show, :id => forms_menutrees(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => forms_menutrees(:one).id
    assert_response :success
  end

  test "should update forms_menutree" do
    put :update, :id => forms_menutrees(:one).id, :forms_menutree => { }
    assert_redirected_to forms_menutree_path(assigns(:forms_menutree))
  end

  test "should destroy forms_menutree" do
    assert_difference('FormsMenutree.count', -1) do
      delete :destroy, :id => forms_menutrees(:one).id
    end

    assert_redirected_to forms_menutrees_path
  end
end
