document.addEventListener('turbolinks:load', function() {
    let subscriptionsBlock = $('.subscriptions');
    subscriptionsBlock.on('click','a .octicon-bookmark', function (event) {
        event.preventDefault();
        let buttonState = $(this).attr('id');
        switch (buttonState) {
            case "mark-disabled":
                $(this).removeClass("text-muted");
                $(this).addClass("text-warning");
                $(this).attr("id", "mark-enabled");
                break;
            case "mark-enabled":
                $(this).removeClass("text-warning");
                $(this).addClass("text-muted");
                $(this).attr("id", "mark-disabled");
                break;
        }
    });
});
