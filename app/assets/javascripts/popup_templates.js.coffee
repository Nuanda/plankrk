class @PopupTemplates
  @initialize = ->
    console.log 'INIT: PopupTemplates initialization'
    $('body').on 'click', 'button[data-fid]', ->
      discussionsPath = Routes.discussions_path(
        locale: I18n.locale
        fid: $(this).attr('data-fid')
        district: $(this).attr('data-district')
        zone: $(this).attr('data-zone')
      )
      $.get discussionsPath, (data) ->
        $('#discussions-tab').html data
        $('#left-section a[href="#discussions-tab"]').tab 'show'

  @parseEsriDate = (esriFieldTypeDate) ->
    if esriFieldTypeDate == null
      "<i>(#{I18n.t('map.no_date')})</i>"
    else
      # NOTE: We use DD.MM.YYYY numeric format here, so perhaps it's better to leave it on the default 'pl' locales
      new Date(esriFieldTypeDate).toLocaleDateString('pl')

  # Popup templates for features; what is displayed depends on the returned WFS server feature data
  # Run as dynamic functions in order to be able to use proper locales
  @zonePopupTemplate = -> """
    <h3>{OZNACZENIE} ({RODZAJ_OZN})</h3>
    #{I18n.t('map.plan')}: {NAZWA_MPZP}<br>
    <div class="btn-group" role="group">
      <button type="button" class="btn btn-sm"
        data-fid="{FID}"
        data-district="{NAZWA_MPZP}"
        data-zone="{OZNACZENIE}"
        title="#{I18n.t('map.show_discussions.tooltip')}">
        <i class="fa fa-comments-o"></i>
      </button>
    </div><br>
    <small><small>#{I18n.t('krakow.mpzp.FID')}: {FID}</small></small>
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
