public without sharing class ReassignApproverController {
    @AuraEnabled
    public static void reassign(Id invoiceId, Id approverId) {
        ProcessInstanceWorkItem wi = [
            SELECT Id
            FROM ProcessInstanceWorkItem
            WHERE Process.TargetObjectId = :invoiceId
            LIMIT 1
        ]; 

        ProcessWorkItemRequest request = new ProcessWorkItemRequest();
        request.setAction('Reassign');
        request.setNewApproverIds(new Id[] { approverId });
        request.setDescription('Assigning new approver.');
        request.setWorkItemId(wi.Id);

        Approval.ProcessResult result = Approval.Process(request);
        
        if (!result.isSuccess) {
            throw new AuraHandledException('Error processing the ');
        }
    }
}