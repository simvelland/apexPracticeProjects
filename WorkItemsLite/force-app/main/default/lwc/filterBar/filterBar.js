import { LightningElement, api, track } from 'lwc';

export default class FilterBar extends LightningElement {
    @api value = { searchText:'', statuses:[], priorities:[], ownerIds:[] };
    @track draft = { searchText:'', statuses:[], priorities:[], ownerIds:[] };

    connectedCallback() {
        this.draft = {
            ...this.value
        };
    }

    get statusOptions() {
        return [
            { label:'New', value:'New' },
            { label:'In Progress', value:'In Progress' },
            { label:'Done', value:'Done' }
        ];
    }

    get priorityOptions() {
        return [
            { label:'Low', value:'Low' },
            { label:'Med', value:'Med' },
            { label:'High', value:'High'}
        ];
    }

    onSearchChange(e) {
        this.draft = { ...this.draft, searchText: e.target.value };
    }

    onStatusesChange(e) {
        this.draft = { ...this.draft, statuses: e.detail.value };
    }

    onPrioritiesChange(e) {
        this.draft = { ...this.draft, priorities: e.detail.value };
    }

    clear() {
        this.draft = { searchText:'', statuses:[], priorities:[], ownerIds:[] };
        this.apply();
    }
    apply() {
        this.dispatchEvent(new CustomEvent('filterchange', {
            detail: { value: { ...this.draft } }, bubbles:true, composed:true
        }));
    }
    create() {
        this.dispatchEvent(new CustomEvent('createclick', { bubbles:true, composed:true }));
    }

    get applyDisabled() {
        const a = this.value, b = this.draft;
        return a.searchText === b.searchText && this.eq(a.statuses, b.statuses) && this.eq(a.priorities, b.priorities);
    }
    eq(arr1=[], arr2=[]) {
        if (arr1.length !== arr2.length) return false;
        const a = [...arr1].sort().join('|'), b = [...arr2].sort().join('|');
        return a === b;
    }
}