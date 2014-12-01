class HomeController < ApplicationController
  def index
    # Use line bellow after #9 is merged
    # gon.zoning_map_sever_base_url =
    #   Rails.configuration.constants['krakow']['zoning_map_sever_base_url']
    gon.zoning_map_sever_base_url =
      'http://msip.um.krakow.pl/arcgis/rest/services/BP_MPZP/MapServer/'
  end
end
