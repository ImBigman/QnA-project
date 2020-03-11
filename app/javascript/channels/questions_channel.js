import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  let questionsList =  $('.questions');
  if (questionsList.length) {
    consumer.subscriptions.create("QuestionsChannel", {
      received(data) {
        if (data.action === 'create') {
          questionsList.append(data.item);
        }
        if (data.action === 'destroy') {
          $('.question_id_'+ data.id).remove();
        }
      }
    })
  }
});
