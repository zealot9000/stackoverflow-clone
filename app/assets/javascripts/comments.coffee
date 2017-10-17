comments = ->
  $('.question, .answers').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $(response.css_path + ' .comments').append(JST['templates/comment'](response))
    $(response.css_path + ' #comment_body').val('');

$(document).on('page:load', comments);
$(document).ready(comments);

comment_channel = ->
  question_id = $('.answers').data('question-id')
  App.cable.subscriptions.create {
    channel: "CommentsChannel"
    question_id: question_id
  },

    received: (data) ->
      if gon.user_id != data.author_comment
        $(data.css_path + '.comments').append(JST['templates/comment'](data))

$(document).on('page:load', comment_channel);
$(document).ready(comment_channel);
