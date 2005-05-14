class ArchiveController < ApplicationController
  def index
    @pastes = Paste.find(:all, :order => "created_on DESC")
  end

  def sort_by_author
    @pastes = Paste.find(:all, :order => "author")
    render_action "index"
  end
  
  def sort_by_language
    @pastes = Paste.find(:all, :order => "language")
    render_action "index"
  end
  
  def sort_by_description
    @pastes = Paste.find(:all, :order => "description")
    render_action "index"
  end

  def sort_by_date
    @pastes = Paste.find(:all, :order => "created_on")
    render_action "index"
  end
end
