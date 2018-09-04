({
    loadTasks : function(component) {
        action.setCallback(this, function(response) {  });
    },
    
    showState : function(state){
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
    }
})