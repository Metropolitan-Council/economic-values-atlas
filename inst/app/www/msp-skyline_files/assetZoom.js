/*
 ----------------------------------------------------------------------
 Asset Zoom
 Zoom in on an image on the asset detail page
 ----------------------------------------------------------------------
 */

var assetZoom;

assetZoom = (function () {
    'use strict';

    var assetId,
        prevLink,
        nextLink,
        $zoomImg,
        $zoomTrigger,
        largeImageUrl,
        fallbackImageUrl;

    function init(zoomShouldBeOpenInitially, prev, next, aId, fallbackUrl) {
        assetId = aId;
        prevLink = prev;
        nextLink = next;
        fallbackImageUrl = fallbackUrl;

        initDomReferences();
        initZoomEventHandlers();
        initZoomViewer();

        if (zoomShouldBeOpenInitially) {
            openZoomViewer();
        }
    }

    function initZoomEventHandlers(){
        $zoomTrigger.on('click', function() {
            openZoomViewer();
        });
    }

    function initDomReferences(){
        $zoomTrigger = $('.js-asset-modal-trigger');
        $zoomTrigger.addClass('is-ready');
        $zoomImg = $zoomTrigger.find('img');
    }

    function initZoomViewer() {
        $zoomImg.viewer({
            toolbar: getToolbarOptions(),
            navbar: false
        });
        $zoomImg.on('viewed', getLargeImageURL);
    }

    function openZoomViewer() {
        $zoomImg.viewer('show');
    }

    function getLargeImageURL(event) {
        if (!largeImageUrl) {
            var params = 'assetId=' + assetId + '&imageMaxDimension=4000&imageFormat=webp';
            setViewerImageOnError(event.detail.image);
            $.get('../go/file-transformations?' + params)
            .done(function(response) {
                setViewerImageSrc(event.detail.image, response.url);
                largeImageUrl = response.url;
            });
        } else {
            setViewerImageSrc(event.detail.image, largeImageUrl);
        }
    }

    function setViewerImageSrc(image, imageUrl) {
        image.src = imageUrl;
    }

    function setViewerImageOnError(image) {
        image.onerror = function() {
            image.src = fallbackImageUrl;
            largeImageUrl = fallbackImageUrl;
        };
    }

    function getToolbarOptions() {
        var defaultButtonOptions = {show: 6, size: 'large'};
        var toolbarOptions = {
            prev: false,
            zoomIn: defaultButtonOptions,
            zoomOut: defaultButtonOptions,
            oneToOne: defaultButtonOptions,
            reset: defaultButtonOptions,
            rotateLeft: defaultButtonOptions,
            rotateRight: defaultButtonOptions,
            next: false
        };

        if (prevLink) {
            toolbarOptions.prev = {
                click: function () {
                    window.location.href = prevLink;
                },
                size: 'large',
                show: true
            };
        }

        if (nextLink) {
            toolbarOptions.next = {
                click: function () {
                    window.location.href = nextLink;
                },
                size: 'large',
                show: true
            };
        }

        return toolbarOptions;
    }

    return {
        init: init
    };

}());
