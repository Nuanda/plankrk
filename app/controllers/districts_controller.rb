class DistrictsController < ApplicationController

  # GET /district/:id
  # Here id == FID of the district WMS feature (should be unique)
  # WARNING: this will NOT be true for cross-WMS app
  #         (same FIDs for different features in two distinct cities)
  # We may use this operation to load feature-related data from our DB
  def show
    @data = params[:wms_data]
    render partial: 'show', layout: false
  end

end
