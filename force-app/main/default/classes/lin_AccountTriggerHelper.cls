/**
* @author       :   LeadInvest
* @date         :   24/01/2023
* @description  :   Account trigger helper 
*/
public class lin_AccountTriggerHelper {
    
    /**
    * @description  sendMessage method called to send message through twilio
    * 
    * @param    Account , String (message string)
    * @return   Account
    */
    public  void checkGoldAccountToSendSMS(list<Account> newAccountList,Map<Id,Account> oldAccountMap
                                                 ){ 
      try{
             Set<Id> accountIds = new Set<Id>();
            for(Account accObj : newAccountList){
                if(accObj.lin_Total_Customer_Spend__c != null && 
                   accObj.lin_Total_Customer_Spend__c != oldAccountMap.get(accObj.Id).lin_Total_Customer_Spend__c &&
                   accObj.lin_Total_Customer_Spend__c >= 50000 && //can add 50000 in utilconstant class
                   !accObj.lin_SMS_Sent__c){
                    accountIds.add(accObj.Id);
                } 
            }
           
           if(accountIds.size() > 0){
                    sendSMSThroughTwilio(accountIds);                                     
           }    
      }catch(exception ex){
           //exception handling by creating custom object and stores exception ...easy to debug in prod
      }
    } 
	
    /**
    * @description  sendMessage method called to send message through twilio
    * 
    * @param    Account , String (message string)
    * @return   Account
    */
	@future(Callout=true)
	public static void sendSMSThroughTwilio(Set<Id> recordIds){
        try{
		//reconstitute the record List
		
		List<Account> accountList = [select id,lin_SMS_Sent__c,name from Account where id in: recordIds];
		List<Account> accountToUpdate = new List<Account>();

		for (Account accOb:accountList){			

			Account accUpdate = lin_TwilioMessageHelper.sendMessage(accOb,'');
            
			system.debug(accOb);

			accountToUpdate.add(accUpdate);
		}

		update accountToUpdate;
        }catch(exception ex){
            //exception handling by creating custom object and stores exception ...easy to debug in prod
        }
	}
    
    
    
}