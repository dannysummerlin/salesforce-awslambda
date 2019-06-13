global class awsLambdaMultipleResults {
	@InvocableMethod(label='AWS Lambda Multiple Results' description='Call an AWS Lambda that returns multiple sets of results.')
	global static List<List<LambdaResponse>> callLambdaMultiple(List<String> paramString) {
		List<String> params = paramString[0].split('\n');
		String lambdaUrl = params.remove(0);
		String awsKey = params.remove(0);
		String JSONBody = String.join(params, '\n');
		List<List<LambdaResponse>> finalOutputWrapper = new List<List<LambdaResponse>>();
		List<LambdaResponse> errorOutputWrapperInner = new List<LambdaResponse>();
		LambdaResponse errorOutput = new LambdaResponse();
		errorOutput.text1 = 'none';
		Boolean validJSONBody = false;
		try {
			Map<String, Object> testJSON = (Map<String, Object>) JSON.deserializeUntyped(JSONBody);
			validJSONBody = true;
		} catch(Exception e) {
			errorOutput.text1 = 'Error: you must provide well formatted JSON';
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
				errorOutput.text1 = 'Error';
				errorOutput.text2 = result.getBody();
			} else {
				String body = result.getBody();
				if(!String.isBlank(body)) {
					List<Object> deserialized = new List<Object>();
					Boolean validJSONResponse = false;
					try {
						List<Object> untypedInstance = (List<Object>) JSON.deserializeUntyped(body);
						validJSONResponse = true;
					} catch(Exception e) {
						errorOutput.text1 = 'Error: received invalid JSON, check documentation for response requirements';
						errorOutput.text2 = body;
					}
					if(validJSONResponse) {
						for (Object r : deserialized) {
							String jsonInstance = JSON.serialize(r);
							Map<String, Object> record;
							Boolean validSingleJSON = false;
							List<LambdaResponse> outputWrapper = new List<LambdaResponse>();
							LambdaResponse output = new LambdaResponse();
							try {
								record = (Map<String, Object>) JSON.deserializeUntyped(jsonInstance);
								validSingleJSON = true;
							} catch(Exception e) {
								output.text1 = 'Error: invalid single JSON in array';
								output.text2 = jsonInstance;
							}
							if(validSingleJSON) {
								for (Integer i = 1; i < 11; i++) {
									String value = (String) record.get('text' + String.valueOf(i));
									output.putText(i, value);
								}
								for (Integer i = 1; i < 6; i++) {
									Decimal value = (Decimal) record.get('number' + String.valueOf(i));
									if(value != null)
										output.putNumber(i, value);
								}
								for (Integer i = 1; i < 6; i++) {
									String value = (String) record.get('date' + String.valueOf(i));
									if(value != null)
										output.putDate(i, makeDateFromISO(value));
								}
								for (Integer i = 1; i < 6; i++) {
									String value = (String) record.get('datetime' + String.valueOf(i));
									if(value != null)
										output.putDatetime(i, Datetime.valueOf(value.replace('T',' ')));
								}
								for (Integer i = 1; i < 6; i++) {
									Boolean value = (Boolean) record.get('bool' + String.valueOf(i));
									if(value != null)
										output.putBool(i, value);
								}
								outputWrapper.add(output);
								finalOutputWrapper.add(outputWrapper);
							}
						}
					}
				}
			}
		} else if(validJSONBody) {
			errorOutput.text1 = 'Error: you must provide a valid Lambda URL';
		}
		if(errorOutput.text1 != 'none') {
			errorOutputWrapperInner.add(errorOutput);
			finalOutputWrapper.add(errorOutputWrapperInner);
		}

		return finalOutputWrapper;
	}
	public static Date makeDateFromISO(Object stringDate) {
		//important to use toJSON or toISOString in JS when sending the JSON
		Integer year, month, day;
		Matcher dateElements = Pattern.compile('(\\d+)-(\\d+)-(\\d+)').matcher((String) stringDate);
		dateElements.find();
		year = Integer.valueOf(dateElements.group(1));
		month = Integer.valueOf(dateElements.group(2));
		day = Integer.valueOf(dateElements.group(3));
		return Date.newInstance(year, month, day);
	}
	public Object getP(Object o, String p){
		String jsonInstance = JSON.serialize(o);
		Map<String, Object> untypedInstance = (Map<String, Object>) JSON.deserializeUntyped(jsonInstance);
		return untypedInstance.get(p);
	}
}