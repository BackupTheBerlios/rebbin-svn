class CommentController < ApplicationController
  session :off

  def create
    begin
      @comment = Comment.new 
      @comment.author = @params[:comment_author]
      @comment.email = @params[:email]
      @comment.uri = @params[:uri]
      @comment.body = @params[:body]
      @comment.paste_id = @params[:paste_id]

      @comment.save
      redirect_to :controller => "paste", :action => :show, :id => @params[:paste_id]
    rescue
      flash["notice"] = "Comment cannot be saved."
      redirect_to :controller => "paste", :action => :show, :id => @params[:paste_id]
    end
  end
end
