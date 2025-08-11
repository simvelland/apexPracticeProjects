import { LightningElement } from 'lwc';
import validateCSVHeaders from '@salesforce/apex/CSVBankTransactionController.validateCSVHeaders';
import transformCSVRows from '@salesforce/apex/CSVBankTransactionController.transformCSVRows';
import sendTransformedCSV from '@salesforce/apex/CSVBankTransactionController.sendTransformedCSV';

export default class CSVBankTransactionUploader extends LightningElement {
    error;
    success;
    processedData = [];
    downloadReady = false;

    triggerFileInput() {
        this.template.querySelector('input[type="file"]').click();
    }

    handleFileChange(event) {
        const file = event.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = () => {
            const csvContent = reader.result;
            const lines = csvContent.split(/\r?\n/);
            const headerLine = lines[0];

            validateCSVHeaders({ headerRow: headerLine })
                .then(validationResult => {
                    if (validationResult !== 'SUCCESS') {
                        this.error = validationResult;
                        this.success = null;
                        this.downloadReady = false;
                        return;
                    }

                    transformCSVRows({ csvBody: csvContent })
                        .then(result => {
                            this.processedData = result;
                            this.success = 'CSV file has been successfully transformed.';
                            this.error = null;
                            this.downloadReady = true;
                        })
                        .catch(error => {
                            this.error = error.body.message;
                            this.success = null;
                        })
                })
                .catch(error => {
                    this.error = error.body.message;
                    this.success = null;
                });
        };
        reader.readAsText(file);
    }

    sendEmailWithCSV() {
        sendTransformedCSV({ transformedRows: this.processedData })
            .then(() => {
                this.success = 'Email sent successfully with transformed file';
                this.error = null;
            })
            .catch(error => {
                this.error = error.body.message;
                this.success = null;
            });
    }
}