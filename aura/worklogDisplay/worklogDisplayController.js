({
	clickMeToSeeNewWorklog : function(component, event, helper) {
        var timesheetWorklogs = component.get("v.timesheetWorklogs");
        console.log('This should display empty when clicked initially and worklog later');
        console.log(timesheetWorklogs);
	}
})