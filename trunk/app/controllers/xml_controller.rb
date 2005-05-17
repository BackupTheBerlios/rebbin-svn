class XmlController < ApplicationController
  caches_page :rss, :atom

  def rss
    @pastes = Paste.find_latest_pastes
  end

  def atom
    @pastes = Paste.find_latest_pastes
  end
end
