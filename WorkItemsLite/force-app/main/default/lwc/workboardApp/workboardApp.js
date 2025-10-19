import { LightningElement, track } from 'lwc';

export default class WorkboardApp extends LightningElement {
    @track rawItems = [];
    @track items = [];
    @track ui = { loading: true, error: null };
    @track filters = { searchText:'', statuses:[], priorities:[], ownerIds:[] };
    @track sort = { fieldName: 'Due_Date__c', direction: 'asc' };

    connectedCallback() {

        this.simulateFetch({ mode: 'ok' });
    }

    reloadOk() {
        this.simulateFetch( {mode: 'ok' });
    }
    reloadError() {
        this.simulateFetch({ mode: 'error' });
    }
    openCreate() {
        this.toast('Coming soon', 'Editor modal arrives in Step 3.', 'info');
    }

    handleFilterChange(evt) {
        this.filters = { ...evt.detail.value };
        this.recompute();
    }
    handleSortChange(evt) {
        this.sort = { ...evt.detail.value };
        this.recompute();
    }

    simulateFetch({ mode }) {
        this.ui = { loading: true, error: null };

        window.setTimeout(() => {
            if (mode === 'error') {
                this.rawItems = [];
                this.items = [];
                this.ui = { loading: false, error: 'Failed to load work items (simulated).' };
                return;
            }
            const now = new Date();
            const d = (offset) => new Date(now.getFullYear(), now.getMonth(), now.getDate() + offset).toISOString();
            this.items = [
                {
                    Id: 'WI-001',
                    Name: 'Design landing page hero',
                    Status__c: 'In Progress',
                    Priority__c: 'High',
                    Due_Date__c: d(2),
                    Owner__c: '005xx0000000001AAA',
                    OwnerName: 'Ada Lovelace'
                },
                {
                    Id: 'WI-002',
                    Name: 'Data export script',
                    Status__c: 'New',
                    Priority__c: 'Med',
                    Due_Date__c: d(5),
                    Owner__c: '005xx0000000002AAA',
                    OwnerName: 'Alan Turing'  
                },
                {
                    Id: 'WI-003',
                    Name: 'Update onboarding doc',
                    Status__c: 'Done',
                    Priority__c: 'Low',
                    Due_Date__c: d(-1),
                    Owner__c: '005xx0000000003AAA',
                    OwnerName: 'Grace Hopper'
                }
            ];
            this.ui = { loading: false, error: null };
            this.recompute();
        }, 700);
    }

    recompute() {
        const visible = this.applyFilters(this.rawItems, this.filters);
        this.items = this.applySort(visible, this.sort);
    }

    applyFilters(rows, f) {
        if (!Array.isArray(rows) || rows.length === 0) return [];
        const q = (f.searchText || '').toLowerCase();

        return rows.filter(r => {
        const matchesSearch = !q
            || (r.Name || '').toLowerCase().includes(q)
            || (r.OwnerName || '').toLowerCase().includes(q);

        const matchesStatus = f.statuses.length === 0 || f.statuses.includes(r.Status__c);
        const matchesPriority = f.priorities.length === 0 || f.priorities.includes(r.Priority__c);
        const matchesOwner = !f.ownerIds || f.ownerIds.length === 0 || f.ownerIds.includes(r.Owner__c);

        return matchesSearch && matchesStatus && matchesPriority && matchesOwner;
        });
    }

    applySort(rows, sort) {
        if (!Array.isArray(rows) || rows.length === 0) return [];
        const field = sort?.fieldName || 'Due_Date__c';
        const dir   = (sort?.direction === 'desc') ? -1 : 1;

        return [...rows].sort((a,b) => {
        const av = a?.[field]; const bv = b?.[field];
        if (av == null && bv == null) return 0;
        if (av == null) return  1;
        if (bv == null) return -1;

        // ISO dates sort lexicographically; strings too
        const as = String(av), bs = String(bv);
        if (as < bs) return -1 * dir;
        if (as > bs) return  1 * dir;
        return 0;
        });
    }

    toast(title, message, variant) {
        this.template.querySelector('c-toast-host').show({ title, message, variant });
    }
}