/* global popup, formErrors, shareCopy, brightModal */
var shareFacebook;

// -----------------------------------------------
//  This module takes care of the functionality
//  needed once the share by email form has been loaded
//  into the modal.
//  It is called by modals.js
// -----------------------------------------------

shareFacebook = (function() {
    'use strict';

    var $shareLink,
        $modal,
        $shareUrlField;

    function init($shareModal) {
        // init some DOM references
        $modal = $shareModal;
        $shareLink = $modal.find('.js-facebook-share');
        $shareUrlField = $modal.find('.js-sharing-url');

        $shareLink.on('click', function(e) {
            e.preventDefault();

            // Check if terms checkbox exists
            var $termsCheckbox = $modal.find('.js-terms-checkbox');
            if ($termsCheckbox.length > 0) {
                validateCheckbox($termsCheckbox);
            } else {
                launchFacebookPopup();
            }
        });

        $shareUrlField.on('click', function() {
            this.focus();
            this.select();
        });
    }

    function validateCheckbox($termsCheckbox) {
        if ($termsCheckbox.prop('checked')) {
            launchFacebookPopup();
        } else {
            var error = {
                'id': $termsCheckbox.attr('id'),
                'name': $termsCheckbox.attr('name'),
                'message': shareCopy.required
            };

            //checks for a form error existing
            if ($('.form-error').length === 0){
                formErrors.showFieldError(error, $modal);
            }
        }
    }

    function launchFacebookPopup() {
        popup.popupGeneric($shareLink[0]);
        brightModal.closeModal($modal);
    }

    return {
        init:init
    };

}());
