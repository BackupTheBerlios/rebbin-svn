class XmlController < ApplicationController
  caches_page :rss, :atom
  session :off

  def rss
    @pastes = Paste.find_latest_pastes
  end

  def atom
    rss
  end
end
