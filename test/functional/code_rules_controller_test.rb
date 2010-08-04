require 'test_helper'

class CodeRulesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:code_rules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create code_rule" do
    assert_difference('CodeRule.count') do
      post :create, :code_rule => { }
    end

    assert_redirected_to code_rule_path(assigns(:code_rule))
  end

  test "should show code_rule" do
    get :show, :id => code_rules(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => code_rules(:one).id
    assert_response :success
  end

  test "should update code_rule" do
    put :update, :id => code_rules(:one).id, :code_rule => { }
    assert_redirected_to code_rule_path(assigns(:code_rule))
  end

  test "should destroy code_rule" do
    assert_difference('CodeRule.count', -1) do
      delete :destroy, :id => code_rules(:one).id
    end

    assert_redirected_to code_rules_path
  end
end
