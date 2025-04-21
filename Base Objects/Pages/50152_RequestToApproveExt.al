pageextension 50152 RequestToApproveExt extends "Requests to Approve"
{
    actions
    {
        modify(Reject)
        {
            trigger OnBeforeAction()
            var
                ApprovalCommentLine: Record "Approval Comment Line";
            begin
                ApprovalCommentLine.Reset();
                ApprovalCommentLine.SetRange("Table ID", Rec."Table ID");
                ApprovalCommentLine.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                if Not ApprovalCommentLine.FindFirst() then
                    ApprovalCommentLine.TestField(Comment);
            end;
        }
        modify(Approve)
        {
            trigger OnBeforeAction()
            var
                ApprovalCommentLine: Record "Approval Comment Line";
                ApporvalEntry: Record "Approval Entry";
            begin
                ApporvalEntry.Reset();
                ApporvalEntry.SetRange("Table ID", Database::QuotCompHdr);
                ApporvalEntry.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                ApporvalEntry.SetRange(Comment, false);
                if ApporvalEntry.FindFirst() then
                    Error('Comment must have a value in Approval Comment Line');
            end;
        }
    }
}