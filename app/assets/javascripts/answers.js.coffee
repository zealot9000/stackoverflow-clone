answer_edit = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

$(document).on('page:load', answer_edit);

answer_channel = ->
  App.cable.subscriptions.create('AnswersChannel', {
    received: (data) ->
      $('.answers').append(JST['templates/answer'](data))
  });

$(document).on('page:load', answer_channel);
$(document).ready(answer_channel);
