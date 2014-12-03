class @PopupTemplates
  @parseEsriDate = (esriFieldTypeDate) ->
    if esriFieldTypeDate == null
      "<i>(#{I18n.t('map.no_date')})</i>"
    else
      # NOTE: We use DD.MM.YYYY numeric format here, so perhaps it's better to leave it on the default 'pl' locales
      new Date(esriFieldTypeDate).toLocaleDateString('pl')

  # Popup templates for features; what is displayed depends on the returned WFS server feature data
  # Run as dynamic functions in order to be able to use proper locales
  @districtPopupTemplate: -> """
      <h3>{NAZWA}{NR_PLANU}</h3>#{I18n.t('krakow.mpzp.Status')}: {STATUS}<br>
      #{I18n.t('map.dates')}:<br><small>
        #{I18n.t('krakow.mpzp.DATA_PRZYS')}: {DATA_PRZYS}<br>
        #{I18n.t('krakow.mpzp.DATA_UCHWA')}: {DATA_UCHWA}<br>
        #{I18n.t('krakow.mpzp.DATA_DUWM')}: {DATA_DUWM}<br>
        #{I18n.t('krakow.mpzp.DATA_OBOWI')}: {DATA_OBOWI}<br></small>
      #{I18n.t('krakow.mpzp.BIP')}: {BIP}<br>
      #{I18n.t('krakow.mpzp.PROWADZACY')}: {PROWADZACY}<br>
      #{I18n.t('krakow.mpzp.WYKONANIE')}: {WYKONANIE}<br>
      <small>#{I18n.t('krakow.mpzp.FID')}: {FID}</small>
    """

  @zonePopupTemplate: -> """
    <h3>{OZNACZENIE} ({RODZAJ_OZN})</h3>
    #{I18n.t('map.dates')}:<br><small>
      #{I18n.t('krakow.mpzp.DATA_AKTUA')}: {DATA_AKTUA}<br>
      #{I18n.t('krakow.mpzp.DATA_UCHWA')}: {DATA_UCHWA}<br>
      #{I18n.t('krakow.mpzp.DATA_DUWM')}: {DATA_DUWM}<br>
      #{I18n.t('krakow.mpzp.DATA_OBOWI')}: {DATA_OBOWI}<br></small>
    #{I18n.t('map.plan')}: {NAZWA_MPZP}<br>
    <small>#{I18n.t('krakow.mpzp.FID')}: {FID}</small>
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
          BIP: "<a href='#{feature.properties.WWW}'>#{I18n.t('krakow.mpzp.bip_link')}</a><br>"
