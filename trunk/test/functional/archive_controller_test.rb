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

  def test_sort_by_author_asc
    get :index, { "sort_key" => "author", "sort_order" => "asc" }
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_tag :tag => "img", :attributes => {:src => "/images/sort_asc.png"},  :parent => { 
      :tag => "th", :attributes => { :title => "Sort by Author"}
    }
    assert_no_tag :tag => "img", :attributes => {:src => "/images/sort_asc.png"}, :parent => { 
      :tag => "th", :attributes => { :title => "Sort by Date"}
    }
    assert_template "index"
  end

  def test_sort_by_date_desc
    get :index, { "sort_key" => "created_on", "sort_order" => "desc" }
    assert_response :success
    assert_not_nil assigns(:pastes)
    assert_tag :tag => "img", :attributes => {:src => "/images/sort_desc.png"},  :parent => { 
      :tag => "th", :attributes => { :title => "Sort by Date"}
    }
    assert_no_tag :tag => "img", :attributes => {:src => "/images/sort_desc.png"}, :parent => { 
      :tag => "th", :attributes => { :title => "Sort by Language"}
    }
    assert_template "index"
  end
end
