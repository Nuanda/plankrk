class DiscussionsController < ApplicationController
  load_and_authorize_resource only: :create
  layout false

  rescue_from CanCan::AccessDenied do |exception|
    render_error(exception.message, status: current_user ? 403 : 401)
  end

  def index
    if params[:fid]
      @discussions = Discussion.about_fid params[:fid]
    else
      render 'recent'
    end
  end

  def show
  end

  def create
    @discussion.save!

    @discussions = Discussion.about_fid params[:discussion][:fid]
    render partial: 'list', object: @discussions
  end

  private

  def discussion_params
    params.require(:discussion).
      permit(:title, :fid).
      merge(author: current_user)
  end
end
