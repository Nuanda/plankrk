#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require turbolinks
#= require i18n
#= require i18n/translations
#= require bootstrap-sprockets
#= require leaflet
#= require esri-leaflet
#= require_tree .

$ ->
  # Flash
  if (flash = $(".flash-container")).length > 0
    flash.click -> $(@).fadeOut()
    flash.show()
    setTimeout (-> flash.fadeOut()), 5000

  # Bottom tooltip
  $('.has_bottom_tooltip').tooltip(placement: 'bottom')
