module XmlHelper
  def pub_date(time)
    time.getutc.strftime "%a, %e %b %Y %H:%M:%S %Z"
  end

  def paste_title(paste)
    "#{paste.id} - #{h paste.author}"
  end

  def paste_content(paste)
    "<pre>#{h paste.body}</pre>"
  end

  def paste_link(paste)
    paste_url(paste)
  end
end
