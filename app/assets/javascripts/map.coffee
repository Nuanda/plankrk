$ ->

  # Create a map in the "map" div, set the view to Kraków and zoom level to 13
#  window.map = L.map('map').setView [50.06, 19.95], 13
  window.map = L.map('map').setView [50.06, 19.95], 15

#  # Add an OpenStreetMap tile layer; other tiles could be used as well - see below
#  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
#    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
#  }).addTo map

  # ESRI tiles - an alternative to OSM tiles (remember about the attribution and the ToU!)
  L.esri.basemapLayer('Streets').addTo(window.map);
#  L.esri.basemapLayer('Topographic').addTo(map);


  baseZoningUrl = "http://msip.um.krakow.pl/arcgis/rest/services/BP_MPZP/MapServer/"

  # Now we load MSIP map server feature layer
  # Layer 0 - detailed zoning plans, layer 1 - plan district contours (the end of the URL changes)
  # IMPORTANT: we have to switch CORS to null, and use JSONP, since UMK ArcGIS is too old to support CORS out of the box
  window.districtContours = new L.esri.FeatureLayer(
    baseZoningUrl + "1"
    useCors: false
    style: ->
      color: "#60ba39"
      weight: 3
  )

  window.detailedZoning = new L.esri.FeatureLayer(
    baseZoningUrl + "0"
    useCors: false
    style: ->
      color: "#dd4439"
      weight: 2
  )

  parseEsriDate = (esriFieldTypeDate) ->
    if esriFieldTypeDate == null
      '---'
    else
      # TODO This requires setting up the locale for data format
      new Date(esriFieldTypeDate).toLocaleDateString('pl')

  # TODO We need proper locales here, introduce i18n.js for strings and think about sth for Dates
  # Popup templates are for clicking a feature; what is displayed depends on the returned WFS server data
  districtPopupTemplate = """
    <h3>{NAZWA}{NR_PLANU}</h3>Status: {STATUS}<br>
    Daty:<br><small>
      DATA_PRZYS {DATA_PRZYS}<br>
      DATA_UCHWA {DATA_UCHWA}<br>
      DATA_DUWM {DATA_DUWM}<br>
      DATA_OBOWI {DATA_OBOWI}<br></small>
    BIP: <a href='{WWW}'>link</a><br>
    <small>Feature ID: {FID}</small>
  """

  window.districtContours.bindPopup (feature) ->
    L.Util.template districtPopupTemplate,
      $.extend feature.properties,
        DATA_UCHWA: parseEsriDate feature.properties.DATA_UCHWA
        DATA_PRZYS: parseEsriDate feature.properties.DATA_PRZYS
        DATA_DUWM: parseEsriDate feature.properties.DATA_DUWM
        DATA_OBOWI: parseEsriDate feature.properties.DATA_OBOWI
        NR_PLANU: if feature.properties.NR_PLANU == 0 then "" else " (#{feature.properties.NR_PLANU})"

  zonePopupTemplate = """
    <h3>{OZNACZENIE} ({RODZAJ_OZN})</h3>
    Daty:<br><small>
      DATA_AKTUA {DATA_AKTUA}<br>
      DATA_UCHWA {DATA_UCHWA}<br>
      DATA_DUWM {DATA_DUWM}<br>
      DATA_OBOWI {DATA_OBOWI}<br></small>
    Plan: {NAZWA_MPZP}
    BIP: <a href='{WWW}'>link</a><br>
    <small>Feature ID: {FID}</small>
  """

  window.detailedZoning.bindPopup (feature) ->
    L.Util.template zonePopupTemplate,
      $.extend feature.properties,
        DATA_AKTUA: parseEsriDate feature.properties.DATA_AKTUA
        DATA_UCHWA: parseEsriDate feature.properties.DATA_UCHWA
        DATA_DUWM: parseEsriDate feature.properties.DATA_DUWM
        DATA_OBOWI: parseEsriDate feature.properties.DATA_OBOWI

  # Let's start with district contours
  window.districtContours.addTo window.map


  $('#zoning-switch').on 'click', ->
    if window.map.hasLayer window.districtContours
      window.map.removeLayer window.districtContours
    else
      window.map.addLayer window.districtContours

    if window.map.hasLayer window.detailedZoning
      window.map.removeLayer window.detailedZoning
    else
      window.map.addLayer window.detailedZoning
