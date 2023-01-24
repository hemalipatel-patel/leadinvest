/**
* @author       :   LeadInvest
* @date         :   24/01/2023
* @description  :   Mock test class
*/
@isTest
global class lin_TwilioMessageMock implements HttpCalloutMock{
    
    /**
    * @description  mock respond
    * 
    * @param    Account , String (message string)
    * @return   Account
    */
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        String responseJSON = '{ "message" : null, "status" : "queued"}';
        response.setStatusCode(200);
        response.setBody(responseJSON);
        return response; 
    }
}