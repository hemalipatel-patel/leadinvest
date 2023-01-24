import { LightningElement,api,track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import sendSMS from '@salesforce/apex/lin_GoldAccountSendSMSController.sendSMS';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class Lin_GoldAccountSendSMSComponent extends LightningElement {
    
    @track msg = '';
    @api recordId;
    
    handleChange(event){
        this.msg = event.detail.value;
        console.log('msg-'+this.msg);
    }

    handleClick(event)
    { 
        console.log('i am here'+this.recordId);
        /*inp= this.template.querySelector(`[data-id="smsBody"]`);
        this.msg=inp.value; */
       
        console.log('i am here1'+this.msg);
        if(this.msg!=='')
        { 
            sendSMS({message:this.msg,recordId:this.recordId})
            .then(result => {
                console.log('result--'+JSON.stringify(result));
                if(result.lin_SMS_Sent__c)
                {
                    console.log('in success');
                    this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Message Info',
                        message: 'Message Sent',
                        variant: 'success'
                    }),);
                }
          })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Message Center',
                        message: error.message,
                        variant: 'error'
                    }),
                );
            });
        }
        else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Message Center',
                    message: 'Enter  SMS Message',
                    variant: 'error'
                }),
            );
        }
    }
}