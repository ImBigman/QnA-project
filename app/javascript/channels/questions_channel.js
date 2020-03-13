import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  let questionsList =  $('.questions');
  if (questionsList.length) {
    consumer.subscriptions.create("QuestionsChannel", {
      received(data) {
        switch (data.action) {
          case 'create':
            questionsList.append(data.item);
            break;
          case 'destroy':
              $(`.question_id_${data.id}`).remove();
        }
      }
    })
  }
});
