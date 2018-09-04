({
    loadAccounts : function(cmp) {       
        var action = cmp.get("c.getAccount");        
        
        /*action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                cmp.set("v.account", response.getReturnValue());               
            }
            
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your Accounts have been loaded successfully."
                });
            }
            else {
                toastEvent.setParams({
                    "title": "Error!",
                    "message": " Something has gone wrong."
                });
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);*/
        action.setCallback(this, function(response) { alert(666); });
    }
})