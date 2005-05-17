$AUTHOR_COOKIE_NAME = "_rebbin_paste_author"

class PasteController < ApplicationController
  helper :paste

  def index
    @author_cookie_val = cookies[$AUTHOR_COOKIE_NAME]
    @pastes = Paste.find(:all, :order => "created_on DESC", :limit => 20)
  end

  def show
    @pastes = Paste.find(:all, :order => "created_on DESC", :limit => 20)
    paste_id = @params[:id]
    
    if cache[paste_id].nil?
      @paste = Paste.find(paste_id)
      cache[paste_id] = {
        :id => @paste.id,
        :author => @paste.author,
        :language => @paste.language,
        :description => @paste.description,
        :body => @paste.html_body, 
        :created_on => @paste.created_on
      }
    end
    @paste = cache[paste_id]
  end

  def create
    begin
      @paste = Paste.new
      @paste.author = @params[:author] == "" ? "anonymous" : @params[:author]
      @paste.language = @params[:language]
      @paste.description = @params[:description]
      @paste.body = @params[:body]

      @author_cookie_val = cookies[$AUTHOR_COOKIE_NAME]
      if @author_cookie_val == "" or @paste.author != @author_cookie_val
        set_author_cookie(@paste.author)
      end

      if @paste.save
        redirect_to :action => "show", :id => @paste.id
      else
        redirect_to :action => "index"
      end
    rescue
      flash["notice"] = "Paste could not be saved."
      redirect_to :action => "index"
    end
  end

  def download
    @paste = Paste.find(@params[:id])
    send_data @paste.body, :type => "text/plain; charset=utf-8", :disposition => "inline"
  end

  private

  def set_author_cookie(author)
    name = $AUTHOR_COOKIE_NAME
    cookies[name] = { :value => author, :expires => 2.weeks.from_now }
  end
end
