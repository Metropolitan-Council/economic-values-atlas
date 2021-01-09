'use strict';

/*
 ----------------------------------------------------------------------
 Linked selects module
 ----------------------------------------------------------------------
 */

/* global bulkUpdate, _ */
var linkedSelects;

linkedSelects = (function () {

    var linkedSelectsJSON,
        defaultConfig = {
            'isSearch': false
        },
        $selects,
        selectChangeRegistry = [],
        i;


    function init(json, config) {

        linkedSelectsJSON = json;

        // If there are conflicting js-linked-select in header rename them
        if($('.js-search-wrapper .js-linked-select')){
            $('.js-search-wrapper .js-linked-select').addClass('js-linked-header-select');
            $('.js-search-wrapper .js-linked-select').removeClass('js-linked-select');
            $selects = $('.js-linked-select');
        }
        else{
            $selects = $('.js-linked-select');
        }

        defaultConfig = $.extend(defaultConfig, config);

        checkForDefaultValues();

        listenForChangeEvent();

    }

    // array of selects that have had their values changed

    function addToSelectChangeRegistry($selectBox) {
        var id = $selectBox.attr('id');
        if (!_.contains(selectChangeRegistry, id)){
            selectChangeRegistry.push(id);
        }
    }

    function clearSelectChangeRegistry() {
        selectChangeRegistry = [];
    }

    // Loops through registry and triggers change event on each select.
    // Could be optimised by caching references to selects
    function triggerCustomChangeEvents(options){
        // stop listening to change events while we trigger specific custom change events
        stoplisteningForChangeEvent();

        for ( i = selectChangeRegistry.length - 1; i >= 0; i -= 1 ) {

            // only trigger if this is not the select the user has changed
            if(!_.contains(options.exclude, selectChangeRegistry[i])){
                $('#'+String(selectChangeRegistry[i])).trigger('change');
            }
        }
        // we can now listen for change events again
        listenForChangeEvent();
    }


    function listenForChangeEvent() {
        $selects.on('change', changeEventHandler);
    }

    function stoplisteningForChangeEvent() {
        $selects.off('change');
    }

    function changeEventHandler(event){

        var $selectBox = $(event.target);
        clearSelectChangeRegistry();
        selectBoxChanged($selectBox);
        triggerCustomChangeEvents({
            exclude: [$selectBox.attr('id')]
        });

    }

    function selectBoxChanged($selectBox) {
        var selectBoxId = $selectBox.attr('id'),
            selectedValue = $selectBox.find('option:selected').val(),
            selectedOptionId = $selectBox.find('option:selected').attr('id'),
            selectBoxObj = getMatchingSelectObject(selectBoxId),
            childSelectsList = selectBoxObj[0].childSelects,
            parentSelect = selectBoxObj[0].parentSelect;


        // has user picked 'please select'?
        if (selectedOptionId.indexOf('pleaseSelect') !== -1) {

            //reset child and descendant selects back to original state
            if (childSelectsList.length) {
                resetChildSelectBoxes(childSelectsList, $selectBox);
            }


        } else {

            var selectedValueObj = getMatchingOptionObject(selectBoxObj, selectedOptionId),
                correspondingParentValues = selectedValueObj[0].parentValues;

            // update any descendent selectboxes
            if (childSelectsList.length) {
                updateChildSelectBoxes(childSelectsList, selectedOptionId);
            }

            // Update the parent selectbox(es) if not on a search page (we don't want to automatically set parent values on search
            // page as it narrows down search results in a 'not very obvious to the user' way)
            if (!defaultConfig.isSearch) {

                // If this selectbox has a parent that exists on the page and only one corresponding parent value, set the parent
                // value and filter the available  values of this selectbox accordingly.
                var parentSelectObj = getMatchingSelectObject(parentSelect);

                if (typeof parentSelectObj[0] !== 'undefined' && correspondingParentValues.length === 1) {
                    updateParentSelectBox(parentSelect, correspondingParentValues[0]);
                    filterThisSelect(correspondingParentValues, selectBoxObj);
                    // reinstate selected value
                    if($selectBox.val() !== selectedValue){
                        $selectBox.val(selectedValue);
                        addToSelectChangeRegistry($selectBox);
                    }
                }
            }
        }
    }


    function checkForDefaultValues() {
        // build a collection for select boxes with a default value.
        var $selectsWithDefaultValues = $selects.filter(function() {
            var $thisSelect = $(this),
                thisSelectId = $thisSelect.find('option:selected').attr('id');

            if (thisSelectId.indexOf('pleaseSelect') === -1) {
                return true;
            } else {
                return false;
            }
        });

        // Use the last selectbox to update the related selects.
        if($selectsWithDefaultValues.length) {
            selectBoxChanged($selectsWithDefaultValues.last());
        }

    }

    function filterThisSelect(correspondingParentValues, selectBoxObj) {
        //filter this selectboxes values only if it's parent exists on the page
        // if (correspondingParentValues[0])
        var filteredValues = filterChildValuesByAllowableParentValues(correspondingParentValues, selectBoxObj[0].values);

        updateSelectBox(selectBoxObj[0].id, filteredValues);
    }


    function resetChildSelectBoxes(childSelectsList, $parentSelect) {
        _.each(childSelectsList, function(thisChild) {
            var childSelectObj = getMatchingSelectObject(thisChild);

            if (typeof childSelectObj[0] !== 'undefined') {
                var childSelectId = childSelectObj[0].id,
                    $thisSelect = $('#' + childSelectId),
                    $parentOptions = $parentSelect.find('option:gt(0)'),
                    parentValues = [];

                $parentOptions.each(function() {
                    //get numeric value from Id (as value attribute sometimes contains the label , e.g. on search page)
                    var thisOptionId = $(this).attr('id');
                    parentValues.push(getIdFromOptionId(thisOptionId));
                });

                //store selected Value incase we can reinstate it
                var selectedValue = $thisSelect.val();

                var filteredChildValues = filterChildValuesByAllowableParentValues(parentValues, childSelectObj[0].values);

                updateSelectBox(childSelectId, filteredChildValues);

                //Restore originally selected value
                if ($thisSelect.val() !== selectedValue){
                    $thisSelect.val(selectedValue);
                }


                // Does this have a child selectbox?
                if( childSelectObj[0].childSelects.length ) {
                    resetChildSelectBoxes(childSelectObj[0].childSelects, $thisSelect);
                }
            }

        });
    }


    function updateChildSelectBoxes(childSelectsList, parentValueId) {
        _.each(childSelectsList, function(thisChild) {

            var childSelectObj = getMatchingSelectObject(thisChild),
                $childSelect = $('#'+ thisChild);



            // If the child select box exists on the page then update its options.
            if (typeof childSelectObj[0] !== 'undefined' ) {
                //store selected Value incase we can reinstate it
                var selectedValue = $childSelect.val();


                //filter child values to ones that contain the parent value in their set of parentValues.
                var matchingValues = _.filter(childSelectObj[0].values, function(thisVal) {
                    return _.contains(thisVal.parentValues, getIdFromOptionId(parentValueId));
                });

                updateSelectBox(childSelectObj[0].id, matchingValues);

                //Restore originally selected value
                if ($childSelect.val() !== selectedValue){
                    $childSelect.val(selectedValue);
                    addToSelectChangeRegistry($childSelect);
                }

                // Does this have child selectboxes?
                if( childSelectObj[0].childSelects.length ) {
                    updateDescendantSelectBoxes(childSelectObj[0].childSelects, matchingValues);
                }

            }

        });
    }


    function updateDescendantSelectBoxes(descendantSelectsList, matchingValues) {

        // construct a list of matching values to test against
        var allowableParentValues = [];
        for (i = 0; i < matchingValues.length; i += 1) {
            allowableParentValues.push(getIdFromOptionId(matchingValues[i].optionId));
        }

        //iterate through descendants
        for (i = 0; i < descendantSelectsList.length; i += 1) {

            var descendantSelectObj = getMatchingSelectObject(descendantSelectsList[i]),
                $descendantSelect = $('#'+ descendantSelectsList[i]);

            if (typeof descendantSelectObj[0] !== 'undefined' ) {

                //store selected Value incase we can reinstate it
                var selectedValue = $descendantSelect.val();

                var matchingDescendantValues = filterChildValuesByAllowableParentValues(allowableParentValues, descendantSelectObj[0].values);

                updateSelectBox(descendantSelectObj[0].id, matchingDescendantValues);

                //Restore originally selected value
                if ($descendantSelect.val() !== selectedValue){
                    $descendantSelect.val(selectedValue);
                    addToSelectChangeRegistry($descendantSelect);
                }

                // Does this have child selectboxes?
                if( descendantSelectObj[0].childSelects.length ) {
                    updateDescendantSelectBoxes(descendantSelectObj[0].childSelects, matchingDescendantValues);
                }
            }

        }
    }


    function updateParentSelectBox(parentSelectId, parentValue) {

        var $thisSelect = $('#' + parentSelectId),
            thisSelectObj = getMatchingSelectObject(parentSelectId);


        // If the parent select box exists on the page then update its options.
        if (typeof thisSelectObj[0] !== 'undefined' ) {

            var selectedValueObj = getMatchingOptionObject(thisSelectObj, 'linkedOption'+parentValue);

            // update the selectbox in the page
            if ($thisSelect.val() !== selectedValueObj[0].value){
                $thisSelect.val(selectedValueObj[0].value);
                addToSelectChangeRegistry($thisSelect);
            }

            activateIfBulkUpdate($thisSelect);

            // Check if this selectbox has a parent
            if( thisSelectObj[0].parentSelect.length && selectedValueObj[0].parentValues.length === 1 ) {
                updateParentSelectBox(thisSelectObj[0].parentSelect, selectedValueObj[0].parentValues[0]);
            }
        }
    }



    function filterChildValuesByAllowableParentValues(allowableParentValues, allChildValues) {

        // We have an array of allowable parent values and a list of child values.
        // Each child value has an array of possible parent values.
        // A child value is ok if any of its corresponding parentValues is in the allowable parent values list.

        var filteredChildValues = _.filter(allChildValues, function(thisValue){

            var matchFound = false;
            _.each(thisValue.parentValues, function(thisParentValue) {
                if (!matchFound) {
                    matchFound = _.contains(allowableParentValues, thisParentValue);
                }
            });
            return matchFound;
        });

        return filteredChildValues;
    }


    function getMatchingSelectObject(selectBoxId) {
        return _.where(linkedSelectsJSON, {'id': selectBoxId});
    }

    function getMatchingOptionObject(selectBoxObj, optionId) {
        return _.where(selectBoxObj[0].values, {'optionId': optionId});
    }


    function updateSelectBox(selectId, matchingValues) {
        var optionsHtml = buildSelectOptionsHtml(matchingValues);
        // get a reference to the dom object
        var $select = $('#' + selectId);

        // remove all but the first option
        $select.find('option:gt(0)').remove();

        // replace with generated options
        $select.append($(optionsHtml));
    }


    function activateIfBulkUpdate($selectBox) {
        //Are we on bulk update? Do linked fields nead to be activated?
        if ($selectBox.parent('.containsField').length) {
            var $thisAttr = $selectBox.closest('tbody.fieldWrap');
            bulkUpdate.activateField($thisAttr);
        }
    }


    function buildSelectOptionsHtml(matchingValues) {
        var optionList = '',
            i = 0,
            elem,
            compiled;

        for ( i = 0; i < matchingValues.length; i += 1) {
            elem = matchingValues[i];
            compiled = _.template('<option value="<%= value %>" id="<%= optionId %>"><%= label %></option>');
            optionList = optionList + compiled(elem);
        }

        return optionList;

    }

    function getIdFromOptionId(parentValueId) {
        // chop off 'linkedOption' text to leave numeric id
        return parentValueId.slice(12);
    }

    return {
        init: init
    };

}());


