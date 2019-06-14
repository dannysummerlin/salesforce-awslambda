public class AsyncCallFlow {
	@InvocableMethod(label='AWS Lambda Multiple Results' description='Call an AWS Lambda that returns multiple sets of results.')
	global static void callFlow(String flowUrl) { asyncHttp(flowUrl); }
	@future(callout = true)
	global static void asyncHttp(String flowUrl) {
		HttpRequest request = new HttpRequest();
		request.setEndpoint(flowUrl);
		request.setMethod('GET');
		Http http = new Http();
		HTTPResponse result = http.send(request);
	}
}