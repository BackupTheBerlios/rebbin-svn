require File.dirname(__FILE__) + '/../test_helper'
require 'archive_controller'

# Re-raise errors caught by the controller.
class ArchiveController; def rescue_action(e) raise e end; end

class ArchiveControllerTest < Test::Unit::TestCase
  def setup
    @controller = ArchiveController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_template "index"
  end

  def test_sort_by_author
    get :sort_by_author
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_template "index"
  end

  def test_sort_by_language
    get :sort_by_language
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_template "index"
  end

  def test_sort_by_description
    get :sort_by_description
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_template "index"
  end

  def test_sort_by_date
    get :sort_by_date
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_template "index"
  end
end
