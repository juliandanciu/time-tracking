({
	clickSave : function(component, event, helper) {
		//save the worklog record the the database if it passes all requirments 
		console.log('you clicked save');
        var startTime = component.find("startTime").get("v.value");
        var endTime = component.find("endTime").get("v.value");
        var parentTimesheet = component.get("v.parentTimesheet");
        var timesheetId = parentTimesheet.Id;
        var projectName = component.find("projectName").get("v.value");
        var status = 'New';
        var description = component.find("description").get("v.value");
        
        var action = component.get("c.insertSingleWorklog");
        action.setParams({startTime : startTime,
                          endTime : endTime,
                          timesheetId : timesheetId,
                          projectName : projectName,
                          status : status,
                          description : description
                         });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var newWorklog = response.getReturnValue();
                //send the new worklog
                var event0 = component.getEvent("appendNewWorklog");
                event0.setParams({"newWorklog" : newWorklog});
                event0.fire();
                
                var toastEvent = $A.get("e.force:showToast");
        		var a = "The record has been created successfully.";
                toastEvent.setParams({
            		"title": "Success!",
        			"message": a,
                    "type":"success"});
        		toastEvent.fire();
                //close the modal
                var event = component.getEvent("renderWorklogCreation");
        		event.setParam("truthValue", false);
        		event.fire();
            } else {
                console.log("Failed with state: " + state);
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
        
        
	},
    
    clickCancel : function(component, event, helper){
        //close the modal
        var event = component.getEvent("renderWorklogCreation");
        event.setParam("truthValue", false);
        event.fire();
    }
    
       
})