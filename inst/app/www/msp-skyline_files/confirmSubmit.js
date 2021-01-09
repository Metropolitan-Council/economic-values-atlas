var confirmSubmit;

// -----------------------------------------------
//  Module to submit a form based on whether a
//  user has answered yes/no to a confirm prompt
// -----------------------------------------------

confirmSubmit = (function() {
    'use strict';

    var confirmElement,
        confirmMessage,
        formTarget;

    function init() {
        $('.js-confirm-submit').on('click', function(e) {
            confirmMessage = $(this).data('message');
            formTarget = $(this).data('target');
            promptUser(confirmMessage, formTarget);
            e.preventDefault();
        });
    }

    function promptUser(confirmMessage, formTarget){
        confirmElement = confirm(confirmMessage);
        if(confirmElement){
            $(formTarget).submit();
        }
    }

    return {
        init:init
    };

}());
