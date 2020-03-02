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
            let xhr = e.detail[2];

            $('.answer_id_' + answerId + ' #vote-score').html(xhr.responseText);
        })
            .on('ajax:error', function (e) {
                let xhr = e.detail[2];

                $('.answer-vote-errors').html(xhr.responseText);
            })
    }

    answersBlock.on('click','#vote-for', changeScore);

    answersBlock.on('click','#vote-against', changeScore);

});

