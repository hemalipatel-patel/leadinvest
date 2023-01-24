/**
* @author       :   LeadInvest
* @date         :   24/01/2023
* @description  :   Helper class to send request to Twilio API to send messages
*/
public class lin_TwilioMessageHelper {
    
    
    /**
    * @description  sendMessage method called to send message through twilio
    * 
    * @param    Account , String (message string)
    * @return   Account
    */
    public static Account sendMessage(Account accountObj,String messageStr){
        try{
            HttpRequest req = requestBuilder();
            req.setBody(bodyBuilder(accountObj,messageStr));
            system.debug(req);
            http h = new http();
            HttpResponse res = h.send(req);
            
            TwilioResponse tresponse = (TwilioResponse)JSON.deserialize(res.getBody(), TwilioResponse.class);
            if (tresponse.Status == 'queued'){
                accountObj.lin_SMS_Sent__c = true;
            } 
            return accountObj;
        }catch(Exception ex){
            //exception handling by creating custom object and stores exception ...easy to debug in prod
            return null;
        }
        
    }
    
    /**
    * @description  requestBuilder method called to send message through twilio
    * 
    * @param    
    * @return   
    */
    public static HttpRequest requestBuilder (){
        try{
            lin_TwilioConfig__c tconfigObj = lin_TwilioConfig__c.getOrgDefaults();
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(urlBuilder());
            req.setHeader(
                'Authorization', 'Basic '
                +EncodingUtil.base64Encode(Blob.valueOf(
                    tconfigObj.lin_AccountSid__c 
                    + ':' 
                    + tconfigObj.lin_AuthToken__c
                )
                                          )
            );
            req.setMethod('POST');
            return req;
        }catch(Exception ex){
            //exception handling by creating custom object and stores exception ...easy to debug in prod
            return null;
        }
    }
    
    /**
    * @description  requestBuilder method called to send message through twilio
    * 
    * @param    
    * @return   
    */
    public static string bodyBuilder(Account accObj,String message){
        try{
            String body = '';
            if(!String.isBlank(message)){
                body = message;
            }else{ //store this message in custom labels
                body = 'Great news! A customer has hit Gold.' +accObj.name+ 'will get VIP treatment.';       
            }
            lin_TwilioConfig__c tc = lin_TwilioConfig__c.getOrgDefaults();
            
            string output = 
                'To=' + EncodingUtil.urlEncode(tc.lin_CEO_Number__c,'UTF-8' ) +
                
                '&From=' + EncodingUtil.urlEncode(tc.lin_Twilio_Number__c,'UTF-8') +
                '&Body=' +  body;
            
            system.debug(output);
            return output;
        }catch(Exception ex){
            //exception handling by creating custom object and stores exception ...easy to debug in prod
            return null;
        }
        
    }
    
    /**
    * @description  requestBuilder method called to send message through twilio
    * 
    * @param    
    * @return   
    */
    public static string urlBuilder(){
        
        lin_TwilioConfig__c tconfigObj = lin_TwilioConfig__c.getOrgDefaults();
        
        return 
            tconfigObj.lin_API_Endpoint__c 
            + '/' +
            tconfigObj.lin_API_Version__c
            + '/' +
            'Accounts'
            + '/' +
            tconfigObj.lin_AccountSid__c
            + '/' +
            'SMS/Messages.json'
            ;
        
    }
    
    
    //JSON deserializing for good (status) and bad (message)
    public class TwilioResponse {
        public string status {get;set;}
        public string message {get;set;}
    }
}