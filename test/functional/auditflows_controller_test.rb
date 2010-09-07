require 'test_helper'

class AuditflowsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auditflows)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auditflow" do
    assert_difference('Auditflow.count') do
      post :create, :auditflow => { }
    end

    assert_redirected_to auditflow_path(assigns(:auditflow))
  end

  test "should show auditflow" do
    get :show, :id => auditflows(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => auditflows(:one).id
    assert_response :success
  end

  test "should update auditflow" do
    put :update, :id => auditflows(:one).id, :auditflow => { }
    assert_redirected_to auditflow_path(assigns(:auditflow))
  end

  test "should destroy auditflow" do
    assert_difference('Auditflow.count', -1) do
      delete :destroy, :id => auditflows(:one).id
    end

    assert_redirected_to auditflows_path
  end
end
