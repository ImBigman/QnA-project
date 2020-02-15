document.addEventListener('turbolinks:load', function() {
    $('.question').on('click','#question-edit', function (button) {
        button.preventDefault();
        $(this).hide();
        $('form#edit-question').show();
    } )
});
