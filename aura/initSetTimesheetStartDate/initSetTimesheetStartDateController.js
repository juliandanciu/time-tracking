({
	queryForTimesheet : function(component, event, helper) {
        
		var datePicker = component.find("startDate");
        var dateValue = datePicker.get("v.value");
        console.log(typeof dateValue);
        var action = component.get("c.queryTimesheet");
        action.setParams({dateValue : dateValue});
        //Add callback behavior for when response is received 
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.returnedTimesheet", response.getReturnValue());
                component.set("v.timesheetWorklogs", response.getReturnValue().Worklogs__r);
                var updateEvent = component.getEvent('timesheetinfo');
                var responseReturn = component.get("v.returnedTimesheet").Id;
                updateEvent.setParams({"timesheet": responseReturn});
        		updateEvent.fire();
            } else {
                console.log("Failed with state: " + state);
            }
        });
//        console.log(action);
        
        $A.enqueueAction(action);
	},
    
    handleClickSubmitTimesheet : function(component, event, helper){
        //this is where you call the apex aura enabled class to submit the timesheet
        
        var timesheet = component.get("v.returnedTimesheet");
        var action = component.get("c.submitTimesheet");
        action.setParams({timesheet : timesheet});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.returnedTimesheet", response.getReturnValue());
                //var updateEvent = component.getEvent('timesheetinfo');
                //var responseReturn = component.get("v.returnedTimesheet").Id;
                //updateEvent.setParams({"timesheet": responseReturn});
        		//updateEvent.fire();
        		//requery???????
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    handleSendNewWorklogEvent : function(component, event, helper){
        console.log('Is the application event being handled?');
        var newWorklog = event.getParam('newWorklog');
        console.log(newWorklog);
        var timesheetWorklogs = component.get("v.timesheetWorklogs");
        var newTimesheetWorklogs = timesheetWorklogs.unshift(newWorklog);
        component.set("v.timesheetWorklogs", newTimesheetWorklogs);
    }
    
    
    
})