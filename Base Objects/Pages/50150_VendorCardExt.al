pageextension 50150 "Vendor CardExt" extends "Vendor Card"
{

    //Editable = false;
    layout
    {

        addafter("Assesse Code")
        {
            field("Approval Status"; "Approval Status")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Tax Information")
        {

            part(TrermsAndCondition; "Terms and Condition")
            {
                ApplicationArea = all;
                SubPageLink = DocumentNo = field("No.");
                SubPageView = where(Type = filter("Terms & Conditions"));
                UpdatePropagation = Both;
            }
            part(termAndSpecifications; "PO Terms and Specifications") //B2BVCOn23Sep2024
            {
                ApplicationArea = All;
                SubPageLink = DocumentNo = field("No.");
                SubPageView = where(Type = filter(Specifications));
                UpdatePropagation = Both;
            }
        }
    }


    actions
    {
        // Add changes to page actions here
        // addafter(CancelApprovalRequest)
        // {
        //     action("Re&lease")
        //     {
        //         ApplicationArea = all;
        //         Caption = 'Re&lease';
        //         ShortCutKey = 'Ctrl+F11';
        //         Image = ReleaseDoc;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         PromotedCategory = Process;
        //         PromotedOnly = true;
        //         ToolTip = 'Executes the Re&lease action.';
        //         trigger OnAction()
        //         var
        //             WorkflowManagement: Codeunit "Workflow Management";
        //             ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //         begin
        //             if ApprovalsMgmt.CheckVendorApprovalsWorkflowEnabled(Rec) then
        //                 error('Workflow is enabled. You can not release manually.');
        //             IF Rec."Approval Status" <> Rec."Approval Status"::Released then BEGIN
        //                 Rec."Approval Status" := Rec."Approval Status"::Released;
        //                 Rec.Modify();
        //                 Message('Document has been Released.');
        //             end;
        //         end;
        //     }
        //     action("Re&open")
        //     {
        //         ApplicationArea = all;
        //         Caption = 'Re&open';
        //         Image = ReOpen;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         PromotedCategory = Process;
        //         PromotedOnly = true;
        //         ToolTip = 'Executes the Re&open action.';
        //         trigger OnAction();
        //         var
        //             RecordRest: Record "Restricted Record";
        //         begin
        //             RecordRest.Reset();
        //             RecordRest.SetRange(ID, 23);
        //             RecordRest.SetRange("Record ID", Rec.RecordId());
        //             IF RecordRest.FindFirst() THEN
        //                 error('This record is under in workflow process. Please cancel approval request if not required.');
        //             IF Rec."Approval Status" <> Rec."Approval Status"::Open then BEGIN
        //                 Rec."Approval Status" := Rec."Approval Status"::Open;
        //                 Rec.Modify();
        //                 Message('Document has been Reopened.');
        //             end;
        //         end;
        //     }
        // }
        modify(SendApprovalRequest)
        {
            ApplicationArea = all;
            trigger OnBeforeAction()
            begin
                Rec.TestField("E-Mail");
            end;
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Released then
            // CurrPage.Editable(false);
            CurrPage.Editable(false);
    end;





    var
        POTerms: Record "PO Terms And Conditions";
        EDITABLE: Boolean;
}