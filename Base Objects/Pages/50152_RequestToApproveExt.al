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
                ApprovalCommentLine.SetRange("User ID", Rec."Approver ID");
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
                // ApprovalCommentLine.Reset();
                // ApprovalCommentLine.SetRange("Table ID", Database::QuotCompHdr);
                // ApprovalCommentLine.SetRange("Record ID to Approve", Rec."Record ID to Approve");
                // ApprovalCommentLine.SetRange("User ID", Rec."Approver ID");
                // if Not ApprovalCommentLine.FindFirst() then
                //     ApprovalCommentLine.TestField(Comment);

                ApporvalEntry.Reset();
                ApporvalEntry.SetRange("Table ID", Database::QuotCompHdr);
                ApporvalEntry.SetRange("Record ID to Approve", rec."Record ID to Approve");
                if ApporvalEntry.FindFirst() then begin
                    ApprovalCommentLine.Reset();
                    ApprovalCommentLine.SetRange("Table ID", ApporvalEntry."Table ID");
                    ApprovalCommentLine.SetRange("Record ID to Approve", ApporvalEntry."Record ID to Approve");
                    ApprovalCommentLine.SetRange("User ID", ApporvalEntry."Approver ID");
                    if Not ApprovalCommentLine.FindFirst() then
                        ApprovalCommentLine.TestField(Comment);
                end;
            end;
        }
    }
}