$ ->
  new Dispatcher


class Dispatcher
  constructor: ->
    @initScripts()

  initScripts: ->
    dispatch = $('body').attr('data-dispatch')

    return false unless dispatch

    console.log "INIT [Dispatcher]: #{dispatch} dispatched"

    @initZoningMap()

    switch dispatch
      when 'home:index'
        Discussions.initialize() #Needed for discussion load
      when 'discussions:show'
        Discussions.initialize()
        discussionId = window.location.pathname.split('/').pop()
        Discussions.loadDiscussion(discussionId)
        @switchTabs('#discussions-tab')

  initZoningMap: ->
    console.log 'INIT [Dispatcher]: initializing Zoning Map component'
    new ZoningMap
    PopupTemplates.initialize()

  switchTabs: (targetTab) ->
    console.log "INIT [Dispatcher]: switching left section to #{targetTab}"
    $("#left-section a[href=#{targetTab}]").tab 'show'
