@isTest
private class testAsyncCallFlow {
	static String testURL = 'https://api.summerlin.co/tests/lambda-example';
	static String apiKey = 'DEMOKEY';
	private static testMethod void testHttp() {
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		List<String> url = new List<String>();
		url.add('https://test.com');
		AsyncCallFlow.callFlow(url);
	}
}