document.addEventListener('turbolinks:load', function() {
    $('.answers').on('click','.answer-edit', function (event) {
        event.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).show();
    } )
});
