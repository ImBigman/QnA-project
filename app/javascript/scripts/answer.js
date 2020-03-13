document.addEventListener('turbolinks:load', function() {
    let answersBlock = $('.answers');

    answersBlock.on('click','.answer-edit', function(event) {
        event.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('.edit-answer-' + answerId).show();
    } );
    answersBlock.on('click','#answer-comment', function (event) {
        event.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('.answer_id_'+ answerId +'_body .comment-button').hide();
        $('.answer_id_'+ answerId +'_body .comment-block').show();
        $('.answer_id_'+ answerId +'_body #comment_body').val('');
    });
});

