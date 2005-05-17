class ArchiveController < ApplicationController
  def index
    @pastes = Paste.find_all
  end

  def sort_by_author
    @pastes = Paste.find_all_by_author
    render_action "index"
  end
  
  def sort_by_language
    @pastes = Paste.find_all_by_language
    render_action "index"
  end
  
  def sort_by_description
    @pastes = Paste.find_all_by_description
    render_action "index"
  end

  def sort_by_date
    @pastes = Paste.find_all_by_date
    render_action "index"
  end
end
