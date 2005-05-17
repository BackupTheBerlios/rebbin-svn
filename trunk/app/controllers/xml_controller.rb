class XmlController < ApplicationController
  def rss
    @pastes = Paste.find_latest_pastes
  end

  def atom
    @pastes = Paste.find_latest_pastes
  end
end
