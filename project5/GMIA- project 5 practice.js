import { LightningElement } from 'lwc';
import generateLoanReport from '@salesforce/apex/LoanReportGeneratorService.generateLoanReport';

export default class LoanReportGenerator extends LightningElement {
    isLoading = false;
    error = '';
    message = '';
    csvSummary = '';

    async handleGenerate() {
        try {
            const result = await generateLoanReport();
            if (!result.isSuccess) {
                this.error = result.message;
                return;
            }

            const csvData = result.csvData;
            const BOM = '\uFEFF';
            const csvWithBOM = BOM + csvData;

        } catch {

        }
    }
}