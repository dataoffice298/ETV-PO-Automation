page 50126 "Quotation Comparision Doc"
{
    PageType = Document;
    Caption = 'Quotation Comparison Document';
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
                    Editable = false;
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
                //B2BMSOn28Oct2022>>
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = all;
                }
                //B2BMSOn28Oct2022<<

                //B2BMSOn04Nov2022>>
                field(Indentor; IndentHdr.Indentor)
                {
                    Caption = 'Indentor';
                    ApplicationArea = all;
                    Editable = false;
                }
                //B2BMSOn04Nov2022<<
                field(Purpose; Rec.Purpose)//B2BSSD23MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'Purpose';
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Project Code';
                    Editable = false;
                }
                field(ProgrammeName; Rec."Programme Name")//B2BSSD23MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'Programme Name';
                }
                field("Quot Comparitive"; Rec."Quot Comparitive")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Workflow Enabled"; Rec."Workflow Enabled")
                {
                    ApplicationArea = All;
                }
            }


            part(QuotationComparSubForm; QuotationComparSubForm)
            {
                ApplicationArea = all;
                SubPageLink = "Quot Comp No." = FIELD("No.");
            }
        }
        //B2BSSD14Feb2023<<
        area(FactBoxes)
        {
            part(AttachmentQuoComp; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Provider = QuotationComparSubForm;
                SubPageLink = "Table ID" = CONST(50202),
                             "No." = FIELD("Indent No."), "Line No." = field("Indent Line No.");
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
            part(QuotCompLinePicture; "Quot Comparision Line Picture")
            {
                ApplicationArea = All;
                Provider = QuotationComparSubForm;
                SubPageLink = "Quot Comp No." = FIELD("Quot Comp No."), "Line No." = FIELD("Line No."), "Item No." = FIELD("Item No.");
            }
        }
        //B2BSSD14Feb2023>>
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
                    QuotationComparisionDelete: Record "Quotation Comparison Test";
                    POAutomation: Codeunit 50026;
                    QuoteCompareArchive: Record "Archive Quotation Comparison";
                    ArchiveQuotationHeader: Record "Archive Quotation Header";
                    QuoCompHdr: Record QuotCompHdr;
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    IndentLineRec: Record "Indent Line";
                    IndentReqLine: Record "Indent Requisitions";
                    PurchaseLineRec: Record "Purchase Line";
                    PurchaseHeaderRec: Record "Purchase Header";

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
                    //B2BMSOn18Oct2022>>

                    // if Confirm('Regularization Activity?', true) then//B2BSS04MAY2023
                    //     Rec.Regularization := true
                    // else
                    //     Rec.Regularization := false;
                    // Rec.Modify();

                    //B2BMSOn18Oct2022<<
                    POCreation.GetValues(Rec.RFQNumber);
                    POCreation.RUN();
                    Rec."Orders Created" := true;
                    CurrPage.UPDATE();

                    // QuoteCompareArchive.SETRANGE("RFQ No.", Rec.RFQNumber);
                    // IF QuoteCompareArchive.FIND('-') THEN
                    //     REPEAT
                    //         QuoteCompareArchive.DELETE;
                    //     UNTIL QuoteCompareArchive.NEXT = 0;


                    ArchiveQCS(); //ETVPO1.1
                                  //B2B1.1START
                                  // QuotationComparisionDelete.RESET;
                                  // QuotationComparisionDelete.SETRANGE("Carry Out Action", TRUE);
                                  // IF QuotationComparisionDelete.FINDFIRST THEN BEGIN
                                  //     QuotationComparisionDelete.DELETE;//B2B1.1
                                  // END;
                                  //END B2B1.1
                                  //CurrPage.UPDATE;
                    PurchaseHeader.RESET();
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    PurchaseHeader.SETRANGE("RFQ No.", RFQNumber);
                    IF PurchaseHeader.FindSet() THEN begin
                        REPEAT
                            PurchaseLine.Reset();
                            PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                            if PurchaseLine.FindSet() then begin
                                repeat
                                    IndentLineRec.Reset();
                                    IndentLineRec.SetRange("Document No.", PurchaseLine."Indent No.");
                                    IndentLineRec.SetRange("Line No.", PurchaseLine."Indent Line No.");
                                    if IndentLineRec.FindSet() then begin
                                        repeat
                                            //    SetSelectionFilter(IndentLineRec);
                                            IndentLineRec.Status := IndentLineRec.Status::"Purchase Order";
                                            IndentLineRec.Modify();
                                        until IndentLineRec.Next() = 0;
                                    end;
                                /* IndentReqLine.Reset();
                                IndentReqLine.SetRange("Document No.", PurchaseLine."Indent Req No");
                                IndentReqLine.SetRange("Line No.", PurchaseLine."Indent Req Line No");
                                if IndentReqLine.FindFirst() then begin
                                    IndentReqLine."Requisition Type" := IndentReqLine."Requisition Type"::"Purch Order";
                                    IndentReqLine."Purch Order No." := PurchaseLine."Document No.";
                                    IndentReqLine.Modify();
                                end; */

                                until PurchaseLine.Next() = 0;
                            end;


                        until PurchaseHeader.Next() = 0;
                    end;


                end;
            }
            //B2BMSOn10Nov2022>>
            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = all;

                /* trigger OnAction()
                var
                    QuoComp: Report "Quotation Comparision";
                begin
                    Clear(QuoComp);
                    QuoComp.SETRFQ(Rec.RFQNumber);
                    QuoComp.Run();
                end; */
            }
            //B2BMSOn10Nov2022<<
            action("Quot Comparison Statement")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    //QuoComp: Report "Quot Comparision Statement";
                    QuoComp: Report ComparitiveStatement;
                    QuotCompHdr: Record QuotCompHdr;
                begin

                    QuotCompHdr.Reset();
                    QuotCompHdr.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::ComparitiveStatement, true, false, QuotCompHdr);

                end;
            }
            action("Comparison Statement")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    QuoComp: Report "Quot Comparision Statement";
                begin
                    Clear(QuoComp);
                    QuoComp.SETRFQ(Rec.RFQNumber);
                    QuoComp.Run();
                end;
            }
            action("Rate Comparison Statement")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                trigger OnAction()
                var
                    QuoComp: Report "Rate Comparative Statement";
                    QuotCompHdr: Record QuotCompHdr;
                begin
                    QuotCompHdr.Reset();
                    QuotCompHdr.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Rate Comparative Statement", true, false, QuotCompHdr);
                end;
            }

            action("Single Vendor Quotation")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = all;
                Caption = 'Single Vendor Quotation';
                trigger OnAction()
                var
                    SingleVendQuot: Report "Single Quotation Report";
                    QuotCompHdr: Record QuotCompHdr;
                begin
                    QuotCompHdr.Reset();
                    QuotCompHdr.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Single Quotation Report", true, false, QuotCompHdr);
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
                    approvalmngmt.ApproveRecordApprovalRequest(Rec.RecordId());
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                //  Visible = Not OpenApprEntrEsists and CanrequestApprovForFlow;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    QuoteCompLnLRec: Record "Quotation Comparison Test";
                begin
                    Rec.TestField("Quot Comparitive");
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
                //     Visible = CanCancelapprovalforrecord or CanCancelapprovalforflow;
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
                var
                    QuotationLines: Record "Quotation Comparison Test";
                begin
                    Rec.TestField("Quot Comparitive");
                    IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendQuoteComparisionCusforApprovalCode()) then
                        error('Workflow is enabled. You can not release manually.');

                    IF Rec.Status <> Rec.Status::Released then BEGIN
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                        QuotationLines.Reset();
                        QuotationLines.SetRange("Quot Comp No.", rec."No.");
                        if QuotationLines.FindSet() then
                            QuotationLines.ModifyAll(Status, QuotationLines.Status::Released);
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
                    QuotationLines: Record "Quotation Comparison Test";
                begin
                    //B2BMSOn11Oct2022>>
                    if Rec."Orders Created" then
                        Error('You can not reopen the document when orders arealready created.');
                    //B2BMSOn11Oct2022<<
                    IF Rec.Status = Rec.Status::"Pending Approval" THEN
                        ERROR('You can not reopen the document when approval status is in %1', Rec.Status);
                    RecordRest.Reset();
                    RecordRest.SetRange(ID, 50010);
                    RecordRest.SetRange("Record ID", Rec.RecordId());
                    IF NOt RecordRest.IsEmpty() THEN
                        error('This record is under in workflow process. Please cancel approval request if not required.');
                    IF Rec.Status <> Rec.Status::Open then BEGIN
                        ArchiveQCS; //B2BMSOn28Oct2022
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();

                        QuotationLines.Reset();
                        QuotationLines.SetRange("Quot Comp No.", rec."No.");
                        if QuotationLines.FindSet() then
                            QuotationLines.ModifyAll(Status, QuotationLines.Status::Open);
                        Message('Document is Archived and Reopened.');
                    end;
                end;
            }

        }
    }
    trigger OnAfterGetRecord();
    begin
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(Rec.RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(Rec.RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);

        //B2BMSOn04Nov2022>>
        Clear(IndentHdr);
        QuoteLines.Reset();
        QuoteLines.SetRange("Quot Comp No.", Rec."No.");
        QuoteLines.SetFilter("Indent No.", '<>%1', '');
        if QuoteLines.FindFirst() then
            if IndentHdr.Get(QuoteLines."Indent No.") then;
        //B2BMSOn04Nov2022<<


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
        IndentHdr: Record "Indent Header"; //B2BMSOn04Nov2022
        QuoteLines: Record "Quotation Comparison Test";



    procedure ArchiveQCS();
    var
        QuotationComparisionDelete: Record "Quotation Comparison Test";
        QuoteCompareArchive: Record "Archive Quotation Comparison";
        ArchiveQuoHeader: Record "Archive Quotation Header";
        LastArchiveQuote: Record "Archive Quotation Header";
    begin

        ArchiveQuoHeader.Init;
        ArchiveQuoHeader.TransferFields(Rec);
        LastArchiveQuote.Reset();
        LastArchiveQuote.SetRange("No.", Rec."No.");
        if LastArchiveQuote.FindLast() then;
        ArchiveQuoHeader.Version := LastArchiveQuote.Version + 1;
        ArchiveQuoHeader.Insert();

        QuotationComparisionDelete.RESET;
        QuotationComparisionDelete.SetRange("RFQ No.", Rec.RFQNumber);
        if QuotationComparisionDelete.FindSet() then
            REPEAT
                QuoteCompareArchive.INIT;
                QuoteCompareArchive.TRANSFERFIELDS(QuotationComparisionDelete);
                QuoteCompareArchive.Version := ArchiveQuoHeader.Version;
                IF NOT (QuoteCompareArchive."Line No." = 0) THEN
                    QuoteCompareArchive.INSERT(TRUE);
            UNTIL QuotationComparisionDelete.NEXT = 0;

    end;

}