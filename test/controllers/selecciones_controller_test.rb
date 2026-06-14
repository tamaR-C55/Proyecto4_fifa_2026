require "test_helper"

class SeleccionesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get selecciones_index_url
    assert_response :success
  end

  test "should get show" do
    get selecciones_show_url
    assert_response :success
  end

  test "should get new" do
    get selecciones_new_url
    assert_response :success
  end

  test "should get edit" do
    get selecciones_edit_url
    assert_response :success
  end
end
