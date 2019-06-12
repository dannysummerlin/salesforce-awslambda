class MockHTTPResponse extends HTTPResponse {
	HTTPResponse send() {
		HTTPResponse res = new HTTPResponse();
		res.body = '{"text1":"Mock Text Value","number1":1, "date1": "2019-01-01"}';
		return res;
	}
}