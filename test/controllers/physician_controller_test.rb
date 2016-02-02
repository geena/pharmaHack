require 'test_helper'

class PhysicianControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
