require "test_helper"

class GruposControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get grupos_index_url
    assert_response :success
  end

  test "should get show" do
    get grupos_show_url
    assert_response :success
  end

  test "should get new" do
    get grupos_new_url
    assert_response :success
  end

  test "should get edit" do
    get grupos_edit_url
    assert_response :success
  end
end
