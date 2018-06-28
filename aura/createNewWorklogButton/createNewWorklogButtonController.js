({
	clickCreateNewWorklog : function(component, event, helper) {
        var updateEvent = component.getEvent('render');
        updateEvent.setParam("truthValue", true);
        updateEvent.fire();
	}
})