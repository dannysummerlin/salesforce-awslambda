global class awsLambdaMultipleResults {
	@InvocableMethod(label='AWS Lambda Multiple Results' description='Call an AWS Lambda that returns multiple sets of results.')
	global static List<List<String>> callLambdaMultiple(List<List<String>> paramString) {
		List<String> params = paramString[0][0].split('\n');
		String lambdaUrl = params.remove(0);
		String awsKey = params.remove(0);
		String JSONBody = String.join(params, '\n');
		List<List<String>> finalOutputWrapper = new List<List<String>>();
		List<String> errorOutputWrapperInner = new List<String>();
		String errorOutput = 'none';
		Boolean validJSONBody = false;
		try {
			Map<String, Object> testJSON = (Map<String, Object>) JSON.deserializeUntyped(JSONBody);
			validJSONBody = true;
		} catch(Exception e) {
			errorOutput = 'Error: you must provide well formatted JSON - ' + JSONBody;
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
				errorOutput = 'Error: ' + result.getBody();
			} else {
				String body = result.getBody();
				if(!String.isBlank(body)) {
					List<Object> deserialized = new List<Object>();
					Boolean validJSONResponse = false;
					try {
						deserialized = (List<Object>) JSON.deserializeUntyped(body);
						validJSONResponse = true;
					} catch(Exception e) {
						errorOutput = 'Error: received invalid JSON, check documentation for response requirements' + body;
					}
					if(validJSONResponse) {
						for (Object r : deserialized) {
							List<String> outputWrapper = new List<String>();
							String output = JSON.serialize(r);
                            outputWrapper.add(output);
							finalOutputWrapper.add(outputWrapper);
						}
					}
				}
			}
		} else if(validJSONBody) {
			errorOutput = 'Error: you must provide a valid Lambda URL';
		}
		if(errorOutput != 'none') {
			errorOutputWrapperInner.add(errorOutput);
			finalOutputWrapper.add(errorOutputWrapperInner);
		}
		return finalOutputWrapper;
	}
}