/* global shareEmail, shareURL, shareFacebook, featuredAsset, brightModal */

/*
--------------------------------------------------------------------
    Utility Modal
    - Handles the share, facebook and featured Asset modal
    - Does not handle the bulk share or toolbar modal
--------------------------------------------------------------------
*/

var utilityModal;

utilityModal = (function () {
    'use strict';

    var $utilityModal,
        assetIsAVideo;

    function init() {
        var $modalTrigger = $('.js-utility-modal-trigger');
        $utilityModal = $('#utilityModal');
        assetIsAVideo = $('.js-video-asset').length;

        $modalTrigger.click(function (e) {
            e.preventDefault();
            openModal($(this).attr('href'), $(this).data('modal-type'), $(this));
        });
    }

    function openModal(contentUrl, modalType, modalTrigger) {
        // If it is a video, there's no need to open a modal
        if (modalType === 'feature' && assetIsAVideo) {
            featuredAsset.submitFeatureVideoAsset();
            modalTrigger.hide();
        }
        else {
            brightModal.openModal(contentUrl, '#utilityModal', modalTrigger, function() {
                initOtherModules(modalType);
            });
        }
    }

    function initOtherModules(modalType) {
        // Initialise relevant JS modules
        // Also resizes modal accordingly
        switch (modalType) {
        case 'email':
            $utilityModal.removeClass('modal--featured-asset');
            $utilityModal.addClass('modal--small');
            shareEmail.init($utilityModal);
            break;
        case 'share-url':
            $utilityModal.removeClass('modal--featured-asset');
            $utilityModal.addClass('modal--small');
            shareURL.init($utilityModal);
            break;
        case 'facebook':
            $utilityModal.removeClass('modal--featured-asset');
            $utilityModal.addClass('modal--small');
            shareFacebook.init($utilityModal);
            break;
        case 'feature':
            $utilityModal.removeClass('modal--small');
            $utilityModal.addClass('modal--featured-asset');
            featuredAsset.init(true);
            break;
        default:
            break;
        }
    }

    return {
        init: init,
        initOtherModules: initOtherModules
    };

}());

