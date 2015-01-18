class @Discussions
  @initialize = ->
    console.log 'INIT: Discussions initialization'

    $('body').on 'show.bs.collapse', '.discussion-body', (e) =>
      discussionId = $(e.target).attr('data-discussion')
      @loadDiscussion(discussionId)

    $('body').on 'ajax:success', '#new_comment', (e, data, status, xhr) ->
      $('#discussions').html data

    $('body').on 'ajax:success', '#new_discussion', (e, data, status, xhr) ->
      $('#discussions').html data
      $('#new-discussion #discussion_title').val('')
      $('#new-discussion').collapse('hide')

    $('body').on 'ajax:success', '#back-to-discussions', (e, data, status, xhr) ->
      $('#discussions-tab').html data

    $('body').on 'click', 'a[href=#discussions-tab]', ->
      discussionsPath = Routes.discussions_path(
        locale: I18n.locale
      )
      $.get discussionsPath, (data) ->
        $('#discussions-tab').html data

    $('body').on 'ajax:success', '.delete', (evt, data, status, xhr) ->
      $(this).parents('.panel').fadeOut()


  @loadDiscussion = (discussionId) ->
    discussionPath = Routes.discussion_path(
      discussionId,
      locale: I18n.locale
    )
    history.pushState(null, document.title, discussionPath)
    $.get discussionPath, (data) =>
      $('#discussions').html data
