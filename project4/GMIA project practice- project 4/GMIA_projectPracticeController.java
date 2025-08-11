public with sharing class CSVBankTransactionController {

    @AuraEnabled
    public static String validateCSVHeaders(String headerRow) {
        List<String> requiredHeaders = new List<String>() {
            'TRC Number', 'Account Number', 'Account Type', 'Account Name',
            'Post Date', 'Reference', 'Additional Reference', 'Amount',
            'Description', 'Type', 'Text'
        };

        List<String> inputHeaders = headerRow.split(',');

        for (String req: requiredHeaders) {
            if (!inputHeaders.contains(req)) {
                return 'Missing required column: ' + req;
            }
        }

        return 'SUCCESS';
    }

    @AuraEnabled
    public static List<Map<String, String>> transformCSVRows(String csvBody) {
        List<Map<String, String>> outputRows = new List<Map<String, String>>();
        List<String> lines = csvBody.split('\n');

        if (lines.size() <= 1) {
            throw new AuraHandledException('CSV is empty or has no data rows');
        }

        List<String> headers = lines[0].trim().replaceAll('\r', '').split(',');

        Map<String, Integer> colIndex = new Map<String, Integer>();
        for (Integer i = 0; i < headers.size(); i++) {
            colIndex,put(headers[i].trim(), i);
        }

        Set<String> acctIds = new Set<String>();
        for (Integer i = 1; i < lines.size(); i++) {
            String line = lines[i].trim();
            List<String> values = line.replaceAll('\r', '').split(',');
            acctIds.add(values[colIndex.get('Account Number')]);
        }

        Map<String, String> acctIdToGLAM = new Map<String, String>();
        for (GLAM4BankCSV__c rec : [
            SELECT AccountId__c, GLAM4BankCSV__c
            FROM GLAM4BankCSV__c
            WHERE AccountId__c IN :acctIds
        ]) {
            acctIdToGLAM.put(rec.AccountId__c, rec.GLAM__c);
        }

        String accountId = '';
        Integer counter = 0;

        for (Integer i = 1; i < lines.size(); i++) {

            String line = lines[i].trim();
            if (String.isBlank(line)) continue;

            List<String> values = line.replaceAll('\r', '').split(',');
            if (String.isBlank(accountId)) {
                String acctNum = values[colIndex.get('Account Number')];
                accountId = acctNum;
            }

            String amountStr = values[colIndex.get('Amount')].replace('$', '').replace(',', '').trim();
            if (amountStr.startsWith('(') && amountStr.endsWith(')')) {
                amountStr = '-' + amountStr.replace('(', '').replace(')', '');
            }
            Decimal amount = Decimal.valueOf(amountStr);
            String baseType = (amount >= 0) ? 'Credit': 'Debit';
            Decimal cleanAmount = amount.abs().setScale(2);

            String last4acct = acctNum.right(4);
            String timestamp = Datetime.now().format('MMddHHmmss');
            String paddedCounter = String.valueOf(counter);
            while (paddedCounter.length() < 4) {
                paddedCounter = '0' + paddedCounter;
            }
            String btId = last4acct + timestamp + paddedCounter;
            String key = 'Checking' + btId;

            String glMapping = acctIdToGLAM.get(accountId);

            Map<String, String> rowMap = new Map<String, String>{
                'Base Type' => baseType,
                'Memo' => values[colIndex.get('Description')],
                'Description' => values[colIndex.get('Text')],
                'Check Number' => values[colIndex.get('Additional Reference')],
                'Amount' => String.valueOf(cleanAmount),
                'DATE' => values[colIndex.get('Post Date')],
                'Container' => 'Checking',
                'Status' => 'Unmatched',
                'Accountid' => accountId,
                'GL Account Mapping' => glMapping,
                'Bank Transaction ID' => btId,
                'Key' => key,
                'Source' => 'Financial File Import',
                'Post Date' => values[colIndex.get('Post Date')],
                'Type' => values[colIndex.get('Type')]
            };

            outputRows.add(rowMap);
            counter++;
        }

        return outputRows;
    }

    @AuraEnabled
    public static void sendTransformedCSV(List<Map<String, String>> transformedRows) {
        if (transformedRows.isEmpty()) {
            throw new AuraHandledException('No rows to send.');
        }

        List<String> headers = new List<String>(transformedRows[0].keySet());
        headers.sort();

        String csvContent = String.join(headers, ',') + '\n';

        for (Map<String, String> row : transformedRows) {
            List<String> line = new List<String>();
            for (String header : headers) {
                String rawValue = row.get(header) != null ? row.get(header).trim() : '';
                
                if (rawValue.startsWith('"') && rawValue.endsWith('"') && rawValue.length() >= 2) {
                    cleaned = rawValue.substring(1, rawValue.length() - 1);
                }

                line.add(cleaned);
            }

            csvContent += String.join(line, ',') + '\n';
        }

        Blob csvBlob = Blob.valueOf(csvContent);

        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileNAme('transformed_bank_transactions.csv');
        attachment.setBody(csvBlob);
        attachment.setContentType('text/csv');

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{'sim.velland@gmail.com'});
        mail.setSubject('Transformed Bank Transaction CSV File');
        mail.setPlainTextBody('Your transformed CSV file is attached.');
        mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{ attachment });

        Messaging.sendEmail(new List<Messaging.Email>{ mail });
    }
}