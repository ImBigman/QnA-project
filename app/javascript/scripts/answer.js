document.addEventListener('turbolinks:load', function() {
    let answersBlock = $('.answers');

    answersBlock.on('click','.answer-edit', function(event) {
        event.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('.edit-answer-' + answerId).show();
    } );
});

