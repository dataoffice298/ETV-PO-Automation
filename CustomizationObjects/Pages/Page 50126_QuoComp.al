page 50126 "Quotation Comparision Doc"
{
    PageType = Document;
    ApplicationArea = All;
    Caption = 'Quotation Comparison Doc';
    UsageCategory = Administration;
    SourceTable = QuotCompHdr;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;


                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE();
                    end;
                }
                field("Document Date"; REc."Document Date")
                {
                    ApplicationArea = all;

                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                    ApplicationArea = All;
                }
                field("Orders Created"; Rec."Orders Created")
                {
                    ToolTip = 'Specifies the value of the Orders Created field.';
                    ApplicationArea = All;
                }
                field("Purch. Req. Ref. No."; Rec."Purch. Req. Ref. No.")
                {
                    ToolTip = 'Specifies the value of the Purch. Req. Ref. No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    ApplicationArea = All;
                    Visible = false;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = all;

                }
                field(RFQNumber; Rec.RFQNumber)
                {
                    ApplicationArea = all;

                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = all;

                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = all;

                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = all;
                    Visible = false;

                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = all;
                    Visible = false;

                }
            }


            part(QuotationComparSubForm; QuotationComparSubForm)
            {
                ApplicationArea = all;
                SubPageLink = "Quot Comp No." = FIELD("No.");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action("&Calculate Plan")
            {
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction();
                var
                    PurchHdr: Record "Purchase Header";
                begin
                    quotComp.RESET();
                    quotComp.SetRange("Quot Comp No.", Rec."No.");
                    quotComp.SetFilter("Item No.", '<>%1', '');
                    IF quotComp.FINDFIRST() then
                        error('Already Lines are exists for this Quot Comparision.');
                    IF Rec.RFQNumber = '' then
                        error('Please select the Quot Comparision Number.');
                    PurchHdr.RESET;
                    PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Quote);
                    PurchHdr.SetRange("RFQ No.", Rec.RFQNumber);
                    PurchHdr.SETFILTER(Status, '<>%1', 1);
                    IF PurchHdr.FindFirst() then
                        Error('All Purchase quotes with RFQ no %1 are not released.', Rec.RFQNumber);
                    POAutomation.InsertQuotationLinesNew(Rec.RFQNumber, Rec);
                    CurrPage.UPDATE(true);
                end;
            }
            action("C&arryout Action")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction();
                var
                    POCreationReport: Report "Purchase Order Creation";
                    QuoteCompLine: Record "Quotation Comparison Test";
                    POCreation: Report "Purchase Order Creation New";
                begin
                    Rec.TestField("Orders Created", false);
                    Rec.TestField(Status, Rec.Status::Released);
                    IF Rec.RFQNumber = '' THEN
                        ERROR('Please select the RFQ Number');
                    QuoteCompLine.Reset();
                    QuoteCompLine.SetRange("Quot Comp No.", Rec."No.");
                    QuoteCompLine.SetRange("Carry Out Action", true);
                    if not QuoteCompLine.FindFirst() then
                        Error('Please select atleast one quotation');
                    //POCreationReport.GetValues(Rec.RFQNumber);
                    //POCreationReport.RUN();
                    POCreation.GetValues(Rec.RFQNumber);
                    POCreation.RUN();
                    Rec."Orders Created" := true;
                    CurrPage.UPDATE();
                end;
            }

            separator("-")
            {
                Caption = '-';
            }
            action(Approve)
            {
                ApplicationArea = All;
                Image = Action;
                //Visible = openapp;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    approvalmngmt.ApproveRecordApprovalRequest(RecordId());
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Visible = Not OpenApprEntrEsists and CanrequestApprovForFlow;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    QuoteCompLnLRec: Record "Quotation Comparison Test";
                begin
                    QuoteCompLnLRec.Reset();
                    QuoteCompLnLRec.SetRange("Quot Comp No.", Rec."No.");
                    QuoteCompLnLRec.SetRange("Carry Out Action", true);
                    if not QuoteCompLnLRec.FindFirst() then
                        Error('Please select atleast one quotation');

                    IF allinoneCU.CheckQuoteComparisionCusApprovalsWorkflowEnabled(Rec) then
                        allinoneCU.OnSendQuoteComparisionCusForApproval(Rec);

                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                Visible = CanCancelapprovalforrecord or CanCancelapprovalforflow;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    allinoneCU.OnCancelQuoteComparisionCusForApproval(Rec);
                end;
            }
            action(ApprovalEntries)
            {
                ApplicationArea = all;
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = page "Approval Entries";
                RunPageLink = "Document No." = FIELD("No.");
            }
            action("Re&lease")
            {
                ApplicationArea = all;
                Caption = 'Re&lease';
                ShortCutKey = 'Ctrl+F11';
                Image = ReleaseDoc;
                trigger OnAction()

                begin
                    IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendQuoteComparisionCusforApprovalCode()) then
                        error('Workflow is enabled. You can not release manually.');

                    IF Rec.Status <> Rec.Status::Released then BEGIN
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                        Message('Document is Released.');
                    end;
                end;
            }
            action("Re&open")
            {
                ApplicationArea = all;
                Caption = 'Re&open';
                Image = ReOpen;
                trigger OnAction();
                var
                    RecordRest: Record "Restricted Record";
                begin

                    IF Rec.Status = Rec.Status::"Pending Approval" THEN
                        ERROR('You can not reopen the document when approval status is in %1', Rec.Status);
                    RecordRest.Reset();
                    RecordRest.SetRange(ID, 50010);
                    RecordRest.SetRange("Record ID", Rec.RecordId());
                    IF NOt RecordRest.IsEmpty() THEN
                        error('This record is under in workflow process. Please cancel approval request if not required.');
                    IF Rec.Status <> Rec.Status::Open then BEGIN
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                        Message('Document is Reopened.');
                    end;
                end;
            }

        }
    }
    trigger OnAfterGetRecord();
    begin
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        quotComp.RESET();
        quotComp.SetRange("Quot Comp No.", Rec."No.");
        IF quotComp.FINDSET() then
            quotComp.DeleteAll();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF Rec."Orders Created" = xRec."Orders Created" THEN
            Rec.TestField(Status, Rec.Status::Open);
    end;

    trigger OnInit()
    begin
        Rec.Status := Rec.Status::Open;
    end;

    trigger OnOpenPage()
    begin
        Rec.Status := Rec.Status::Open;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        Rec.Status := Rec.Status::Open;
    END;

    var
        quotComp: Record "Quotation Comparison Test";
        approvalmngmt: Codeunit "Approvals Mgmt.";
        allinoneCU: Codeunit "Approvals MGt 4";
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";
        WorkflowManagement: Codeunit "Workflow Management";
        POAutomation: Codeunit "PO Automation";
        OpenAppEntrExistsForCurrUser: Boolean;
        OpenApprEntrEsists: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;
        CanrequestApprovForFlow: Boolean;

}