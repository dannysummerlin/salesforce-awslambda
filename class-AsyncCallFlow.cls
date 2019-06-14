global class AsyncCallFlow {
	@InvocableMethod(label='Call Async Flow' description='Call a Flow with variables asynchronously.')
	global static void callFlow(List<String> flowJSON) {
		String flowDetails = flowJSON[0];
		Map<String, Object> details = (Map<String, Object>) JSON.deserializeUntyped(flowDetails);
		String flowName = (String) details.get('flow');
		String jsonVariables = JSON.serialize(details.get('variables'));
		asyncFlow(flowName, jsonVariables);
	}
	@future(callout = true)
	global static void asyncFlow(String flowName, String jsonVariables) {
		Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(jsonVariables);
		Flow.Interview flowCall = Flow.Interview.createInterview(flowName, inputs);
		flowCall.start();
	}
    global static void asyncHttp(String url) {} //legacy, can't remove
}