var formErrors;

formErrors = (function() {
    'use strict';

    //  showErrors expects an array of error objects
    //  and a reference to the form in question.
    //  Errors array should be a list of error objects with the properties:
    //  - id: The id attribute of the form element
    //  - name: The name attribute of the form element
    //  - message: The error message to display
    // -----------------------------------------------
    function showErrors(errors, $form) {
        //reset form to error free state
        removeErrors($form);

        // iterate through each error and show the error message alongside the appropriate field
        for (var i = 0, errorLength = errors.length; i < errorLength; i += 1) {
            showFieldError(errors[i], $form);
        }
    }

    function showFieldError(error, $form) {
        var thisError = error,
            $thisField,
            messageHtml = getMessageHtml(thisError.message);
        $thisField = thisError.id ? $form.find('#' + thisError.id) : $form.find('[name="' + thisError.name + '"]');

        if ($thisField.is('[type="checkbox"]')) {
            // if it is a checkbox it should be wrapped in a label, insert
            // the message after that
            $thisField.parent('label').after(messageHtml);
        } else {
            // else insert it straight after the field.
            $thisField.after(messageHtml);
        }
    }

    function removeErrors($form) {
        $form.find('.form-error').remove();
    }

    function getMessageHtml(message) {
        return $('<div class="form-error"><div class="form-error__message">' + message + '</div></div>');
    }

    return {
        showErrors: showErrors,
        showFieldError: showFieldError
    };

}());
