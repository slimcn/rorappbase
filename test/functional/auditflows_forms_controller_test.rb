require 'test_helper'

class AuditflowsFormsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auditflows_forms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auditflows_form" do
    assert_difference('AuditflowsForm.count') do
      post :create, :auditflows_form => { }
    end

    assert_redirected_to auditflows_form_path(assigns(:auditflows_form))
  end

  test "should show auditflows_form" do
    get :show, :id => auditflows_forms(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => auditflows_forms(:one).id
    assert_response :success
  end

  test "should update auditflows_form" do
    put :update, :id => auditflows_forms(:one).id, :auditflows_form => { }
    assert_redirected_to auditflows_form_path(assigns(:auditflows_form))
  end

  test "should destroy auditflows_form" do
    assert_difference('AuditflowsForm.count', -1) do
      delete :destroy, :id => auditflows_forms(:one).id
    end

    assert_redirected_to auditflows_forms_path
  end
end
