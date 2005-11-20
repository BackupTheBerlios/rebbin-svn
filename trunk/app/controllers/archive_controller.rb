class ArchiveController < ApplicationController
  helper :sort
  include SortHelper
  caches_page :index

  def index
    sort_init "created_on", "desc"
    sort_update
    @pastes = Paste.find(:all, :order => sort_clause)
  end
end
