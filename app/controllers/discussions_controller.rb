class DiscussionsController < ApplicationController
  layout false

  def index
    @discussions = Discussion.about_fid params[:fid]
  end

end
