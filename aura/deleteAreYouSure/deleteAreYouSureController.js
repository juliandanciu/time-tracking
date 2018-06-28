({
	clickCancel : function(component, event, helper) {
		var event = component.getEvent("renderAreYouSure");
        event.setParam("truthValue", false);
        event.fire();
        
	},
    
    clickDelete : function(component, event, helper){
        var event0 = component.getEvent("proceedToDelete");
        event0.fire();
        
        var event = component.getEvent("renderAreYouSure");
        event.setParam("truthValue", false);
        event.fire();
    }
})