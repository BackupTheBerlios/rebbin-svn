class XmlController < ApplicationController
  caches_page :rss, :atom03, :atom10
  session :off

  def rss
    @pastes = Paste.find_latest_pastes
  end

  def atom03
    rss
  end

  def atom10
    rss
  end
end
