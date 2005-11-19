require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  fixtures :pastes, :comments

  def setup
    @comment = Comment.find(1)
    @comment.paste_id = 1
  end

  def test_not_valid
    assert !Comment.new.valid?
  end

  def test_author
    @comment.author = nil
    assert !@comment.valid?

    @comment.save

    @comment.author = "rhymes"
    assert @comment.valid?

    @comment.author = "x" * 31
    assert !@comment.valid?
  end

  def test_paste_id
    @comment.paste_id = 999
    assert_raise(ActiveRecord::StatementInvalid) { @comment.save }

    @comment.paste_id = 1
    assert @comment.save
  end

  def test_body
    @comment.body = nil
    assert !@comment.valid?

    @comment.body = "foo"
    assert @comment.valid?
  end

  def test_crud
    temp = Comment.new
    temp.paste_id = 1
    temp.author = "foo"
    temp.email = "foo@bar.baz"
    temp.uri = "http://www.foo.baz"
    temp.body = "foo bar baz"
    
    assert temp.save

    temp2 = Comment.find(temp.id)

    assert_equal temp.created_on.to_s, temp2.created_on.to_s

    temp2.body = "bar foo baz"

    assert temp2.save
    assert temp2.destroy
    assert temp.destroy
  end
end
