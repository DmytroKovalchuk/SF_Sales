({
	/*showTasks : function(cmp) {
        alert(555);
		var action = cmp.get("c.getAccountTask");
        action.setParams({
            accountId : cmp.get("v.account.Id")
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.callTaskComponent(response.getReturnValue());                              
            }
            
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your AccountTasks have been loaded successfully."
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
          $A.enqueueAction(action);
	},*/
    
    callTaskComponent : function(comp){
        var evt = $A.get("e.force:navigateToComponent");
        console.log('evt'+evt);       
        var accId = comp.get("v.account.Id");
        //alert(accId);
        evt.setParams({
            componentDef: "c:COVA_TaskEdit",
            accountId : accId
        });
       
        evt.fire();        
    }/*,
    
   showRecordDetails : function(cmp){
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({ "recordId": cmp.get("v.account.Id") })        
        sObjectEvent.fire();	
    }*/
})