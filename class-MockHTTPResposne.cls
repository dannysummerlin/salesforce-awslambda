@isTest
global class MockHTTPResponse implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		//req.getEndpoint()
		// need to have this respond to req to get different conditions, only doing success for now
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"text1":"Mock Text Value","number1":1, "number2":"2", "date1": "2019-01-01", "datetime1":"2019-06-12T20:59:21.318Z"}');
		// '[{"text1":"Mock Text Value","number1":1}, {"text1":"Second Mock Value", "number1":2, "date1":"2019-01-01"}]', array data, status 200
		// 'Error Code', status 503
		res.setStatusCode(200);
		return res;
	}
}