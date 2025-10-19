import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ToastHost extends LightningElement {
    show({ title, message, variant }) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}