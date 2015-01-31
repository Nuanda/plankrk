class DiscussionsController < ApplicationController
  include Ajaxable

  load_and_authorize_resource only: [:create, :destroy]
  layout false, except: :show

  def index
    if params[:fid]
      @discussions = Discussion.about params[:fid]
      if params[:list_only]
        render partial: 'list', object: @discussions
      end
    else
      @recently_created = Discussion.recently_created
      @recently_commented = Discussion.recently_commented.all
      render 'recent'
    end
  end

  def show
    @discussion = Discussion.find params[:id]

    if request.xhr?
      render 'show', layout: false
    else
      # render 'index', layout: true
      render 'home/index', layout: true
    end
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
