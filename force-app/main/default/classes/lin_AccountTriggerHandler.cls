/**
* @author       :   LeadInvest
* @date         :   24/01/2023
* @description  :   Account trigger helper 
*/
public class lin_AccountTriggerHandler implements lin_TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;
    public lin_AccountTriggerHelper helper;
    public lin_AccountTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new lin_AccountTriggerHelper();
    }
    /*
    public void beforeInsert(List<Account> newAccounts) {
       
    }
    public void beforeUpdate(List<Account> oldAccounts, List<Account> newAccounts, Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
       
    }
    public void beforeDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) {
       
    }
    public void afterInsert(List<Account> newAccounts, Map<ID, SObject> newAccountMap) {
        
    } */
    public void afterUpdate(List<SObject> oldAccounts, List<SObject> newAccounts, 
                            Map<ID, SObject> oldAccountMap, Map<ID, SObject> newAccountMap) {
                                
           helper.checkGoldAccountToSendSMS((List<Account>)newAccounts,(Map<Id,Account>)oldAccountMap);
        
    }
    /*public void afterDelete(List<Account> oldAccounts, Map<ID, SObject> oldAccountMap) {
    }
    public void afterUndelete(List<Account> newAccounts, Map<ID, SObject> newAccountMap) {
    } */

}