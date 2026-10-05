/**
 * Oracle APEX JavaScript Utilities
 * Purpose: Custom functions for Dynamic Actions and Interactive Grids
 */

var apexUtils = apexUtils || {};

// 1. Show custom APEX success alert with auto-dismiss
apexUtils.showNotification = function(pMessage) {
    apex.message.showPageSuccess(pMessage);
    setTimeout(function() {
        apex.message.hidePageSuccess();
    }, 4000);
};

// 2. Validate client-side inputs before Submit Dynamic Action
apexUtils.validateForm = function(pItemSelector) {
    var isValid = true;
    $(pItemSelector).each(function() {
        if (!$(this).val()) {
            apex.message.showErrors([
                {
                    type:       "error",
                    location:   "page",
                    message:    "Please complete all required fields.",
                    unsafe:     false
                }
            ]);
            isValid = false;
            return false; // Break loop
        }
    });
    return isValid;
};

// 3. Confirm action before executing Interactive Grid process
apexUtils.confirmAction = function(pMessage, pCallback) {
    apex.message.confirm(pMessage, function(okPressed) {
        if (okPressed) {
            pCallback();
        }
    });
};
