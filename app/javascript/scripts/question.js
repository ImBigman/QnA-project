document.addEventListener('turbolinks:load', function() {
       $('.question').on('click','#question-edit', function (event) {
        event.preventDefault();
        $(this).hide();
        $('.question-edit-form').show();
    });

    function questionVote(selector){
        $(selector).on('ajax:success', function (e) {
            let score = e.detail[0];

            $('.question-vote-errors .errors').html(' ');
            $('#vote-score').html('<span>'+ score + '</span>');
        })
            .on('ajax:error', function (e) {
                let errors = e.detail[0];

                $('.question-vote-errors .errors').html('<span>'+  errors['error']  + '</span>')
            });
    }

    questionVote('.question a#vote-for');

    questionVote('.question a#vote-against');

});
