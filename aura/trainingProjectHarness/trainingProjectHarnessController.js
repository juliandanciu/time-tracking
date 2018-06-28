({
	handleTimesheetInfo : function(component, event, helper) {
		var parentTimesheet = event.getParam("parentTimesheet");
        var childWorklogs = parentTimesheet.Worklogs__r;
        component.set("v.parentTimesheet", parentTimesheet);
        component.set("v.childWorklogs", childWorklogs);
        
        
        
        
        if (childWorklogs){
            var index = 0; 
        	var totalMinute = 0; 
        	for(index = 0; index < childWorklogs.length; ++index){
            	var durMillisecond = Date.parse(childWorklogs[index].End_Time__c) - Date.parse(childWorklogs[index].Start_Time__c);
            	var durSecond = (durMillisecond / 1000);
            	var durMinute = (durSecond / 60);
            	totalMinute = totalMinute + durMinute;
        	}
        
        	if(totalMinute == 0){
            	component.set("v.percentage", 0);
        	} else {
            	var percentage = (totalMinute / 2400) * 100; 
        		component.set("v.percentage", percentage);
        	}
        } else{
            component.set("v.percentage", 0);
        }
        
        
        
	},
    
    handleRenderWorklogCreation : function(component, event, helper) {
        var truthValue = event.getParam("truthValue");
        component.set("v.renderWorklogCreation", truthValue);
    },
    
    handleAppendNewWorklogEvent : function(component, event, helper) {
        //get the current array 
        var childWorklogs = component.get("v.childWorklogs");
        var newWorklog = event.getParam("newWorklog");
        
        
            
        
        childWorklogs.unshift(newWorklog);
        component.set("v.childWorklogs", childWorklogs);
        
        
        
        
        
        if (childWorklogs != undefined){
            var index = 0; 
        	var totalMinute = 0; 
        	for(index = 0; index < childWorklogs.length; ++index){
            	var durMillisecond = Date.parse(childWorklogs[index].End_Time__c) - Date.parse(childWorklogs[index].Start_Time__c);
            	var durSecond = (durMillisecond / 1000);
            	var durMinute = (durSecond / 60);
            	totalMinute = totalMinute + durMinute;
        	}
        
        	if(totalMinute == 0){
            	component.set("v.percentage", 0);
        	} else {
            	var percentage = (totalMinute / 2400) * 100; 
        		component.set("v.percentage", percentage);
        	}
        } else{
            component.set("v.percentage", 0);
        }
        
        //update the timesheet status in the user interface. 
        var childWorklogs0 = component.get("v.childWorklogs");
        var parentTimesheet0 = component.get("v.parentTimesheet");
        
        console.log('size');
        console.log(childWorklogs0.length);
        var newWL = 0;
        var subWL = 0;
        var rejWL = 0;
        var appWL = 0;
        for(var i = 0; i < childWorklogs0.length; i++){
            if(childWorklogs0[i].Status__c == 'Rejected'){
                rejWL++;
            } else if (childWorklogs0[i].Status__c == 'Approved'){
                appWL++;
            } else if (childWorklogs0[i].Status__c == 'New'){
                newWL++;
            } else if (childWorklogs0[i].Status__c == 'Submitted'){
                subWL++;
            }
        }
        console.log(newWL);
        console.log(subWL);
        console.log(rejWL);
        console.log(appWL);
        if(appWL == childWorklogs0.length){
                parentTimesheet0.Status__c = 'Approved';
            	component.set("v.parentTimesheet", parentTimesheet0);
            } else if (rejWL > 0){
                parentTimesheet0.Status__c = 'Needs Attention';
                component.set("v.parentTimesheet", parentTimesheet0);
            } else if (appWL > 0){
                parentTimesheet0.Status__c = 'Under Review';
                component.set("v.parentTimesheet", parentTimesheet0);
            } else if (subWL == childWorklogs0.length){
                parentTimesheet0.Status__c = 'Submitted';
                component.set("v.parentTimesheet", parentTimesheet0);
            }
        
    },
    
    handleSelectWorklogEvent : function(component, event, helper) {
        var selectedWorklogs = component.get("v.selectedWorklogs");
        var worklogId = event.getParam("worklogId");
        
        var removeIndex = -1;
        
        
        for(var i = 0; i < selectedWorklogs.length; i++){
            if(selectedWorklogs[i] == worklogId){
                removeIndex = i;
            }  
        }
        
        if(removeIndex == -1){
            selectedWorklogs.push(worklogId);
            component.set("v.selectedWorklogs", selectedWorklogs);
            
        } else{
            selectedWorklogs.splice(removeIndex, 1);
            component.set("v.selectedWorklogs", selectedWorklogs);
        }
        
		console.log(selectedWorklogs);
        
    },
    
    handleSelectAllWorklogsEvent : function(component, event, helper) {
        var selectedWorklogs = component.get("v.selectedWorklogs");
        var childWorklogs = component.get("v.childWorklogs");
        var enabledWorklogs = event.getParam("enabledWorklogs");
        
        
        
        
        /*if(selectedWorklogs.length < childWorklogs.length){
            var childWorklogsIds = [];
            for(var i = 0; i < childWorklogs.length; i++){
                childWorklogsIds.push(childWorklogs[i].Id);
            } 
            selectedWorklogs = childWorklogsIds;
            component.set("v.selectedWorklogs", selectedWorklogs);
        } else {
            selectedWorklogs = [];
            component.set("v.selectedWorklogs", selectedWorklogs);
        }
        //you might need to fix this is there are no child worklogs */
        
        if(selectedWorklogs.length < enabledWorklogs.length){
            var childWorklogsIds = [];
            for(var i = 0; i < enabledWorklogs.length; i++){
                childWorklogsIds.push(enabledWorklogs[i]);
            } 
            selectedWorklogs = childWorklogsIds;
            component.set("v.selectedWorklogs", selectedWorklogs);
        } else {
            selectedWorklogs = [];
            component.set("v.selectedWorklogs", selectedWorklogs);
        }
        //you might need to fix this is there are no child worklogs 
        
        
        console.log('handler');
        console.log(selectedWorklogs);
        console.log('handler');
    },
    
    handleDeleteUpdateEvent : function(component, event, helper) {
        console.log('HandleDeleteUpdateEvent');
        var deletedWorklogs = event.getParam("deletedWorklogs");
        
        
        var childWorklogs = component.get("v.childWorklogs");
        

        for(var i = 0; i < deletedWorklogs.length; i++){
            let removeIndex; 
            
            for(var j = 0; j < childWorklogs.length; j++){
                if(deletedWorklogs[i].Id == childWorklogs[j].Id){
                    removeIndex = j;
                    break;
                }
            }
            
            console.log(removeIndex);
            var deleted = childWorklogs.splice(removeIndex, 1);
            console.log(deleted);
        }
        
        component.set("v.childWorklogs" , childWorklogs);
        
        if (childWorklogs != undefined){
            var index = 0; 
        	var totalMinute = 0; 
        	for(index = 0; index < childWorklogs.length; ++index){
            	var durMillisecond = Date.parse(childWorklogs[index].End_Time__c) - Date.parse(childWorklogs[index].Start_Time__c);
            	var durSecond = (durMillisecond / 1000);
            	var durMinute = (durSecond / 60);
            	totalMinute = totalMinute + durMinute;
        	}
        
        	if(totalMinute == 0){
            	component.set("v.percentage", 0);
        	} else {
            	var percentage = (totalMinute / 2400) * 100; 
        		component.set("v.percentage", percentage);
        	}
        } else{
            component.set("v.percentage", 0);
        }
        
        //clear selected id's 
        var selectedWorklogs = component.get("v.selectedWorklogs");
        selectedWorklogs = [];
        component.set("v.selectedWorklogs", selectedWorklogs);
        
        //update the timesheet status in the user interface. 
        var childWorklogs0 = component.get("v.childWorklogs");
        var parentTimesheet0 = component.get("v.parentTimesheet");
        
        console.log('size');
        console.log(childWorklogs0.length);
        var newWL = 0;
        var subWL = 0;
        var rejWL = 0;
        var appWL = 0;
        for(var i = 0; i < childWorklogs0.length; i++){
            if(childWorklogs0[i].Status__c == 'Rejected'){
                rejWL++;
            } else if (childWorklogs0[i].Status__c == 'Approved'){
                appWL++;
            } else if (childWorklogs0[i].Status__c == 'New'){
                newWL++;
            } else if (childWorklogs0[i].Status__c == 'Submitted'){
                subWL++;
            }
        }
        console.log(newWL);
        console.log(subWL);
        console.log(rejWL);
        console.log(appWL);
        if(appWL == childWorklogs0.length){
                parentTimesheet0.Status__c = 'Approved';
            	component.set("v.parentTimesheet", parentTimesheet0);
            } else if (rejWL > 0){
                parentTimesheet0.Status__c = 'Needs Attention';
                component.set("v.parentTimesheet", parentTimesheet0);
            } else if (appWL > 0){
                parentTimesheet0.Status__c = 'Under Review';
                component.set("v.parentTimesheet", parentTimesheet0);
            } else if (subWL == childWorklogs0.length){
                parentTimesheet0.Status__c = 'Submitted';
                component.set("v.parentTimesheet", parentTimesheet0);
            }
        
        
    },
    
    handleSendEditWorklogEvent : function(component, event, helper) {
        console.log('Does this event go??');
        //set the editWorklog attribute 
        var editWorklog = event.getParam("editWorklog");
        component.set("v.editWorklog", editWorklog);
        component.set("v.renderWorklogEdit", true);
        
    },
    
    handleRenderWorklogEditEvent : function(component, event, helper) {
        var truthValue = event.getParam("truthValue");
        component.set("v.renderWorklogEdit", truthValue);
    },
    
    handleUpdateEditedWorklog : function(component, event, helper) {
        var childWorklogs = component.get("v.childWorklogs");
        var editedWorklog = event.getParam("editedWorklog");
        
        var changeIndex;
        for(var i = 0; i < childWorklogs.length; i++){
            if(childWorklogs[i].Id == editedWorklog.Id){
                //replace one thing in the array with the other
                changeIndex = i;
                break;
            }
        }
        
        childWorklogs[changeIndex] = editedWorklog;
        
        component.set("v.childWorklogs", childWorklogs);
        
        if (childWorklogs != undefined){
            var index = 0; 
        	var totalMinute = 0; 
        	for(index = 0; index < childWorklogs.length; ++index){
            	var durMillisecond = Date.parse(childWorklogs[index].End_Time__c) - Date.parse(childWorklogs[index].Start_Time__c);
            	var durSecond = (durMillisecond / 1000);
            	var durMinute = (durSecond / 60);
            	totalMinute = totalMinute + durMinute;
        	}
        
        	if(totalMinute == 0){
            	component.set("v.percentage", 0);
        	} else {
            	var percentage = (totalMinute / 2400) * 100; 
        		component.set("v.percentage", percentage);
        	}
        } else{
            component.set("v.percentage", 0);
        }
    }
    
    
})