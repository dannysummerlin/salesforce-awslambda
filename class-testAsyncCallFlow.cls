@isTest
private class testAsyncCallFlow {
	private static testMethod void testCall() {
        List<String> testList = new List<String>();
        testList.add('{"flow":"none","variables":{"test":1}}');
        AsyncCallFlow.callFlow(testList);
    }
}