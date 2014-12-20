class @DistrictInfoManager

  # NOTE: currently this could be done entirely on the client side, since we
  # have all the needed data. However, in the future, it is likely we want to
  # go through the server as we would need additional data from the DB
  @showDistrictInfo: (districtInfo) ->
    districtPath = Routes.district_path(
      districtInfo.FID
      locale: I18n.locale
      wms_data: districtInfo
    )

    $.get districtPath, (data) ->
      $('#info-tab').html data
