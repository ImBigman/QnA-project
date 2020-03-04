document.addEventListener('turbolinks:load', function() {
       $('.question').on('click','#question-edit', function (event) {
        event.preventDefault();
        $(this).hide();
        $('.question-edit-form').show();
    });
});
