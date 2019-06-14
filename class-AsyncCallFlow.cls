global class AsyncCallFlow {
	@InvocableMethod(label='Call Async Flow' description='Call a Flow URL with variables asynchronously.')
	global static void callFlow(List<String> flowUrl) { asyncHttp(flowUrl[0]); }
	@future(callout = true)
	global static void asyncHttp(String flowUrl) {
		HttpRequest request = new HttpRequest();
		request.setEndpoint(flowUrl);
		request.setMethod('GET');
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
		Http http = new Http();
		HTTPResponse result = http.send(request);
		System.debug(result.getHeader('Location'));
		if(result.getStatusCode() == 301 || result.getStatusCode() == 302) { 
			System.debug(result.getHeader('Location'));
			request.setEndpoint(result.getHeader('Location'));
			result = new Http().send(request);
		}
		if(result.getStatusCode() == 301 || result.getStatusCode() == 302) {
			System.debug(result.getHeader('Location'));
			request.setEndpoint(result.getHeader('Location'));
			result = new Http().send(request);
		}
		if(result.getStatusCode() == 301 || result.getStatusCode() == 302) {
			System.debug(result.getHeader('Location'));
			request.setEndpoint(result.getHeader('Location'));
			result = new Http().send(request);
		}
	}
}