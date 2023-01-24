public class lin_GoldAccountSendSMSController {
	
    @auraenabled(cacheable=true)
    public static Account sendSMS(String message,String recordId){
        system.debug('**************'+message);
        Account accObj = [Select id,name from Account where id = :recordId];
        Account returnAcc = lin_TwilioMessageHelper.sendMessage(accObj,message);
        return returnAcc;
    }
}