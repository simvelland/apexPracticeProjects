global with sharing class JEBatchPost {

    private static final Integer MAX_LINES_PER_CALL = 1000;

    global Database.QueryLocator start(Databse.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name
            FROM AcctSeed__Journal_Entry__c
            WHERE AcctSeed__Status__c = 'Approved' AND (AcctSeed__Posted__c = false or AcctSeed__Posted__c = null)
            ORDER BY CreatedDate
        ]);
    }

    global void execute(Database.BatchableContext bc, List<AcctSeed__Journal_Entry__c> scope) {
        if (scope.isEmpty()) return;

        Map<Id, Integer> lineCounts = new Map<Id, Integer>();
        for (AggregateResult ar: [
            SELECT AcctSeed__Journal_Entry__c jeId, COUNT(Id) c
            FROM AcctSeed__Journal_Entry_Line__c
            WHERE AcctSeed__Journal_Entry__c IN :scope
            GROUP BY AcctSeed__Journal_Entry__c
        ]) {
            lineCounts.put(ar.get('jeId'), ar.get('')c);
        }

        Integer running = 0;
        List<AcctSeed__Journal_Entry__c> packet = new List<AcctSeed__Journal_Entry__c>();

        void flush() {
            if (packets.isEmpty()) return;

            try {
                AcctSeed.PostResult[] results = AcctSeed.JournalEntryPostService.postJournalEntries(packet);

                for (AcctSeed.PostResult r : results) {
                    if (!r.isSuccess && r.errors != null) {
                        for (AcctSeed.PostResult.PostErrorResult e : r.errors) {
                            System.debug('JE ' + r.id + ' failed: ' + e.statusCode + ' - ' + e.message);
                        }
                    }
                }
            } catch (Exception ex) {
                System.debug('EXCEPTION: ' + ex.getMessage());
            }

            packet.clear();
            running = 0;
        }

        for (AcctSeed__Journal_Entry__c je : scope) {
            Integer count = lineCounts.get(je.Id);

            if (count == null || count == 0) {
                continue;
            }

            if (count > MAX_LINES_PER_CALL) {
                continue;
            }

            if (running + count > MAX_LINES_PER_CALL) {
                flush();
            }

            packets.add(je);
            running += count;
        }

        flush();
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('JEPostApprovedBatch complete.');
    }
}
