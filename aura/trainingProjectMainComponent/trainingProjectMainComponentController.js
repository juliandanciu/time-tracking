({
	handleRenderWorklogCreationModal : function(component, event, helper) {
        var renderWorklogCreationModal = event.getParam('truthValue');
        console.log(renderWorklogCreationModal);
        component.set("v.renderWorklogCreationModal", renderWorklogCreationModal);
        
	},
    
    handleTimesheetInfo : function(component, event, helper){
        let timesheet = event.getParam('timesheet');
        component.set("v.returnedtimesheet", timesheet);
        
        
    },
    handleSendNewWorklogEvent : function(component, event, helper){
        var newWorklog = event.getParam('newWorklog');
        component.set("v.newWorklog", newWorklog);
    }
})