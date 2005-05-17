module ApplicationHelper
  def paste_url(paste)
    url_for :only_path => false, :controller=> "paste", :action =>"show", :id => paste.id
  end
  
  def blog_title
    "Rebbin, the Rails pastebin"
  end
end
