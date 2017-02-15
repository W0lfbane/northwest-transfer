$(document).on('turbolinks:load', function() {

    timebox = $('#timebox')
    datebox = $('#datebox')

    var update = function () {
        timebox.html( moment().format("h:mm A") );
        datebox.html( moment().format("MMMM Do") );
    };

    update();
    setInterval(update, 1000);

});
