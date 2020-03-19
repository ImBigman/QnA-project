document.addEventListener('turbolinks:load', function() {
    let questionBlock = $('.question');
        questionBlock.on('click','#question-edit', function (event) {
        event.preventDefault();
        $(this).hide();
        $('.question-edit-form').show();
    });
        questionBlock.on('click','#question-comment', function (event) {
        event.preventDefault();
        $(this).hide();
        $('.question .comment-button').hide();
        $('.question .comment-block').show();
        $('.question #comment_body').val('');
    });
});
