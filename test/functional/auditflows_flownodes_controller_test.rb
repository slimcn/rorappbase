require 'test_helper'

class AuditflowsFlownodesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auditflows_flownodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auditflows_flownode" do
    assert_difference('AuditflowsFlownode.count') do
      post :create, :auditflows_flownode => { }
    end

    assert_redirected_to auditflows_flownode_path(assigns(:auditflows_flownode))
  end

  test "should show auditflows_flownode" do
    get :show, :id => auditflows_flownodes(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => auditflows_flownodes(:one).id
    assert_response :success
  end

  test "should update auditflows_flownode" do
    put :update, :id => auditflows_flownodes(:one).id, :auditflows_flownode => { }
    assert_redirected_to auditflows_flownode_path(assigns(:auditflows_flownode))
  end

  test "should destroy auditflows_flownode" do
    assert_difference('AuditflowsFlownode.count', -1) do
      delete :destroy, :id => auditflows_flownodes(:one).id
    end

    assert_redirected_to auditflows_flownodes_path
  end
end
