class Comment < ActiveRecord::Base
  belongs_to :paste

  validates_presence_of :paste_id
  validates_presence_of :author
  validates_presence_of :body

  validates_length_of :author, :maximum => 30
end
