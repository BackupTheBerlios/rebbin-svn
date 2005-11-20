$AUTHOR_COOKIE_NAME = "_rebbin_paste_author"

class PasteController < ApplicationController
  helper :paste
  caches_page :download

  def index
    @author_cookie_val = cookies[$AUTHOR_COOKIE_NAME]
    @pastes = Paste.find_latest_pastes
  end

  def show
    @pastes = Paste.find_latest_pastes

    paste_id = @params[:id]

    @paste = Paste.find(paste_id)

    if cache[paste_id].nil?
      cache[paste_id] = @paste.html_body
    end
    
    @paste.body = cache[paste_id]
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
        expire_page :controller => "archive", :action => "index"
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

  # API Section

  alias xmlrpc api

  def num_of_pastes
    Paste.count
  end

  def get_languages
    PasteHelper.get_supported_languages
  end

  def add_paste
    paste = Paste.new
    paste.author = @method_params[0] == "" ? "anonymous" : @method_params[0]
    paste.language = @method_params[1]
    paste.description = @method_params[2]
    paste.body = @method_params[3]
    
    paste.save
    paste.id.to_s
  end

  def get_paste
    paste = Paste.find(@method_params[0])
    paste_to_apistruct(paste)
  end

  def get_latest_pastes
    pastes = Paste.find_latest_pastes
    pastes.to_a.collect { |p| paste_to_apistruct(p) }
  end

  private

  def paste_to_apistruct(paste)
    PasteApiStructs::Paste.new(:author => paste.author,
                               :language => paste.language,
                               :description => paste.description,
                               :body => paste.body,
                               :created_on => paste.created_on)
  end

  def set_author_cookie(author)
    name = $AUTHOR_COOKIE_NAME
    cookies[name] = { :value => author, :expires => 2.weeks.from_now }
  end
end
