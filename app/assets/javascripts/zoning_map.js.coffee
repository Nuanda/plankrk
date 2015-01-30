class @ZoningMap
  constructor: ->
    $('#zoning-map').css('min-height', window.innerHeight - 50)

    # Create a map in the "map" div, set the view to Kraków and zoom level to 13
    @zoningMap = L.map('zoning-map', { zoomControl: false })
                  .setView [50.06, 19.95], 13
    new L.Control.Zoom(
      zoomInTitle: I18n.t('map.zoom_in')
      zoomOutTitle: I18n.t('map.zoom_out')
    ).addTo @zoningMap

    L.tileLayer(Config.CDB_TILE_URL,{
      attribution: Config.OSM_ATTRIBUTION + ', ' + Config.CDB_ATTRIBUTION
    }).addTo @zoningMap

    baseZoningUrl = Config.ZONING_MAP_SERVER_BASE_URL


    @featureColor = (feature, style = 'BASE') ->
      if feature.properties.STATUS == 'SPORZĄDZANY'
        Config["PREP_DISTRICT_#{style}_COLOR"]
      else if feature.properties.STATUS == 'OBOWIĄZUJĄCY'
        Config["READY_DISTRICT_#{style}_COLOR"]
      else
        Config["ZONE_#{style}_COLOR"]

    # Now we load MSIP map server feature layer from UMK ArcGIS server
    # Layer 0 - detailed zoning plans, layer 1 - zoning plan district contours
    # IMPORTANT: we have to switch CORS to null, and use JSONP, since UMK ArcGIS is too old to support CORS out of the box
    @districtContours = new L.esri.FeatureLayer(
      baseZoningUrl + "1"
      useCors: false
      style: (feature) =>
        color: @featureColor(feature)
        weight: 3
    )

    @detailedZoning = new L.esri.FeatureLayer(
      baseZoningUrl + "0"
      useCors: false
      style: (feature) =>
        color: @featureColor(feature)
        weight: 2
    )

    oldSelectedDistrictId = null
    oldClickedDistrictId = null

    mouseoverFunc = (e, color, layer) ->
      featureId = e.layer.feature.id
      if oldClickedDistrictId != featureId
        if oldSelectedDistrictId != oldClickedDistrictId
          layer.resetStyle(oldSelectedDistrictId)
        oldSelectedDistrictId = featureId
        layer.setFeatureStyle featureId, ->
          color: color
          weight: 5
          opacity: 1

    clickFunc = (e, color, layer) ->
      layer.resetStyle(oldClickedDistrictId)
      oldClickedDistrictId = e.layer.feature.id
      layer.setFeatureStyle e.layer.feature.id, ->
        color: color
        weight: 5
        opacity: 1

    @detailedZoning.on 'load', (e) =>
      # Switch district countours off when detailed zoning is shown
      @zoningMap.removeLayer @districtContours
      # District tooltips are no longer useful now
      $(oldTooltipElement).tooltip 'destroy'

    @districtClickCallback = (e) =>
      # Zoom to the district
      district = @districtContours.getFeature e.layer.feature.id
      @zoningMap.fitBounds district.getBounds()
      # Query detailed zoning for that district only and show it
      @detailedZoning.setWhere 'OGLOSZENIE="' + e.layer.feature.properties.OGLOSZENIE + '"'
      @zoningMap.addLayer @detailedZoning
      DistrictInfoManager.showDistrictInfo e.layer.feature.properties

    oldTooltipElement = null

    @createDistrictTooltip = (e) =>
      # Create new tooltip handler
      $(e.originalEvent.fromElement).tooltip
        title: e.layer.feature.properties.NAZWA
        placement: 'right'
        container: 'body'
      # Show the tooltip and replace to the mouse locations
      $(e.originalEvent.fromElement).tooltip 'show'
      $('.tooltip').css 'top', e.originalEvent.pageY
      $('.tooltip').css 'left', e.originalEvent.pageX + 10
      # Save the svg element of that tooltip for later removing
      oldTooltipElement = e.originalEvent.fromElement

    @swapLayers = (from, to) ->
      @zoningMap.removeLayer from
      unless @zoningMap.hasLayer to
        @zoningMap.addLayer to

    @districtContours.on 'mouseover', (e) =>
      mouseoverFunc(e, @featureColor(e.layer.feature), @districtContours)
      @createDistrictTooltip e

    @districtContours.on 'mousemove', (e) =>
      # Let the district name tooltip follow the mouse move
      $('.tooltip').css 'top', e.originalEvent.pageY
      $('.tooltip').css 'left', e.originalEvent.pageX + 10

    @districtContours.on 'mouseout', (e) =>
      @districtContours.resetStyle(oldSelectedDistrictId)
      $(oldTooltipElement).tooltip 'destroy'

    @districtContours.on 'click', (e) =>
      clickFunc(e, @featureColor(e.layer.feature, 'DEEP'), @districtContours)
      @districtClickCallback(e)

    @detailedZoning.on 'mouseover', (e) =>
      mouseoverFunc(e, Config.ZONE_BASE_COLOR, @detailedZoning)
    @detailedZoning.on 'mouseout', (e) =>
      @detailedZoning.resetStyle(oldSelectedDistrictId)
    @detailedZoning.on 'click', (e) =>
      clickFunc(e, Config.ZONE_DEEP_COLOR, @detailedZoning)

    @zoningMap.on 'zoomend', (e) =>
      if e.target.getZoom() < 15
        @swapLayers(@detailedZoning, @districtContours)

    # Binding popup templates to features of both layers, to be shown on feature click
    PopupTemplates.bindPopup @detailedZoning, PopupTemplates.zonePopupTemplate()

    # Let's start with district contours
    @districtContours.addTo @zoningMap


    $('#zoom-out-button').on 'click', =>
      # Assure only districts are shown
      @swapLayers(@detailedZoning, @districtContours)
      # Zoom the map to proper bounds
      southWest = L.latLng Config.MAX_BOUNDS_SOUTH, Config.MAX_BOUNDS_WEST
      northEast = L.latLng Config.MAX_BOUNDS_NORTH, Config.MAX_BOUNDS_EAST
      bounds = L.latLngBounds southWest, northEast
      @zoningMap.fitBounds bounds
      # NOTE: alternative dynamic version, that queries the server for bounds
      #       this works much, much slower
      #       for proper UX this would require some kind of caching
#      @districtContours.query().run (error, geojson, response) =>
#        bounds = L.geoJson(geojson).getBounds()
#        @zoningMap.fitBounds bounds
