class @Discussions
  @initialize = ->
    console.log 'INIT: Discussions initialization'

    # Disqus config variables
    disqus_shortname = 'plankrkdevelopment'

    disqus_config = ->
      this.language = I18n.locale

    $ ->
      dsq = document.createElement('script')
      dsq.type = 'text/javascript'
      dsq.async = true
      dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js'
      (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq)

    $('body').on 'show.bs.collapse', '.discussion-body', ->
      console.log $(this).attr('data-discussion')
      $('#disqus_thread').remove()
      discussionPath = Routes.discussion_path(
        locale: I18n.locale
        id: $(this).attr('data-discussion')
      )
      $.get discussionPath, (data) =>
        $("[data-discussion=#{$(this).attr('data-discussion')}] .panel-body").html data


  @reset = (newIdentifier) ->
    disqus_identifier = newIdentifier
    disqus_url = 'http://localhost:3000/' + newIdentifier
    DISQUS.reset(
      reload: true,
      config: ->
        alert 'Loading thread for ' + newIdentifier
        this.page.identifier = newIdentifier
        this.page.url = 'http://localhost:3000/' + newIdentifier
        this.page.title = newIdentifier
    )
