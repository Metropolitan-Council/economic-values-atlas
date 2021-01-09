var buttonStates;

// -----------------------------------------------
//  Module to tell a button to listen for custom
//  events being triggered on them and assume the
//  appropriate state
// -----------------------------------------------

buttonStates = (function() {
    'use strict';

    var defaultLoadingText = 'Loading...';

    function init() {
        var $buttonsWithState = $('.js-button-states');
        $buttonsWithState.on('state.loading', handleLoadingState);
        $buttonsWithState.on('state.normal', handleNormalState);
    }

    function handleLoadingState(event) {
        var $thisElem = $(event.target);

        disableElement($thisElem);
        showLoadingText($thisElem);
    }

    function handleNormalState(event) {
        var $thisElem = $(event.target);

        enableElement($thisElem);
        showNormalText($thisElem);
    }


    function triggerLoadingState($button) {
        disableElement($button);
        showLoadingText($button);
    }

    function disableElement($elem) {
        $elem.attr('disabled', 'disabled').addClass('is-loading');
    }

    function enableElement($elem) {
        $elem.removeAttr('disabled').removeClass('is-loading');
    }

    function showLoadingText($elem) {
        var currentText = $elem.is('input') ? $elem.val() : $elem.text(),
            loadingText = $elem.data('loading-text') || defaultLoadingText;

        // store the current button text
        $elem.data('normal-text', currentText);

        updateButtonText($elem, loadingText);
    }

    function showNormalText($elem) {
        var normalText = $elem.data('normal-text');
        updateButtonText($elem, normalText);
    }

    function updateButtonText($button, newText) {
        if ($button.is('input')) {
            $button.val(newText);
        } else {
            var $elemtoUpdate = $button.find('.button__text').length ? $button.find('.button__text') : $button;
            $elemtoUpdate.text(newText);
        }
    }

    return {
        init:init,
        triggerLoadingState: triggerLoadingState
    };

}());
