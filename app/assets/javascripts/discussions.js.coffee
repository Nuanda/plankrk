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
      (document.getElementsByTagName('head')[0] ||
       document.getElementsByTagName('body')[0]).appendChild(dsq)

    $('body').on 'show.bs.collapse', '.discussion-body', ->
      discussionId = $(this).attr('data-discussion')
      $('#disqus_thread').remove()
      discussionPath = Routes.discussion_path(
        locale: I18n.locale
        id: discussionId
      )
      $.get discussionPath, (data) =>
        $("[data-discussion=#{discussionId}] .panel-body").html data


  @reset = (discussionId) ->
    # TODO FIXME this seems not to create/load new thread per discussion
    DISQUS.reset(
      reload: true,
      config: ->
        this.page.identifier = discussionId
        this.page.url = 'http://localhost:3000/' + discussionId
        this.page.title = discussionId
    )
