// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {

    $('[data-form-prepend]').click( function(e) {
        e.preventDefault();
        
        var linkText = $(this).text() ;

        if(linkText.indexOf("Document") != -1){
          $(this).hide();
        }
    });

});