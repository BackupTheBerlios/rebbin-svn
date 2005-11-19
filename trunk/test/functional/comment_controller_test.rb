require File.dirname(__FILE__) + '/../test_helper'
require 'comment_controller'

# Re-raise errors caught by the controller.
class CommentController; def rescue_action(e) raise e end; end

class CommentControllerTest < Test::Unit::TestCase
  def setup
    @controller = CommentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create
    post :create, { 
      "paste_id" => 1,
      "author" => "anonymous",
      "email" => "foo@bar.baz",
      "uri" => "www.foo.baz",
      "body" => "foo bar baz",
      "created_on" => Time.now
    }

    assert_response :redirect
    assert_redirected_to :id => "1", :controller => "paste", :action => :show
  end
end
