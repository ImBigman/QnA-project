document.addEventListener('turbolinks:load', function() {
    $('.answers').on('click','#answer-best', function (event) {
        event.preventDefault();
        $(this).removeClass('btn-light').addClass('btn-success');
        $(this).removeClass('text-muted').addClass('text-light');
    } )
});
