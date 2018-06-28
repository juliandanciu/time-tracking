({
	queryForTimesheet : function(component, event, helper) {
        
		var datePicker = component.find("startDate");
        var dateValue = datePicker.get("v.value");
     	
        var action = component.get("c.queryTimesheet");
        action.setParams({dateValue : dateValue});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var parentTimesheet = response.getReturnValue();
                
                var event = component.getEvent("timesheetInfo");
                event.setParams({"parentTimesheet" : parentTimesheet});
                event.fire();
            } else {
                console.log("Failed with state: " + state);
                console.log(response.getError());
                var pryOpen = response.getError();
                console.log('pryOpen');
                console.log(pryOpen);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
            		"title": "Failed!",
        			"message": pryOpen[0].pageErrors[0].message,
                    "type":"error"});
        		toastEvent.fire();
            }
        });

        
        $A.enqueueAction(action);
	}
})