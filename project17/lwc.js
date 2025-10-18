import { LightningElement, api, track } from 'lwc';
import reassignApprover from '@salesforce/apex/ReassignApproverController.reassignApprover';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ReassignApproval extends LightningElement {

    @api recordId;
    selectedUserId;
    isSubmitting = false;

    handleUserSelection(event) {
        this.selectedUserId = event.detail.value;
    }

    async handleReassign() {

        if (!this.selectedUserId) {
            this.dispatchEvent(new ShowToastEvent({ title:'Choose an Approver', message:'Please select a new approver before reassigning.', variant:'warning' }));
            return;
        }
        this.isSubmitting = true;
        try {
            await reassignApprover({ invoiceId: this.recordId, approverId: this.selectedUserId });
            this.dispatchEvent(new ShowToastEvent({ title:'Success', message:'Approval reassigned', variant:'success'}));
            this.dispatchEvent(new CloseActionScreenEvent());

        } catch (e) {

            const msg = (e && e.body && e.body.message) || 'An unexpected error occured.';
            this.dispatchEvent(new ShowToastEvent({ title: 'Error reassigning approval', message: msg, variant: 'error', mode: 'sticky' }));

        } finally {
            this.isSubmitting = false;
        }
    }

    close() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}