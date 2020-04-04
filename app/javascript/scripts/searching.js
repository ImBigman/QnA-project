document.addEventListener('turbolinks:load', function() {
  let button =  document.getElementById("search-button");

  if (button)  {
    document.body.addEventListener("ajax:success", (event) => {
        let result = event.detail[0];
        let list = $('.results');
        list.html('');
        $('.result-title').html('<h6><strong>' + 'Search results: ' + result['count'] + '</strong></h6>');
        if (result['count'] !== 0) { list.append('<p>' + result['scope'] + ' search results:'+ '</p>') }

        function titless(title) {
            if (title === undefined) {
                return result['scope'].slice(0,-1);
            } return result['scope'].slice(0,-1) + '<br>' + title ;
        }
        function global(elem) {
            if (elem === undefined) {
                return '';
            } return elem ;
        }
        switch (result['scope']) {
            case "Questions":
                result['response'].forEach(element => list.append(
                    "<p class='p-2'>" + "<strong class = 'text-primary'>" + '# ' + element['id'] + '&nbsp' +
                    titless(element['title']) + '</strong>' + '<br>' + "<span style='font-size: 12pt;'>" + element['body'] +
                    "</span>" + '<br>' + "<span style='font-size: 8pt;'>" + new Date(element['created_at']) + "</span>" + "</p>"
                    )
                );
                break;
            case "Answers":
                result['response'].forEach(element => list.append(
                    "<p class='p-2'>" + "<strong class = 'text-primary'>" + ' # ' + element['question_id'] + ' Question ' + ' # ' + element['id'] +
                    '&nbsp' + titless(element['title']) + '</strong>' + '<br>' + "<span style='font-size: 12pt;'>" + element['body'] +
                    "</span>" + '<br>' + "<span style='font-size: 8pt;'>" + new Date(element['created_at']) + "</span>" + "</p>"
                    )
                );
                break;
            case "Comments":
                result['response'].forEach(element => list.append(
                    "<p class='p-2'>" + "<strong class = 'text-primary'>" + ' # ' + element['commentable_id'] + '&nbsp' + element['commentable_type']  +
                    ' # ' + element['id'] + '&nbsp' + titless(element['title']) + '</strong>' + '<br>' + "<span style='font-size: 12pt;'>"
                    + element['body'] + "</span>" + '<br>' + "<span style='font-size: 8pt;'>" + new Date(element['created_at']) + "</span>" + "</p>"
                    )
                );
                break;
            case "Users":
                result['response'].forEach(element => list.append(
                    "<p class='p-2'>" + "<strong class = 'text-primary'>" + titless(element['title']) +' # ' + element['id'] + '&nbsp' + element['email'] +  '</strong>' +
                    '<br>' + "<span style='font-size: 8pt;'>" + new Date(element['created_at']) + "</span>" + "</p>"
                    )
                );
                break;
            case "Global":
                result['response'].forEach(element => list.append(
                    "<p class='p-2'>"  + "<strong class = 'text-primary'>" + global(element['commentable_id']) + '&nbsp' + global(element['commentable_type']) + '&nbsp' +
                    global(element['question_id']) + ' # ' + element['id']  + '&nbsp' + global(element['title']) + '&nbsp' + global(element['body'] ) + '&nbsp' +
                    global(element['email']) + '</strong>' + '<br>' + "<span style='font-size: 8pt;'>" + new Date(element['created_at']) + "</span>" + "</p>"
                    )
                );
                break;
        }
    });
}});
