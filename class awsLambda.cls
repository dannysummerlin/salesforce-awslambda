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
		// check valid URL need to use Regex instead
		try {
			Map<String, Object> testJSON = (Map<String, Object>) JSON.deserializeUntyped(JSONBody);
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
				output.text1 = 'Error';
				output.text2 = result.getBody();
			} else {
				String body = result.getBody();
				if(!String.isBlank(body)) {
					Map<String, Object> deserialized = new Map<String, Object>();
					Boolean validJSONResponse = false;
					try {
						deserialized = (Map<String, Object>) JSON.deserializeUntyped(body);
						validJSONResponse = true;
					} catch(Exception e) {
						output.text1 = 'Error: received invalid JSON, check documentation for response requirements';
						output.text2 = body;
					}
					if(validJSONResponse) {
						for (Integer i = 1; i < 11; i++) {
							String value = (String) deserialized.get('text' + String.valueOf(i));
							output.putText(i, value);
						}
						for (Integer i = 1; i < 6; i++) {
							Decimal value = (Decimal) deserialized.get('number' + String.valueOf(i));
							if(value != null)
								output.putNumber(i, value);
						}
						for (Integer i = 1; i < 6; i++) {
							String value = (String) deserialized.get('date' + String.valueOf(i));
							if(value != null)
								output.putDate(i, makeDateFromISO(value));
						}
						for (Integer i = 1; i < 6; i++) {
							String value = (String) deserialized.get('datetime' + String.valueOf(i));
							if(value != null)
								output.putDatetime(i, Datetime.valueOf(value.replace('T',' ')));
						}
						for (Integer i = 1; i < 6; i++) {
							Boolean value = (Boolean) deserialized.get('bool' + String.valueOf(i));
							if(value != null)
								output.putBool(i, value);
						}
					}
				}
			}
		} else if(validJSONBody) {
			output.text1 = 'Error: you must provide a valid Lambda URL';
		}
		outputWrapper.add(output);
		return outputWrapper;
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
}