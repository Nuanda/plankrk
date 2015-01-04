class DiscussionsController < ApplicationController
  layout false

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
    @discussion = Discussion.create discussion_params
    @discussions = Discussion.about_fid params[:discussion][:fid]
    render partial: 'list', object: @discussions
  end


  private

  def discussion_params
    params.require(:discussion).permit(:title, :fid)
  end

end
