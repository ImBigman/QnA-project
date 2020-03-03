document.addEventListener('turbolinks:load', function() {
    let answersBlock = $('.answers');

    answersBlock.on('click','.answer-edit', function(event) {
        event.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('.edit-answer-' + answerId).show();
    } );

    function changeScore() {
        let answerId = $(this).attr("href").match(/\d+/)[0];

        $(this).on('ajax:success', function (e) {
            let score = e.detail[0];

            $('.answer-vote-errors').html(' ');
            $('.answer_id_' + answerId + ' #vote-score').html('<span>'+ score + '</span>');
        })
            .on('ajax:error', function (e) {
                let errors = e.detail[0];

                $('.answer-vote-errors').html('<span>'+  errors['error']  + '</span>');
            })
    }

    answersBlock.on('click','#vote-for', changeScore);

    answersBlock.on('click','#vote-against', changeScore);

});

