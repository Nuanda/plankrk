class DiscussionsController < ApplicationController
  include Ajaxable

  load_and_authorize_resource only: [:create, :destroy]
  layout false

  def index
    if params[:fid]
      @discussions = Discussion.about params[:fid]
    else
      @recently_created = Discussion.recently_created
      @recently_commented = Discussion.recently_commented.all
      render 'recent'
    end
  end

  def show
    @discussion = Discussion.find params[:id]
  end

  def create
    @discussion.save!

    @discussions = Discussion.about params[:discussion][:fid]
    render partial: 'list', object: @discussions
  end

  def destroy
    @discussion.destroy!

    head :ok
  end

  private

  def discussion_params
    params.require(:discussion).
      permit(:title, :fid).
      merge(author: current_user)
  end
end
