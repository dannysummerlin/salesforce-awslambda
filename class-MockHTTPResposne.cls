class MockHTTPResponse extends HTTPResponse {
	HTTPResponse mockSuccess() {
		HTTPResponse res = new HTTPResponse();
		res.code = 200;
		res.body = '{"text1":"Mock Text Value","number1":1, "date1": "2019-01-01"}';
		return res;
	}
	HTTPResponse mockError() {
		HTTPResponse res = new HTTPResponse();
		res.code = 503;
		res.body = 'Error Code';
		return res;
	}
	HTTPResponse mockArray() {
		HTTPResponse res = new HTTPResponse();
		res.code = 503;
		res.body = '[{"text1":"Mock Text Value","number1":1}, {"text1":"Second Mock Value", "number1":2, "date1":"2019-01-01"}]';
		return res;
	}
}