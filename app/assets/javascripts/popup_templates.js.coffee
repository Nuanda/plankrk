class @PopupTemplates
  @parseEsriDate = (esriFieldTypeDate) ->
    if esriFieldTypeDate == null
      # TODO: locales!
      "<i>(no date given)</i>"
    else
      # NOTE: We use DD.MM.YYYY numeric format here, so perhaps it's better to leave it on the default 'pl' locales
      new Date(esriFieldTypeDate).toLocaleDateString('pl')

  # TODO We need proper locales here, introduce i18n.js for strings
  # Popup templates for features; what is displayed depends on the returned WFS server feature data
  @districtPopupTemplate = """
    <h3>{NAZWA}{NR_PLANU}</h3>Status: {STATUS}<br>
    Daty:<br><small>
      DATA_PRZYS: {DATA_PRZYS}<br>
      DATA_UCHWA: {DATA_UCHWA}<br>
      DATA_DUWM: {DATA_DUWM}<br>
      DATA_OBOWI: {DATA_OBOWI}<br></small>
    BIP: {BIP}<br>
    PROWADZACY: {PROWADZACY}<br>
    WYKONANIE: {WYKONANIE}<br>
    <small>Feature ID: {FID}</small>
  """

  @zonePopupTemplate = """
    <h3>{OZNACZENIE} ({RODZAJ_OZN})</h3>
    Daty:<br><small>
      DATA_AKTUA: {DATA_AKTUA}<br>
      DATA_UCHWA: {DATA_UCHWA}<br>
      DATA_DUWM: {DATA_DUWM}<br>
      DATA_OBOWI: {DATA_OBOWI}<br></small>
    Plan: {NAZWA_MPZP}<br>
    BIP: {BIP}<br>
    <small>Feature ID: {FID}</small>
  """

  @dateNames = ['DATA_UCHWA', 'DATA_PRZYS', 'DATA_DUWM', 'DATA_OBOWI', 'DATA_AKTUA']

  @bindPopup = (featureLayer, template) ->
    featureLayer.bindPopup (feature) =>
      for key of feature.properties
        if key in @dateNames
          feature.properties[key] = @parseEsriDate feature.properties[key]
      L.Util.template template,
        $.extend feature.properties,
          NR_PLANU: if feature.properties.NR_PLANU then " (#{feature.properties.NR_PLANU})" else ""
          BIP: "<a href='#{feature.properties.WWW}'>link</a><br>"
