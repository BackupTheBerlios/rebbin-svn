require File.dirname(__FILE__) + '/../test_helper'
require 'paste_controller'

class PasteController; def rescue_action(e) raise e end; end

class PasteControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = PasteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_num_of_pastes
    result = invoke :num_of_pastes
    assert_equal result, Paste.count
  end

  def test_get_languages
    result = invoke :get_languages
    assert_equal result, PasteHelper.get_languages
  end

  def test_add_paste
    result = invoke(:add_paste, "rhymes", "Ruby", "", "def foo end")
    last = Paste.find(:first, :order => "created_on desc")
    assert_equal result, last.id
    assert last.destroy
  end

  def test_get_paste
    result = invoke :get_paste, 1
    first = Paste.find(1)

    assert_equal result.author, first.author.to_s
    assert_equal result.language, first.language.to_s
    assert_equal result.description, first.description.to_s
    assert_equal result.body, first.body.to_s
  end

  def test_get_latest_pastes
    result = invoke :get_latest_pastes
    pastes = Paste.find_latest_pastes
    
    pastes.each_with_index { |paste, index|
      assert_equal result[index].author, paste.author.to_s
      assert_equal result[index].language, paste.language.to_s
      assert_equal result[index].description, paste.description.to_s
      assert_equal result[index].body, paste.body.to_s
    }
  end
end
