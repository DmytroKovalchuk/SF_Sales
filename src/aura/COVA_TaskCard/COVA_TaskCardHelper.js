({
	goToRecordDetails : function() {
		var sObjectEvent = $A.get("e.force:navigateToSObject");
        sObjectEvent.setParams({ "taskId": cmp.get("v.taskId.Id") })        
        sObjectEvent.fire();	
	}
})