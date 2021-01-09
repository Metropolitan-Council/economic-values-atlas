/* global buttonStates, FormValidator, formErrors, notify, shareCopy, brightModal */
var shareEmail;

// -----------------------------------------------
//  This module takes care of the functionality
//  needed once the share by email form has been loaded
//  into the modal.
//  It is called by modals.js
// -----------------------------------------------

shareEmail = (function() {
    'use strict';

    var $submitButton,
        $modal,
        $form,
        validator;

    function init($shareModal) {
        // init some DOM references
        $modal = $shareModal;
        $submitButton = $modal.find('.js-share-email-submit');
        $form = $modal.find('#shareForm');

        initFormValidator();

        buttonStates.init();
    }

    function initFormValidator() {
        // JS is available so we will handle the validation
        $form.attr('novalidate', 'novalidate');

        // form validator handles submit event for us
        validator = new FormValidator($form.attr('name'), getValidationSettings(), validationComplete);

        // Pass in some dynamic copy for validation messages
        validator.setMessage('required', shareCopy.required);
        validator.setMessage('valid_emails', shareCopy.valid_emails);
    }

    function getValidationSettings() {
        var settings = [];

        if ($form.find('[name="emailAddressesDelimited"]').length) {
            settings = [{
                name: 'emailAddressesDelimited',
                display: 'email address',
                rules: 'required|valid_emails'
            }];
        }

        // dynamically add settings for terms and conditions checkboxes (as there may be more than one)
        settings = settings.concat(getTermsCheckboxesValidationSettings());

        return settings;
    }

    function getTermsCheckboxesValidationSettings() {
        // dynamically get the name attribute of all terms and conditions checkboxes in modal
        var $termsCheckboxes = $modal.find('.js-terms-checkboxes input[type="checkbox"]'),
            settingsArray = [];

        $termsCheckboxes.each(function() {
            settingsArray.push({
                name: $(this).attr('name'),
                rules: 'required'
            });
        });

        return settingsArray;
    }

    function validationComplete(errors, event) {
        // Prevent the form submission no matter what as we are handling it with ajax
        event = event || window.event;
        if (event.preventDefault) {
            event.preventDefault();
        } else {
            event.returnValue = false;      // for the benefit of IE8
        }

        if (errors.length > 0) {
            formErrors.showErrors(errors, $form);
        } else {
            submitForm();
        }
    }

    function submitForm() {
        enterLoadingState();

        $form.ajaxSubmit({
            success: formSubmissionSuccess,
            error: formSubmissionError
        });
    }

    function formSubmissionSuccess() {
        brightModal.closeModal($modal);
        notify.show();
    }

    function formSubmissionError(xhr, status, message) {
        $modal.find('.modal-body').html('<div class="msg-error">Error: ' + xhr.status + ' ' + message + '</div>');
        $modal.find('.modal-footer').remove();
    }

    function enterLoadingState() {
        $submitButton.trigger('state.loading');
    }

    return {
        init:init,
        enterLoadingState: enterLoadingState,
        validationComplete: validationComplete,
        getValidationSettings: getValidationSettings,
        getTermsCheckboxesValidationSettings: getTermsCheckboxesValidationSettings,
        formSubmissionSuccess: formSubmissionSuccess,
        formSubmissionError: formSubmissionError
    };

}());
