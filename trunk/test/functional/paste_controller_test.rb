require File.dirname(__FILE__) + '/../test_helper'
require 'paste_controller'

# Re-raise errors caught by the controller.
class PasteController; def rescue_action(e) raise e end; end

class PasteControllerTest < Test::Unit::TestCase
  def setup
    @controller = PasteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_template "index"
  end

  def test_show
    get :show, { :id => 1 }
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_not_nil assigns(:paste)
    assert_equal 1, assigns(:paste)[:id]
    assert flash.empty?
    assert_template "show"
  end

  def test_download
    get :download, { :id => 1 }
    assert_response :success
    assert_not_nil assigns(:paste)
  end

  def test_create
    post :create, { 
      "author" => "anonymous",
      "language" => "Ruby",
      "description" => "test",
      "body" => "def foo end",
      "created_on" => Time.now
    }
    
    assert_equal "anonymous", cookies[$AUTHOR_COOKIE_NAME][0]
    assert_response :redirect

    paste = Paste.find(:all, :order => "id")[-1]
    assert paste.save

    assert_redirected_to :action => "show"#, :id => paste.id
  end

  def test_show_routing
    opts = { :controller => "paste", :action => "show", :id => "1" }
    assert_routing "paste/show/1", opts
  end

  def test_download_routing
    opts = { :controller => "paste", :action => "download", :id => "1" }
    assert_routing "paste/download/1", opts
  end
end
