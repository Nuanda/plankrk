class DiscussionsController < ApplicationController
  layout false

  def index
    @discussions = Discussion.about_fid params[:fid]
  end

  def show
  end

  def create
    @discussion = Discussion.create discussion_params
    @discussions = Discussion.about_fid params[:fid]
    render :index
  end


  private

  def discussion_params
    params.require(:discussion).permit(:title, :fid)
  end

end
