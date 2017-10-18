question_edit = ->
  $('body').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('form#edit-question-' + question_id).show();

$(document).ready(question_edit);

question_channel = ->
  App.cable.subscriptions.create('QuestionsChannel', {
    received: (data) ->
      $('.questions').append(JST['templates/question'](data))
  })

$(document).on('page:load', question_channel);
$(document).ready(question_channel);
