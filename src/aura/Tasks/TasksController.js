({
	initMethod : function(component, event, helper) {
        alert(component.get("v.recordId"));
        helper.loadTasks(component);		
	}
})