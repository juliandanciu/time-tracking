({
	clickSave : function(component, event, helper) {
		//save the worklog record the the database if it passes all requirments 
		
        var startTime = component.find("startTime").get("v.value");
        var endTime = component.find("endTime").get("v.value");
        var projectName = component.find("projectName").get("v.value");
        var description = component.find("description").get("v.value");
        
        var editWorklog = event.getSource().get("v.value");
        console.log(editWorklog);
        
        var action = component.get("c.updateSingleWorklog");
        action.setParams({editWorklog: editWorklog,
                          startTime : startTime,
                          endTime : endTime,
                          projectName : projectName,
                          description : description
                         });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var editedWorklog = response.getReturnValue();
                //send the new worklog
                var event0 = component.getEvent("updateEditedWorklog");
                event0.setParams({"editedWorklog" : editedWorklog});
                event0.fire();
                //toast 
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            		"title": "Success!",
        			"message": "The record has been updated successfully.",
                    "type":"success"});
        		toastEvent.fire();
                
                //close the modal
                var event = component.getEvent("renderWorklogEdit");
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
        var event = component.getEvent("renderWorklogEdit");
        event.setParam("truthValue", false);
        event.fire();
    }
    
       
})