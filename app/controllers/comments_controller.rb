class CommentsController < ApplicationController
  include Ajaxable

  load_and_authorize_resource only: [:create]
  layout false

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
