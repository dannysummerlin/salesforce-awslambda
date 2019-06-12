global class awsLambdaSingleResult {
	//@InvocableMethod(label='AWS Lambda Single Result' description='Call an AWS Lambda that returns one set of results.')
	global static List<LambdaResponse> callLambdaSingle(List<String> params) {
        String lambdaUrl = params.remove(0);
        String awsKey = params.remove(0);
        String JSONBody = params.remove(0);
		List<LambdaResponse> outputWrapper = new List<LambdaResponse>();
		LambdaResponse output = new LambdaResponse();
		// check valid URL need to use Regex instead
		if(!String.isBlank(lambdaUrl)) {
			HttpRequest request = new HttpRequest();
			request.setEndpoint(lambdaUrl);
			request.setMethod('POST');
			request.setHeader('Content-Type','application/json');
			if(!String.isBlank(awsKey)) { request.setHeader('x-api-key', awsKey); }
            request.setBody(JSONBody);
			Http http = new Http();
			HTTPResponse result = http.send(request);
			if(result.getStatusCode() != 200) {
				output.text1 = 'Error';
				output.text2 = result.getBody();
			} else {
				String body = result.getBody();
				if(!String.isBlank(body)) {
					Map<String, Object> deserialized = (Map<String, Object>) JSON.deserializeUntyped(body);
					for (Integer i = 1; i < 11; i++)
						output.putText(i, deserialized.get('text' + String.valueOf(i)));
					for (Integer i = 1; i < 6; i++)
						output.putNumber(i, deserialized.get('number' + String.valueOf(i)));
					for (Integer i = 1; i < 6; i++)
						output.putDate(i, deserialized.get('date' + String.valueOf(i)));
					for (Integer i = 1; i < 6; i++)
						output.putDatetime(i, deserialized.get('datetime' + String.valueOf(i)));
					for (Integer i = 1; i < 6; i++)
						output.putBool(i, deserialized.get('bool' + String.valueOf(i)));
				}
			}
		} else {
			output.text1 = 'Error: you must provide a valid Lambda URL';
		}
		outputWrapper.add(output);
		return outputWrapper;
	}
}