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
    assert_template "show"
  end

  def test_download
    get :download, { :id => 1 }
    assert_response :success
    assert_not_nil assigns(:paste)
  end

#  def test_create
#    post :create, { 
#      :paste => { 
#        "author" => "anonymous",
#        "language" => "Ruby",
#        "description" => "test",
#        "body" => "def foo end",
#        "created_on" => Time.now
#      }
#    }
    
#    assert_equal "anonymous", cookies[$AUTHOR_COOKIE_NAME][0]

#    assert_response :redirect

#    paste = Paste.find(:all, :order => "id")[-1]
#    assert paste.save

#    assert_redirected_to :action => "show"#, :id => paste.id
#  end
end
