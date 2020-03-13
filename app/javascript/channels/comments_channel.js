import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id}, {
      received(data) {
        if (gon.user_id === data.comment.user_id) return;

        const template = require('../hbs/comment.hbs');

        $(`.${data.type}_id_${data.id} .empty`).hide();
        $(`.${data.type}_id_${data.id} .${data.type}-comments`).append(template(data));
      }
    })
});

