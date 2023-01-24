/**
* @author       :   LeadInvest
* @date         :   24/01/2023
* @description  :   test class for account trigger handler
*/
@isTest
private class lin_AccountTriggerTest {
	
    /**
    * @description  mock respond
    * 
    * @param    Account , String (message string)
    * @return   Account
    */
    @isTest static void testHelperGood() { //positive test 

		Test.setMock(HttpCalloutMock.class, new lin_TwilioMessageMock());
		dataSetup(); //can use testdatasetup here 		
		
        Account acc = new Account(
			name = 'test account'
		);
		insert acc;
        
        Opportunity opp = new Opportunity(name = 'test opp',accountId = acc.Id,amount = 60000,StageName= 'Prospecting',CloseDate = system.today() + 10);
        insert opp;
        
        Opportunity oppObj = [Select Id,StageName from Opportunity limit 1];
		Test.startTest();
		
        oppObj.StageName = 'Closed Won';
        update oppObj;
		Test.stopTest();
        
        //need to added assert statements
     }
	
    /**
    * @description  mock respond
    * 
    * @param    Account , String (message string)
    * @return   Account
    */
	@isTest static void testHelperBad() { //negative test

		Test.setMock(HttpCalloutMock.class, makeMock('TwilioPostBadSMS', 400));
		dataSetup();		

		Test.startTest();

		Account tm = new Account(
			name = 'test account'
		);
		insert tm;
		Test.stopTest();
	}



	@isTest static void dataSetup(){
		//create our custom setting
		lin_TwilioConfig__c tconfigObj = new lin_TwilioConfig__c();
		tconfigObj.lin_AccountSid__c = 'ACb16f51a6b555b12f9cbb2934c64617f3';
		tconfigObj.lin_AuthToken__c = '3347e880d3145ea1b5826749cf2d3813';
		tconfigObj.lin_Twilio_Number__c = '2816072152';
		tconfigObj.lin_API_Version__c = '2010-04-01';
		tconfigObj.lin_Twilio_Number__c = '+18126127974';
        tconfigObj.lin_CEO_Number__c = '+918898123841';
		tconfigObj.lin_API_Endpoint__c = 'https://api.twilio.com';

		insert tconfigObj;
	}

	public static StaticResourceCalloutMock makeMock(string resource, integer statusCode){
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource(resource);
		mock.setStatusCode(statusCode);
		mock.setHeader('Content-Type', 'application/json');
		return mock;
	}

	@isTest static void testBulkTrigger() { //bulk testing here

		Test.setMock(HttpCalloutMock.class, makeMock('TwilioPostGoodSMS', 201));
		dataSetup();		

		Test.startTest();

		list<Account> accList = new list<Account>();
		for (integer x=0; x<200; x++){
			accList.add( new Account(
						name = 'test acc'+x 
						
						)
			);
		}
		insert accList;
		
		Test.stopTest();
		integer assertCount = 0;
	}

	
}