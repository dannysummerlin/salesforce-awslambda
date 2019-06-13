global class awsLambdaMultipleResultsProcessor {
	@InvocableMethod(label='Process AWS Lambda Multiple Results output' description='Processes the output of the JSON returned by the Multiple Result Apex')
	global static List<LambdaResponse> processLambdaResult(List<String> jsonBodyArray) {
		String body = jsonBodyArray[0];
		List<LambdaResponse> outputWrapper = new List<LambdaResponse>();
		LambdaResponse output = new LambdaResponse();
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