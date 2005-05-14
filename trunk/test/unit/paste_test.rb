require File.dirname(__FILE__) + '/../test_helper'
require 'paste_helper'

class PasteTest < Test::Unit::TestCase
  fixtures :pastes

  def setup
    @paste = Paste.find(1)
  end

  def test_not_valid
    assert !Paste.new.valid?
  end
  
  def test_author
    @paste.author = nil
    assert !@paste.valid?

    @paste.author = "anonymous"
    assert @paste.valid?

    @paste.author = "x" * 21
    assert !@paste.valid?
  end

  def test_language
    @paste.language = nil
    assert !@paste.valid?

    @paste.language = "Ruby"
    assert @paste.valid?

    @paste.language = "x" * 21
    assert !@paste.valid?
  end

  def test_description
    @paste.description = nil
    assert !@paste.valid?

    @paste.description = ""
    assert @paste.valid?

    @paste.description = "foo"
    assert @paste.valid?

    @paste.language = "x" * 51
    assert !@paste.valid?
  end

  def test_body
    @paste.body = nil
    assert !@paste.valid?

    @paste.body = "foo"
    assert @paste.valid?
  end

  def test_created_on
    @paste.created_on = nil
    assert @paste.valid?    # created_on is handle by rails

    @paste.created_on = Time.now
    assert @paste.valid?
  end

  def test_body_unicode
    assert_equal @unicode["body"], "Iñtërnâtiônàlizætiøn"
  end

  def test_crud
    temp = Paste.new
    temp.author = "foo"
    temp.language = "Ruby"
    temp.description = "baz"
    temp.body = "def foo 'baz' end"
    temp.created_on = Time.now
    
    assert temp.save

    temp2 = Paste.find(temp.id)

    assert_equal temp.created_on.to_s, temp2.created_on.to_s

    temp2.body = "raise"
    
    assert temp2.save
    assert temp2.destroy
    assert temp.destroy
  end

  def test_id
    assert_equal 1, PasteHelper.prev_id(1)
    assert_equal 2, PasteHelper.prev_id(3)

    assert_equal 1.succ, PasteHelper.next_id(1)
    last_id = Paste.find(:all, :order => "id")[-1].id
    assert_equal last_id, PasteHelper.next_id(last_id)
  end
end
