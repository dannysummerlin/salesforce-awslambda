global class awsLambdaSingleResult {
	@InvocableMethod(label='AWS Lambda Single Result' description='Call an AWS Lambda that returns one set of results.')
	global static List<LambdaResponse> callLambdaSingle(List<String> paramString) {
		List<String> params = paramString[0].split('\n');
		String lambdaUrl = params.remove(0);
		String awsKey = params.remove(0);
		String JSONBody = String.join(params, '\n');
		List<LambdaResponse> outputWrapper = new List<LambdaResponse>();
		LambdaResponse output = new LambdaResponse();
		Boolean validJSONBody = false;
		try {
			if(JSONBody.substring(0,1) == '{')
				Map<String, Object> testJSON = (Map<String, Object>) JSON.deserializeUntyped(JSONBody);
			else
				List<Object> testJSONArray = (List<Object>) JSON.deserializeUntyped(JSONBody);
			validJSONBody = true;
		} catch(Exception e) {
			output.text1 = 'Error: you must provide well formatted JSON';
		}
		if(validJSONBody && !String.isBlank(lambdaUrl) && Pattern.matches('https://.*', lambdaUrl)) {
			HttpRequest request = new HttpRequest();
			request.setEndpoint(lambdaUrl);
			request.setMethod('POST');
			request.setHeader('Content-Type','application/json');
			if(!String.isBlank(awsKey)) { request.setHeader('x-api-key', awsKey); }
			request.setBody(JSONBody);
			Http http = new Http();
			HTTPResponse result = http.send(request);
			if(result.getStatusCode() != 200) {
				output.text1 = 'Error ';
				output.text2 = result.getBody();
			} else {
				String body = result.getBody();
				if(!String.isBlank(body)) {
					List<String> resultWrapper = new List<String>();
					resultWrapper.add(body);
					List<LambdaResponse> processedResult = awsLambdaResultProcessor.processLambdaResult(resultWrapper);
					output = processedResult[0];
				}
			}
		} else if(validJSONBody) {
			output.text1 = 'Error: you must provide a valid Lambda URL';
		}
		outputWrapper.add(output);
		return outputWrapper;
	}
}