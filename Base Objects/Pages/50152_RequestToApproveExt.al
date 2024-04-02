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
    }
}