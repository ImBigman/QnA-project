document.addEventListener('turbolinks:load', function() {
       $('.question').on('click','#question-edit', function (event) {
        event.preventDefault();
        $(this).hide();
        $('.question-edit-form').show();
    });

    function questionVote(selector){
        $(selector).on('ajax:success', function (e) {
            let xhr = e.detail[2];

            $('#vote-score').html(xhr.responseText);
        })
            .on('ajax:error', function (e) {
                let xhr = e.detail[2];

                $('.question-vote-errors .errors').html(xhr.responseText);
            });
    }

    questionVote('.question a#vote-for');

    questionVote('.question a#vote-against');

});
