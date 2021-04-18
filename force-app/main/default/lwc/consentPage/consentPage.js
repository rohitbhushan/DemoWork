import { LightningElement, track } from 'lwc';
import getDATA from '@salesforce/apex/ConsentPageController.getData';
import { updateRecord , getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const columns = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text'
    }, {
        label: 'HasOptedOutOfEmail',
        fieldName: 'HasOptedOutOfEmail',
        type: 'boolean' ,
        editable: true
    }, {
        label: 'HasOptedOutOfFax',
        fieldName: 'HasOptedOutOfFax',
        type: 'boolean' ,
        editable: true
    }, {
        label: 'DoNotCall',
        fieldName: 'DoNotCall',
        type: 'boolean' ,
        editable: true
    }, {
        label: 'CommercialEmailConsent',
        fieldName: 'CommercialEmailConsent__c',
        type: 'boolean' ,
        editable: true
    },{
        label: 'CommercialPhoneConsent',
        fieldName: 'CommercialPhoneConsent__c',
        type: 'boolean' ,
        editable: true
    },{
        label: 'MarketingEmailConsent',
        fieldName: 'MarketingEmailConsent__c',
        type: 'boolean' ,
        editable: true
    },{
        label: 'MarketingPhoneConsent',
        fieldName: 'MarketingPhoneConsent__c',
        type: 'boolean' ,
        editable: true
    }
];

export default class ConsentPage extends LightningElement {
    isDataPresent = false;
    @track searchKey = '';
    saveDraftValues = [];
    rowOffset = 0;
    @track data;
    columns = columns;
    loadSpinner = false;
    error ;
    
    searchRec(){
        this.isDataPresent = true;
        this.loadSpinner = true;
        getDATA({ searchKey: this.searchKey})
            .then(result => {
                this.data = result;
                console.log('hit ');
                this.loadSpinner = false;
            })
            .catch(error => {
                this.loadSpinner = false;
                this.error = error;
               this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!! '+ JSON.stringify(this.error),
                    variant: 'error'
                })
            );
            });
    }
    
    handleOnchange(event){
        this.searchKey = event.target.value;
       
    }

    handleSave(event){
        
        this.saveDraftValues =event.detail.draftValues;
        const recordInputs = this.saveDraftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
        console.log('recordInputs: '+ JSON.stringify(recordInputs));
        // Prepare the record IDs for getRecordNotifyChange()
        const notifyChangeIds = this.saveDraftValues.map(row => { return { "recordId": row.Id } });
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));

        Promise.all(promises)
            .then(res =>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records Updated Successfully!!',
                        variant: 'success'
                    })
                );
            this.saveDraftValues = [];
            // Refresh LDS cache and wires
            getRecordNotifyChange(notifyChangeIds);
            this.searchRec();
            //this.refreshComponent(event);

        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'An Error Occured!!',
                    variant: 'error'
                })
            );
        })
        .finally(() => {
            this.saveDraftValues = [];
        });
        
    }

    refreshComponent(event){
        eval("$A.get('e.force:refreshView').fire();");
    }

    
}