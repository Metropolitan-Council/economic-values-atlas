/* global notify, dropdown */
var sendSharepoint,
    $sendSharepointForm,
    $sendSharepointLink;

sendSharepoint = (function() {
    'use strict';

    function init() {

        // Set vars
        $sendSharepointForm = $('.js-send-sharepoint-form');
        $sendSharepointLink = $('.js-send-sharepoint-link');

        //listen for clicks on sharepoint link
        $sendSharepointLink.on('click', function(evt) {
            var $thisLink = $(evt.currentTarget);
            var thisSharepointId = $thisLink.data('sharepoint-id');

            evt.preventDefault();

            // Populate hidden field with the correct sharepoint target we want to send to
            $('.js-send-sharepoint-target').val(thisSharepointId);

            removeErrorMessages();
            enterLoadingState();
            dropdown.closeAllDropdowns();

            setTimeout(function () {
                $sendSharepointForm.ajaxSubmit({
                    success: formSubmissionSuccess,
                    error: formSubmissionError
                });
            }, 300);
        });
    }

    function formSubmissionSuccess() {
        exitLoadingState();
        notify.show();
    }

    function formSubmissionError(xhr, status, message) {
        exitLoadingState();
        $sendSharepointForm.append('<div class="msg-error msg--notify">Error: ' + xhr.status + ' ' + message + '</div>');
    }

    function removeErrorMessages() {
        $sendSharepointForm.find('.msg-error').remove();
    }

    function enterLoadingState() {
        $sendSharepointForm.addClass('is-loading');
    }

    function exitLoadingState() {
        $sendSharepointForm.removeClass('is-loading');
    }

    return {
        init:init,
        formSubmissionSuccess: formSubmissionSuccess,
        formSubmissionError: formSubmissionError
    };
}());
