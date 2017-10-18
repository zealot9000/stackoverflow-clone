answer_edit = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

$(document).on('page:load', answer_edit);

answers_channel = ->
  question_id = $('.answers').data('question-id')
  App.cable.subscriptions.create {
    channel: "AnswersChannel"
    question_id: question_id
  },

    received: (data) ->
      unless gon.user_id == data.answer.user_id
        $('.answers').append(JST['templates/answer'](data))

$(document).on('page:load', answers_channel);
$(document).ready(answers_channel);
