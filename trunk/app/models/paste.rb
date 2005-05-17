class Paste < ActiveRecord::Base
  timestamps_gmt = true

  validates_presence_of :author
  validates_presence_of :language
  validates_presence_of :body

  validates_length_of :author, :maximum => 20
  validates_length_of :language, :maximum => 20
  validates_length_of :description, :maximum => 50

  def html_body
    begin
      Colouriser.colourise(body, $languages[language])
    rescue
      body
    end
  end
  
  def Paste.find_latest_pastes
    Paste.find(:all, :order => "created_on DESC", :limit => 20)
  end

  def Paste.find_all_by_author
    Paste.find(:all, :order => "author")
  end

  def Paste.find_all_by_language
    Paste.find(:all, :order => "language")
  end

  def Paste.find_all_by_description
    Paste.find(:all, :order => "description")
  end

  def Paste.find_all_by_date
    Paste.find(:all, :order => "created_on")
  end

  def Paste.find_all
    Paste.find(:all, :order => "created_on DESC")
  end
end
