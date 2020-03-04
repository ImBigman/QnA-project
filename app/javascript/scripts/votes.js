document.addEventListener('turbolinks:load', function() {
    function resourceVote(selector) {
        $(selector).on('ajax:success', function (e) {
            let vote = e.detail[0];

            $('.' + vote['type']  + '-vote-errors .errors').html(' ');
            $('.' + vote['type'] + '_id_' + vote['id'] + ' #vote-score').html('<span>' + vote['rating'] + '</span>');
        })
            .on('ajax:error', function (e) {
                let errors = e.detail[0];

                $('.' + errors['type'] + '-vote-errors .errors').html('<span>' + errors['error'] + '</span>')
            });
    }

    resourceVote('.vote-block a#vote-for');

    resourceVote('.vote-block a#vote-against');
});
