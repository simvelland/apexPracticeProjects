import { LightningElement, api } from 'lwc';

export default class Worklist extends LightningElement {
    @api items = [];
    @api loading = false;
    @api error = null;
    @api sort;

    get hasRows() {
        return !this.loading && !this.error && this.items?.length > 0;
    }
    get isEmpty() {
        return !this.loading && !this.error && (!this.items || this.items.length === 0);
    }

    get ariaName()    { return this.ariaFor('Name'); }
    get ariaStatus()  { return this.ariaFor('Status__c'); }
    get ariaPriority(){ return this.ariaFor('Priority__c'); }
    get ariaDue()     { return this.ariaFor('Due_Date__c'); }
    get ariaOwner()   { return this.ariaFor('OwnerName'); }

    ariaFor(field) {
        if (!this.sort || this.sort.fieldName !== field) return 'none';
        return this.sort.direction === 'desc' ? 'descending' : 'ascending';
    }

    // Header click
    sortClick(e) {
        const field = e.currentTarget?.dataset?.field;
        if (!field) return;
        const current = this.sort || {};
        const nextDir = (current.fieldName === field && current.direction === 'asc') ? 'desc' : 'asc';
        this.dispatchEvent(new CustomEvent('sortchange', {
        detail: { fieldName: field, direction: nextDir }, bubbles:true, composed:true
        }));
    }

    edit(e) { this.emit('rowedit', { id: e.currentTarget.dataset.id }); }
    toggle(e) { this.emit('rowtoggle', { id: e.currentTarget.dataset.id }); }
    del(e) { this.emit('rowdelete', { id: e.currentTarget.dataset.id }); }

    emit(name, detail) {
        this.dispatchEvent(new CustomEvent(name, { detail, bubbles:true, composed: true }));
    }
}