pageextension 50185 CustomerExt extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Blocked)
        {
            field("Approval Status"; "Approval Status")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(CancelApprovalRequest)
        {
            action("Re&lease")
            {
                ApplicationArea = all;
                Caption = 'Re&lease';
                ShortCutKey = 'Ctrl+F11';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Re&lease action.';
                trigger OnAction()
                var
                    WorkflowManagement: Codeunit "Workflow Management";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    if ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) then
                        //   CheckVendorApprovalsWorkflowEnabled(Rec) then
                        error('Workflow is enabled. You can not release manually.');
                    IF Rec."Approval Status" <> Rec."Approval Status"::Released then BEGIN
                        Rec."Approval Status" := Rec."Approval Status"::Released;

                        Rec.Modify();
                        Message('Document has been Released.');
                    end;
                end;
            }
            action("Re&open")
            {
                ApplicationArea = all;
                Caption = 'Re&open';
                Image = ReOpen;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the Re&open action.';
                trigger OnAction();
                var
                    RecordRest: Record "Restricted Record";
                begin
                    RecordRest.Reset();
                    RecordRest.SetRange(ID, 18);
                    RecordRest.SetRange("Record ID", Rec.RecordId());
                    IF RecordRest.FindFirst() THEN
                        error('This record is under in workflow process. Please cancel approval request if not required.');
                    IF Rec."Approval Status" <> Rec."Approval Status"::Open then BEGIN
                        Rec."Approval Status" := Rec."Approval Status"::Open;
                        Rec.Modify();
                        Message('Document has been Reopened.');
                    end;
                end;
            }
        }
        modify(SendApprovalRequest)
        {
            ApplicationArea = all;
            trigger OnBeforeAction()
            begin
                Rec.TestField("E-Mail");
            end;
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Released then
            CurrPage.Editable(false);
    end;
}

