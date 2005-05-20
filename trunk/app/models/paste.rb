class Paste < ActiveRecord::Base
  validates_presence_of :author
  validates_presence_of :language
  validates_presence_of :body

  validates_length_of :author, :maximum => 20
  validates_length_of :language, :maximum => 20
  validates_length_of :description, :maximum => 50

  def html_body
    begin
      Colouriser.colourise(body, Colouriser.languages[language])
    rescue
      body
    end
  end
  
  def Paste.find_latest_pastes
    Paste.find(:all, :order => "created_on DESC", :limit => 20)
  end
end
