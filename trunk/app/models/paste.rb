class Paste < ActiveRecord::Base
  timestamps_gmt = true

  validates_presence_of :author
  validates_presence_of :language
  validates_presence_of :body

  validates_length_of :author, :maximum => 20
  validates_length_of :language, :maximum => 20
  validates_length_of :description, :maximum => 50
end
