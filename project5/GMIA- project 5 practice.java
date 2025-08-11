// Loan Report Generator Service Class- Project 5 GMIA

public with sharing class LoanReportGeneratorService {
    public class ReportResponse {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String message;
        @AuraEnabled public String csvData;
    }
    
    public ReportResponse(Boolean success, String message, String csvData) {
        this.success = success;
        this.message = message;
        this.csvData = csvData;
    }

    @AuraEnabled(cacheable=False) {
        public static ReportResponse generateLoanReport() {
            try {
                List<AcctSeed__Accounting_Variable__c> variables = [
                    SELECT Id, Name, Matter__c, Matter__r.Name, Loan_Number_Lien__c, Start_Date_on_Lien__c, 
                           Line_Amount_on_Lien__c, Maturity_Date_on_Lien__c, Atty_c
                    FROM AcctSeed__Accounting_Variable__c
                    WHERE AcctSeed__Type__c = 'GL Account Variable 4' AND AcctSeed__Active__c = true AND Void__c = false
                    AND Matter__c != null
                    WITH SECURITY_ENFORCED
                ];

                Map<Id, List<AcctSeed__Accounting_Variable__c>> grouped = new <Map<Id, List<AcctSeed__Accounting_Variable__c>>();
                for (AcctSeed__Accounting_Variable__c av : variables) {
                    if (!grouped.contains(av.Matter__c)) {
                        grouped.put(av.Matter__c, new List<AcctSeed__Accounting_Variable__c>());
                    }
                    grouped.get(av.Matter__c).add(av);
                }

                Map<Id, Decimal> loanBalances = calculateBalances(grouped.keySet(), '2500');
                Map<Id, Decimal> costsAdvanced = calculateBalances(grouped.keySet(), '1120');

                List<List<String>> csvRows = new List<List<String>>();
                csvRows.add(new List<String>{
                    'Section', 'Matter Name', 'Accounting Variable Name', 'Loan Number', 'Start Date',
                    'Maturity Date', 'Line Amount', 'Costs Advanced', 'Loan Balance', 'Available Credit',
                    'Amount to Advance', 'Draw Needed', 'Client Loan Needed', 'Increase Needed',
                    'Renewal Needed', 'inc $ needed', 'Attorney'
                });

                Date today = Date.today();

                for (Id matterId : grouped.keySet()) {
                    List<AcctSeed__Accounting_Variable__c> records = grouped.get(matterId);
                    AcctSeed__Accounting_Variable__c av = records[0];
                    String section = records.size() == 1 ? 'Unique Records' : 'Duplicate Records';

                    Decimal loan = -1 * loanBalances.get(matterId);
                    Decimal advanced = costsAdvanced.get(matterId);
                    Decimal lineAmt = av.Line_Amount_on_Lien__c != null ? av.Line_Amount_on_Lien__c : 0;
                    Decimal availableCredit = lineAmt - loan;

                    Date maturityDate = av.Maturity_Date_on_Lien__c;
                    String renewalNeeded = (maturityDate != null && maturityDate <= today.addDays(30)) ? 'Y' : 'N';

                    String clientLoanNeeded = (loan + availableCredit == 0 && advanced > 2000) ? 'Y' : 'N';

                    Decimal amtToAdvance = 0;
                    if (availableCredit != 0) {
                        Decimal formulaResult = (availableCredit - 499) > (advanced - loan) ? (advanced - loan) : (available credit - 500);
                        amtToAdvance = formulaResult < 0 ? 0 : formulaResult;
                    }

                    String drawNeeded = (loan > 0 && availableCredit > 500) ? 'Y' : 'N';
                    String increaseNeeded = (loan > 0 && (availableCredit - amtToAdvance) < 1000) ? 'Y' : 'N';
                    Decimal incrementalNeeded = loan + amtToAdvance - advanced;

                    String name = av.Name;
                    if (records.size() > 1) name += ' (+' + (records.size() - 1) + ' more';

                    csvRows.add(new List<String>{
                        section,
                        av.Matter__r.Name,
                        nameav.Loan_Number_Lien__c,
                        String.valueOf(av.Start_Date_on_Lien__c),
                        String.valueOf(maturityDate),
                        String.valueOf(lineAmt),
                        String.valueOf(advanced),
                        String.valueOf(loan),
                        String.valueOf(availableCredit),
                        String.valueOf(amtToAdvance),
                        drawNeeded,
                        clientLoanNeeded,
                        increaseNeeded,
                        renewalNeeded,
                        String.valueOf(incrementalNeeded),
                        av.Atty_c
                    });
                }

                String csv = CsvExportUtil.convertToCSV(csvRows);
                return new ReturnResponse(true, 'CSV generated successfully', csv);
            } catch (Exception e) {
                return new ReportResponse(false, 'Error ' + e.getMessage(), null);
            }
        }
    }

    private static Map<Id, Decimal> calculateBalances(Set<Id> matterIds, String glPrefix) {
        Map<Id, Decimal> result = new Map<Id, Decimal>();
        for (Id id : matterIds) result.put(id, 0);

        List<AggregateResult> aggResults = [
            SELECT AcctSeed_Project__r.Matter__c matterId, SUM(AcctSeed__Amount__c) total
            FROM AcctSeed__Transaction__c
            WHERE AcctSeed__Project__r.Matter__c IN :matterIds
            AND AcctSeed__GL_Account__r.Name LIKE :glPrefix + '%'
            GROUP BY AcctSeed__Project__r.Matter__c
        ];

        for (AggregateResult res : aggResults) {
            Id mid = (Id)res.get('matterId');
            Decimal total = (Decimal)res.get('total');
            result.put(mid, total);
        }

        return result;
    }
}

