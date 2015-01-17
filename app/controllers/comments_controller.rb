class CommentsController < ApplicationController
  load_and_authorize_resource only: [:create]
  layout false

  rescue_from CanCan::AccessDenied do |exception|
    render_error(exception.message, status: current_user ? 403 : 401)
  end


  def create
    @comment.save!
    @discussion = @comment.discussion
    render 'discussions/show'
  end


  private

  def comment_params
    params.require(:comment).
           permit(:content, :discussion_id).
           merge(author: current_user)
  end
end
