require 'test_helper'

class ContactItemsControllerTest < ActionController::TestCase
  setup do
    @contact_item = contact_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contact_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact_item" do
    assert_difference('ContactItem.count') do
      post :create, contact_item: { address: @contact_item.address, contact_id: @contact_item.contact_id, name: @contact_item.name, platform_id: @contact_item.platform_id }
    end

    assert_redirected_to contact_item_path(assigns(:contact_item))
  end

  test "should show contact_item" do
    get :show, id: @contact_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact_item
    assert_response :success
  end

  test "should update contact_item" do
    patch :update, id: @contact_item, contact_item: { address: @contact_item.address, contact_id: @contact_item.contact_id, name: @contact_item.name, platform_id: @contact_item.platform_id }
    assert_redirected_to contact_item_path(assigns(:contact_item))
  end

  test "should destroy contact_item" do
    assert_difference('ContactItem.count', -1) do
      delete :destroy, id: @contact_item
    end

    assert_redirected_to contact_items_path
  end
end
