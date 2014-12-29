$ ->
  new Dispatcher


class Dispatcher
  constructor: ->
    @initScripts()

  initScripts: ->
    dispatch = $('body').attr('data-dispatch')

    return false unless dispatch

    console.log "INIT: #{dispatch} dispatched"

    switch dispatch
      when 'home:index'
        new ZoningMap
        PopupTemplates.initialize()
