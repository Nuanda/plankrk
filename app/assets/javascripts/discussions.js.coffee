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
      $('#discussions-tab').html data
