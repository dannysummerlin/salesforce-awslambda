@isTest
private class testAWSLambdaResults {
	static String testURL = 'https://api.summerlin.co/tests/lambda-example';
	static String apiKey = 'DEMOKEY';
	private static testMethod void testCall() {
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		List<String> params = new List<String>();
		params.add(testURL);
		params.add(apiKey);
		params.add('{"test":"Sent from Salesforce"}');
		List<String> paramArray = new List<String>();
		paramArray.add(String.join(params, '\n'));
		List<LambdaResponse> result = awsLambdaSingleResult.callLambdaSingle(paramArray);
		System.debug(result);
	}
	private static testMethod void testMultiCall() {
		Test.setMock(HttpCalloutMock.class, new MockMultiHttpResponse());
		List<String> params = new List<String>();
		params.add(testURL);
		params.add(apiKey);
		params.add('{"test":"Sent from Salesforce"}');
		List<String> paramArray = new List<String>();
		paramArray.add(String.join(params, '\n'));
		List<List<String>> paramArrayWrapper = new List<List<String>>();
		paramArrayWrapper.add(paramArray);
		List<List<String>> results = awsLambdaMultipleResults.callLambdaMultiple(paramArrayWrapper);
		for(List<String> r : results) {
			List<LambdaResponse> lr = awsLambdaMultipleResultsProcessor.processLambdaResult(r);
			System.debug(lr);
		}
		System.debug(results);
	}
	// private static testMethod void testCount() { testReturn('count(description)', callJSONQueryAction('select count(description) from data', 'javascript'), '4'); }
	// private static void testReturn(String testName, List<List<JSONQueryResult>> result, String testValue) { testReturn(testName, result[0], testValue); }
	// private static void testReturn(String testName, List<JSONQueryResult> result, String testValue) {
}