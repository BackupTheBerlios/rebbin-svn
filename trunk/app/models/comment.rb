class Comment < ActiveRecord::Base
  belongs_to :paste
  before_save :check_email_uri

  validates_presence_of :paste_id
  validates_presence_of :author
  validates_presence_of :body

  validates_length_of :author, :maximum => 30

  private
  def check_email_uri
    email_regexp = /^([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$/
    uri_regexp = /^(ht|f)tp(s?)\:\/\/[a-zA-Z0-9\-\._]+(\.[a-zA-Z0-9\-\._]+){2,}(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&%\$#_]*)?$/

    if !email.nil?
      if !(email =~ email_regexp)
        valid = false
      end
    elsif !uri.nil?
      if !(uri =~ uri_regexp)
        valid = false
      end
    end
  end
end
