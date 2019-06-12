@isTest //(SeeAllData=true)
private class testAWSLambdaResults {
	static String testURL = 'https://api.summerlin.co/tests/Salesforce-awsLambdaTest';
	static String apiKey = 'NmzbGGo2wP3YqFW8AHs6J9wcSbSGeJjq7jKds1JN';
	private static testMethod void testCall() {
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		List<String> params = new List<String>();
		params.add(testURL);
		params.add(apiKey);
		params.add('{"test":"Sent from Salesforce"}');
		List<LambdaResponse> result = awsLambdaSingleResult.callLambdaSingle(params);
// but can't use
		System.debug(result);
	}
	// private static testMethod void testCount() { testReturn('count(description)', callJSONQueryAction('select count(description) from data', 'javascript'), '4'); }
	// private static void testReturn(String testName, List<List<JSONQueryResult>> result, String testValue) { testReturn(testName, result[0], testValue); }
	// private static void testReturn(String testName, List<JSONQueryResult> result, String testValue) {
}