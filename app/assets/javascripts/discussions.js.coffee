class @Discussions
  @initialize = ->
    console.log 'INIT: Discussions initialization'

    $('body').on 'show.bs.collapse', '.discussion-body', ->
      discussionId = $(this).attr('data-discussion')
      discussionPath = Routes.discussion_path(
        locale: I18n.locale
        id: discussionId
      )
      $.get discussionPath, (data) =>
        $("[data-discussion=#{discussionId}] .panel-body").html data

    $('body').on 'ajax:success', '#new_discussion', (e, data, status, xhr) ->
      $('#discussions').html data
      $('#new-discussion #discussion_title').val('')
      $('#new-discussion').collapse('hide')

    $('body').on 'click', 'a[href=#discussions-tab]', ->
      discussionsPath = Routes.discussions_path(
        locale: I18n.locale
      )
      $.get discussionsPath, (data) ->
        $('#discussions-tab').html data

    $('body').on 'ajax:success', '.delete', (evt, data, status, xhr) ->
      $(this).parents('.panel').fadeOut()
