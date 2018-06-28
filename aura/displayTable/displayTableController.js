({
	clickCreateNewWorklog : function(component, event, helper) {
		//open the modal
        //send an empty worklog 
        var event = component.getEvent("renderWorklogCreation");
        event.setParam("truthValue", true);
        event.fire();
	},
    
    clickSubmitTimesheet : function(component, event, helper) {
        console.log('Star Wars 1');
        var parentTimesheet = component.get("v.parentTimesheet");
        var action = component.get("c.submitTimesheet");
        action.setParams({timesheet : parentTimesheet});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var parentTimesheet = response.getReturnValue();
                var event = component.getEvent("timesheetInfo");
                event.setParams({"parentTimesheet" : parentTimesheet});
                event.fire();
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            		"title": "Success!",
        			"message": "The timesheet has been submitted successfully.",
                    "type":"success"});
        		toastEvent.fire();
            } else {
                console.log("Failed with state: " + state);
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    clickSelectAll : function(component, event, helper) {
        console.log('YOU HIT THE SELECT ALL');
        var isSelectAll = event.getSource().get("v.checked");
        var singleCheckboxes = component.find('selectSingle');
        
        var enabledWorklogs = [];
        for(var i = 0; i < singleCheckboxes.length; i++){
            var disabled = singleCheckboxes[i].get("v.disabled");
            if(disabled == false){
                var worklogId = singleCheckboxes[i].get("v.name");
                enabledWorklogs.push(worklogId);
            }
        }
        console.log('enabledWorklogs');
        console.log(enabledWorklogs);
        
        console.log('what does the component find?')
        
        if (singleCheckboxes.get) {
            singleCheckboxes = [singleCheckboxes];
        }
        console.log(singleCheckboxes);
        console.log('what does the component find?')
        
        //Map<id, string> newMap = new Map<id, string>([SELECT...])
        
        if(isSelectAll == true){
            for(var i = 0; i < singleCheckboxes.length; i++){
                var disabled = singleCheckboxes[i].get("v.disabled");
                
                if(disabled == false){
                    singleCheckboxes[i].set("v.checked", true);
                }
                
            }
        } else {
            for(var i = 0; i < singleCheckboxes.length; i++){
                var disabled = singleCheckboxes[i].get("v.disabled");
                
                if(disabled == false){
                    singleCheckboxes[i].set("v.checked", false);
                }
                
            }
            
        }
        
        var event = component.getEvent("selectAllWorklogs");
        event.setParams({"enabledWorklogs" : enabledWorklogs});
        event.fire();
    },
    
    clickSelect : function(component, event, helper) {
        console.log('You hit Select Single!');
        var isEventCheckbox = event.getSource().get("v.checked");
		var selectAllCheckbox = component.find("selectAll");
        var singleCheckboxes = component.find('selectSingle');
        
        var areAllSinglesChecked = false;
        if (singleCheckboxes.get) {
            singleCheckboxes = [singleCheckboxes];
        }
        
        var length = 0;
        for(var i = 0; i < singleCheckboxes.length; i++){
            var disabled = singleCheckboxes[i].get("v.disabled");
            if(disabled == false){
                length++;
            }
        }
        console.log('length');
        console.log(length);
        
        var counter = 0;
        for(var i = 0; i < singleCheckboxes.length; i++){
            var isChecked = singleCheckboxes[i].get("v.checked");
            if(isChecked == true){
                counter++; 
            } 
        }
        if(counter == length){
            areAllSinglesChecked = true;
        }
        
        console.log('areAllSinglesChecked');
        console.log(areAllSinglesChecked);
        var isSelectAll = selectAllCheckbox.get("v.checked");
        if(isEventCheckbox == false && isSelectAll == true){
            selectAllCheckbox.set("v.checked", false);
        } else if (areAllSinglesChecked == true && isSelectAll == false){
            selectAllCheckbox.set("v.checked", true);
        }
		        
        
        
        var worklogId = event.getSource().get("v.name");
        var event = component.getEvent("selectWorklog");
        event.setParams({"worklogId" : worklogId});
        event.fire();
    },
    
    clickDeleteSelectedWorklogs : function(component, event, helper) {
        var selectedWorklogs = component.get("v.selectedWorklogs");
        
        var action = component.get("c.deleteSelectedWorklogs");
        action.setParams({"selectedWorklogs" : selectedWorklogs});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var deletedWorklogs = response.getReturnValue();
                var event = component.getEvent("deleteUpdate");
                event.setParams({"deletedWorklogs" : deletedWorklogs});
                event.fire();
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            		"title": "Success!",
        			"message": "The record has been deleted successfully.",
                    "type":"success"});
        		toastEvent.fire();
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
    
    clickEdit : function(component, event, helper) {
        var editWorklog = event.getSource().get("v.value");
        console.log(editWorklog);
        
        
        
        var event0 = component.getEvent("sendEditWorklog");
        event0.setParams({"editWorklog" : editWorklog});
        event0.fire();

    },
    
    delete0 : function(component, event, helper) {
        component.set("v.renderAreYouSure", true);
    },
    
    handleRenderAreYouSureEvent : function(component, event, helper) {
        var truthValue = event.getParam("truthValue");
        component.set("v.renderAreYouSure", truthValue);
    }
})