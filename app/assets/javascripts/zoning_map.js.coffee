class @ZoningMap
  constructor: ->
    # Create a map in the "map" div, set the view to Kraków and zoom level to 13
    @zoningMap = L.map('zoning-map').setView [50.06, 19.95], 13

    # Add an OpenStreetMap tile layer; other tiles could be used as well - see below
    # NOTE: please do not localize the 'contributors' word here, it's kind of ToU requirement
    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo @zoningMap

    baseZoningUrl = Config.ZONING_MAP_SERVER_BASE_URL

    # Now we load MSIP map server feature layer from UMK ArcGIS server
    # Layer 0 - detailed zoning plans, layer 1 - zoning plan district contours
    # IMPORTANT: we have to switch CORS to null, and use JSONP, since UMK ArcGIS is too old to support CORS out of the box
    @districtContours = new L.esri.FeatureLayer(
      baseZoningUrl + "1"
      useCors: false
      style: ->
        color: "#60ba39"
        weight: 3
    )

    @detailedZoning = new L.esri.FeatureLayer(
      baseZoningUrl + "0"
      useCors: false
      style: ->
        color: "#dd4439"
        weight: 2
    )

    # Binding popup templates to features of both layers, to be shown on feature click
    PopupTemplates.bindPopup @districtContours, PopupTemplates.districtPopupTemplate()
    PopupTemplates.bindPopup @detailedZoning, PopupTemplates.zonePopupTemplate()

    # Let's start with district contours
    @districtContours.addTo @zoningMap


    # A temporary switch for dev/demo purposes - should be replaced in the future
    $('#zoning-switch').on 'click', =>
      if @zoningMap.hasLayer @districtContours
        @zoningMap.removeLayer @districtContours
      else
        @zoningMap.addLayer @districtContours

      if @zoningMap.hasLayer @detailedZoning
        @zoningMap.removeLayer @detailedZoning
      else
        @zoningMap.addLayer @detailedZoning
