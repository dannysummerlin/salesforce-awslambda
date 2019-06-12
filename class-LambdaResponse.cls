global class LambdaResponse {
	global void putText(Integer itemNumber, Object input) {
		String value = String.valueOf(input);
		switch on itemNumber {
			when 1 { text1 = value; }
			when 2 { text2 = value; }
			when 3 { text3 = value; }
			when 4 { text4 = value; }
			when 5 { text5 = value; }
			when 6 { text6 = value; }
			when 7 { text7 = value; }
			when 8 { text8 = value; }
			when 9 { text9 = value; }
			when 10 { text10 = value; }
		}
	}
	global void putDate(Integer itemNumber, Object input) {
		Date value = Date.valueOf(input);
		switch on itemNumber {
			when 1 { date1 = value; }
			when 2 { date2 = value; }
			when 3 { date3 = value; }
			when 4 { date4 = value; }
			when 5 { date5 = value; }
		}
	}
	global void putDatetime(Integer itemNumber, Object input) {
		Datetime value = Datetime.valueOf(input);
		switch on itemNumber {
			when 1 { datetime1 = value; }
			when 2 { datetime2 = value; }
			when 3 { datetime3 = value; }
			when 4 { datetime4 = value; }
			when 5 { datetime5 = value; }
		}
	}
	global void putNumber(Integer itemNumber, Object input) {
// getting can't use null here, need some better checking
		Decimal value = Decimal.valueOf(String.valueOf(input));
		switch on itemNumber {
			when 1 { number1 = value; }
			when 2 { number2 = value; }
			when 3 { number3 = value; }
			when 4 { number4 = value; }
			when 5 { number5 = value; }
		}
	}
	global void putBool(Integer itemNumber, Object input) {
		Boolean value = Boolean.valueOf(input);
		switch on itemNumber {
			when 1 { bool1 = value; }
			when 2 { bool2 = value; }
			when 3 { bool3 = value; }
			when 4 { bool4 = value; }
			when 5 { bool5 = value; }
		}
	}
	@InvocableVariable
	global String text1;
	@InvocableVariable
	global String text2;
	@InvocableVariable
	global String text3;
	@InvocableVariable
	global String text4;
	@InvocableVariable
	global String text5;
	@InvocableVariable
	global String text6;
	@InvocableVariable
	global String text7;
	@InvocableVariable
	global String text8;
	@InvocableVariable
	global String text9;
	@InvocableVariable
	global String text10;
	@InvocableVariable
	global Date date1;
	@InvocableVariable
	global Date date2;
	@InvocableVariable
	global Date date3;
	@InvocableVariable
	global Date date4;
	@InvocableVariable
	global Date date5;
	@InvocableVariable
	global Datetime datetime1;
	@InvocableVariable
	global Datetime datetime2;
	@InvocableVariable
	global Datetime datetime3;
	@InvocableVariable
	global Datetime datetime4;
	@InvocableVariable
	global Datetime datetime5;
	@InvocableVariable
	global Decimal number1;
	@InvocableVariable
	global Decimal number2;
	@InvocableVariable
	global Decimal number3;
	@InvocableVariable
	global Decimal number4;
	@InvocableVariable
	global Decimal number5;
	@InvocableVariable
	global Boolean bool1;
	@InvocableVariable
	global Boolean bool2;
	@InvocableVariable
	global Boolean bool3;
	@InvocableVariable
	global Boolean bool4;
	@InvocableVariable
	global Boolean bool5;
}