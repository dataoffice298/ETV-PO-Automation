page 50116 "Indent Header"
{
    // version PH1.0,PO1.0,REP1.0

    PageType = Document;
    SourceTable = "Indent Header";
    Caption = 'Indent Document';
    SourceTableView = where("Indent Transfer" = const(false));//BaluOn19Oct2022>>
    PromotedActionCategories = 'New,Process,Report,Functions';

    layout
    {
        area(content)
        {
            group(General)
            {
                //Editable = PageEditable; //B2BPGON10OCT2022
                Caption = 'General';
                field("No."; rec."No.")
                {
                    AssistEdit = true;
                    Editable = PageEditable;
                    ApplicationArea = All;
                    trigger OnAssistEdit();
                    begin
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    Editable = PageEditable;

                }
                field(Indentor; rec.Indentor)
                {
                    Caption = 'Indentor';
                    ApplicationArea = all;
                    Editable = PageEditable;

                }
                field(Department; rec.Department)
                {
                    Visible = false;
                    ApplicationArea = all;
                    Editable = PageEditable;

                }
                field("Document Date"; rec."Document Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                    Editable = PageEditable;

                }
                field("Released Status"; rec."Released Status")
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                    Editable = false;

                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = all;
                    Editable = PageEditable;

                }
                field(Authorized; rec.Authorized)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                }
                //B2BMSOn13Sep2022>>
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = All;
                    Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("Ammendent Comments"; Rec."Ammendent Comments")
                {
                    ApplicationArea = All;
                }
                //B2BMSOn13Sep2022<<

                // >> B2BPAV 
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 1 Code';
                    Editable = PageEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 2 Code';
                    Editable = PageEditable;
                }
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 9 Code';
                    Editable = PageEditable;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Project Code';
                }
                field("programme Name"; Rec."programme Name")//B2BSS20MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'programme Name';
                    Editable = PageEditable;
                }
                field(Purpose; Rec.Purpose)//B2BSSD21MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'Purpose';
                    Editable = PageEditable;
                    ShowMandatory = true;
                }
                field("Delivery Location"; Rec."Delivery Location")//B2BSSD03MAY2023
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                    Editable = PageEditable;
                }
                //B2BVCOn17Jun2024 >>
                field("ShortClose Status"; Rec."ShortClose Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ShortClose; Rec.ShortClose)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Cancel; Rec.Cancel)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                //B2BVCOn17Jun2024 <<
            }
            //B2BPAV<<
            part(indentLine; "Indent Line")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
                // Editable = PageEditable; //B2BSCM21AUG2023
            }
        }
        //B2BSSD30Jan2023<<
        area(FactBoxes)
        {
            systempart(Control1905767507; Notes)//B2BSSD31Jan2023
            {
                ApplicationArea = Notes;
            }
            part(AttachmentDoc; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Provider = indentLine;
                SubPageLink = "Table ID" = CONST(50202),
                "No." = field("Document No."), "Line No." = field("Line No.");
            }
        }
        //B2BSSD30Jan2023>>
    }
    actions
    {
        area(processing)
        {
            //Approval Actions - B2BMSOn09Sep2022>>
            action(Approve)
            {
                ApplicationArea = All;
                Image = Action;
                //  Visible = OpenApprEntrEsists;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ArchiveVersion: Integer;
                begin
                    approvalmngmt.ApproveRecordApprovalRequest(Rec.RecordId());

                    //B2BMSOn13Sep2022>>
                    IndentLine.Reset();
                    IndentLine.SetRange("Document No.", Rec."No.");
                    IndentLine.SetFilter("No.", '<>%1', '');
                    IndentLine.SetFilter("Prev Quantity", '<>%1', 0);
                    if IndentLine.FindFirst() then
                        if IndentLine."Req.Quantity" <> IndentLine."Prev Quantity" then begin
                            Clear(ArchiveVersion);
                            ArchiveIndHdr.Reset();
                            ArchiveIndHdr.SetCurrentKey("Archived Version");
                            ArchiveIndHdr.SetRange("No.", Rec."No.");
                            if ArchiveIndLine.FindLast() then
                                ArchiveVersion := ArchiveIndLine."Archived Version" + 1
                            else
                                ArchiveVersion := 1;

                            ArchiveIndHdr.Init();
                            ArchiveIndHdr.TransferFields(Rec);
                            ArchiveIndHdr."Archived Version" := ArchiveVersion;
                            ArchiveIndHdr."Archived By" := UserId;
                            ArchiveIndHdr.Insert();

                            IndentLine.Reset();
                            IndentLine.SetRange("Document No.", Rec."No.");
                            if IndentLine.FindSet() then
                                repeat
                                    ArchiveIndLine.Init();
                                    ArchiveIndLine.TransferFields(IndentLine);
                                    if IndentLine."Prev Quantity" <> 0 then
                                        ArchiveIndLine."Req.Quantity" := IndentLine."Prev Quantity";
                                    ArchiveIndLine."Archived Version" := ArchiveVersion;
                                    ArchiveIndLine."Archived By" := UserId;
                                    ArchiveIndLine.Insert();

                                    IndentLine."Prev Quantity" := 0;
                                    IndentLine.Modify();
                                until IndentLine.Next() = 0;
                        end;
                    //B2BMSOn13Sep2022<<
                end;
            }

            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Reject the approval request.';
                //   Visible = OpenAppEntrExistsForCurrUser;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                end;
            }
            action(Delegate)
            {
                ApplicationArea = All;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = OpenAppEntrExistsForCurrUser;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                // Visible = (Not OpenApprEntrEsists);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ItemVariantLRec: Record "Item Variant";
                    UserSetup: Record "User Setup";
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                    Recipiants: List of [Text];
                    Body: Text;
                    Text001: Label 'Please find Indent Number: %1 dt.%2 is raised for the purpose %3 is waiting for your approval.  Please approve the same.';
                    Sub: Label 'Request for Indent Approval';
                    ApprovalEntryLRec: Record "Approval Entry";
                begin
                    Rec.TESTFIELD("Released Status", Rec."Released Status"::Open);
                    Rec.TESTFIELD(Indentor);
                    Rec.TestField("Shortcut Dimension 1 Code");
                    Rec.TestField("Shortcut Dimension 2 Code");
                    Rec.TestField(Purpose);
                    Rec.LOCKTABLE;
                    IndentLine.RESET;
                    IndentLine.SETRANGE("Document No.", Rec."No.");
                    IF IndentLine.FINDSET THEN
                        REPEAT
                            IF IndentLine.Type <> IndentLine.Type::Description THEN BEGIN
                                IndentLine.TESTFIELD(IndentLine."No.");
                                IndentLine.TESTFIELD(IndentLine."Req.Quantity");
                            END;
                            //B2BMSOn27Oct2022>>
                            if IndentLine."Qty To Issue" <> 0 then begin
                                IndentLine.TestField("Issue Location");
                                IndentLine.TestField("Issue Sub Location");
                            end;
                            //B2BSSD12APR2023>>
                            if IndentLine.Type = IndentLine.Type::Item then
                                //IndentLine.TestField("Variant Code")
                             if IndentLine."Variant Code" = '' then begin
                                    ItemVariantLRec.Reset();
                                    ItemVariantLRec.SetRange("Item No.", IndentLine."No.");
                                    if ItemVariantLRec.FindFirst() then
                                        Error('Variant Code must not be empty as variants are defined against to the item - %1 in Line No. - %2.',
                                             IndentLine."No.", IndentLine."Line No.")
                                end
                                else
                                    if IndentLine.Type = IndentLine.Type::"Fixed Assets" then
                                        IndentLine.TestField("Variant Code");
                        //B2BSSD12APR2023<<

                        //B2BMSOn27Oct2022<<
                        UNTIL IndentLine.NEXT = 0;
                    IF allinoneCU.CheckIndentDocApprovalsWorkflowEnabled(Rec) then
                        allinoneCU.OnSendIndentDocForApproval(Rec);
                    ApprovalEntryLRec.Reset();
                    ApprovalEntryLRec.SetRange("Document No.", Rec."No.");
                    ApprovalEntryLRec.SetRange(Status, ApprovalEntryLRec.Status::Open);
                    if ApprovalEntryLRec.FindFirst() then begin
                        UserSetup.Get(ApprovalEntryLRec."Approver ID");
                        UserSetup.TestField("E-Mail");
                        Recipiants.Add(UserSetup."E-Mail");
                        Body += StrSubstNo(Text001, Rec."No.", Rec."Document Date", Rec.Purpose);
                        EmailMessage.Create(Recipiants, Sub, '', true);
                        EmailMessage.AppendToBody('Dear Sir/Madam,');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody(Body);
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('This is auto generated mail by system for approval information.');
                        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                        Message('Email Send Successfully');
                    end;

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
                    allinoneCU.OnCancelIndentDocForApproval(Rec);
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
            //Approval Actions Variables - B2BMSOn09Sep2022<<
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = true;
                action("Archive Document")
                {
                    ApplicationArea = All;
                    Image = Archive;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        ArchiveVersion: Integer;
                    begin
                        ArchiveIndHdr.Reset();
                        ArchiveIndHdr.SetCurrentKey("Archived Version");
                        ArchiveIndHdr.SetRange("No.", Rec."No.");
                        if ArchiveIndHdr.FindLast() then
                            ArchiveVersion := ArchiveIndHdr."Archived Version" + 1
                        else
                            ArchiveVersion := 1;

                        ArchiveIndHdr.Init();
                        ArchiveIndHdr.TransferFields(Rec);
                        ArchiveIndHdr."Archived Version" := ArchiveVersion;
                        ArchiveIndHdr."Archived By" := UserId;
                        ArchiveIndHdr.Insert();

                        IndentLine.Reset();
                        IndentLine.SetRange("Document No.", Rec."No.");
                        if IndentLine.FindSet() then
                            repeat
                                IndentLine.CalcFields("Qty Issued");
                                ArchiveIndLine.Init();
                                ArchiveIndLine.TransferFields(IndentLine);
                                ArchiveIndLine."Archived Version" := ArchiveVersion;
                                ArchiveIndLine."Archived By" := UserId;
                                ArchiveIndLine.Insert();
                            until IndentLine.Next() = 0;
                        Message('Archived Document %1', Rec."No.");
                    end;
                }
                group(MaterialIssue)
                {
                    Caption = 'Material Issue/Return';
                    action("Create Issue Jounal Batch")
                    {
                        ApplicationArea = all;
                        Caption = 'Material Issue';
                        image = CreateLinesFromJob;
                        Promoted = true;
                        //PromotedIsBig = true;
                        PromotedCategory = Process;
                        trigger OnAction();
                        var
                            IndentError001: TextConst ENN = 'Select Must Have a Value';
                            IndentLineRec: Record "Indent Line";
                            Text0001: Label 'Quantity to  issue should not be greaterthan Required Quantity %1  for Line No. %2';
                            QtyIssued: Decimal;

                        begin

                            IndentLineRec.Reset();
                            IndentLineRec.SetRange("Document No.", rec."No.");
                            if IndentLineRec.FindSet() then begin
                                repeat
                                    QtyIssued := abs(IndentLineRec."Qty Issued");
                                    IndentLineRec.CalcFields("Qty Issued");
                                    if QtyIssued > IndentLineRec."Req.Quantity" then
                                        Error(Text0001, IndentLineRec."Qty Issued", IndentLineRec."Line No.");

                                    IF IndentLineRec."Req.Quantity" <= QtyIssued then
                                        Error(Text0001, IndentLineRec."Qty Issued", IndentLineRec."Line No.");

                                until IndentLineRec.Next() = 0;
                            end;
                            MaterialIssue();//B2BSCM23AUG2023
                            Rec.TestField("Released Status", Rec."Released Status"::Released);
                            IndentLineRec.SETCURRENTKEY("Document No.", "Line No.");
                            IndentLineRec.RESET();
                            IndentLineRec.SETRANGE("Document No.", Rec."No.");
                            // IndentLineRec.SetRange(Select, true);//B2BSCM23AUG2023
                            if not IndentLineRec.FINDFIRST() then
                                ERROR('No Line with Qty. to Issue > 0');

                            Rec.CreateItemJnlLine();//B2BSSD04JUL2023
                            rec."Material Issued" := true;
                            CurrPage.Update();
                            CurrPage.indentLine.Page.QTyToIssueNonEditable();


                        end;
                    }
                    action("Create Return Jnl. Batch")
                    {
                        ApplicationArea = all;
                        Caption = 'Material Return';
                        Promoted = true;
                        //PromotedIsBig = true;
                        PromotedCategory = Process;
                        image = Return;
                        trigger OnAction();
                        begin
                            MaterialIssueReturn();//B2BSCM23AUG202
                            Rec.TestField("Released Status", Rec."Released Status"::Released);
                            IndentLineRec.Reset();
                            IndentLineRec.SETRANGE("Document No.", Rec."No.");
                            IndentLineRec.SETFILTER("Req.Quantity", '<>%1', 0);
                            if IndentLineRec.FIND('-') then
                                Rec.CreateReturnItemJnlLine(IndentLineRec)//B2BSSD04JUL2023
                            else
                                Error('Please check value in Qty. to Return field. It should not be empty and atleast have in one line.');
                            CurrPage.Update();
                        end;
                    }
                }
                action(ShowItemJournalIssue)
                {
                    ApplicationArea = ALL;
                    Caption = 'Show Item Journal Issue';
                    Image = ShowList;
                    PromotedCategory = Category4;
                    Promoted = true;
                    trigger onaction()
                    var
                        ItemJournalLine: Record "Item Journal Line";
                        ItemJournal: Page "Item Journal";
                        PurchaseSetup: Record "Purchases & Payables Setup";
                        IndentLine: Record "Indent Line";
                        ArchiveIndHdr1: Record "Archive Indent Header";
                        ArchiveVersion: Integer;
                        text0001: Label 'Cannot Reopen the indent if the status is Cancel/Closed.';
                    BEGIN
                        Rec.TestField("Released Status", Rec."Released Status"::Released);
                        PurchaseSetup.Get();
                        ItemJournalLine.reset;
                        ItemJournalLine.SetRange("Journal Template Name", PurchaseSetup."Indent Issue Jnl. Template");
                        ItemJournalLine.SetRange("Journal Batch Name", PurchaseSetup."Indent Issue Jnl. Batch");
                        ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
                        ItemJournalLine.SetRange("Indent No.", Rec."No.");
                        IF ItemJournalLine.findset then;
                        Page.RunModal(40, ItemJournalLine);



                        Rec."Material Issued" := false;
                        //CurrPage.UPDATE

                        //B2BPGOn6Nov23>>>>



                    end;

                }

                action(ShowItemJournalBatchReturn)
                {
                    ApplicationArea = ALL;
                    Caption = 'Show ItemJournal Batch Return';
                    Image = ShowList;
                    PromotedCategory = Category4;
                    Promoted = true;
                    trigger onaction()
                    var
                        ItemJournalLine: Record "Item Journal Line";
                        ItemJournal: Page "Item Journal";
                        PurchaseSetup: Record "Purchases & Payables Setup";
                    BEGIN
                        Rec.TestField("Released Status", Rec."Released Status"::Released);
                        PurchaseSetup.Get();
                        ItemJournalLine.reset;
                        ItemJournalLine.SetRange("Journal Template Name", PurchaseSetup."Indent Return Jnl. Template");
                        ItemJournalLine.SetRange("Journal Batch Name", PurchaseSetup."Indent Return Jnl. Batch");
                        ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                        ItemJournalLine.SetRange("Indent No.", Rec."No.");
                        IF ItemJournalLine.findset then;
                        Page.RunModal(40, ItemJournalLine);
                    END;
                }
                //B2BMSOn13Sep2022>>
                action("Generate Transfer")
                {
                    Visible = false;
                    Image = TransferOrder;
                    Applicationarea = all;
                    trigger OnAction()
                    begin
                        Rec.TestField("Released Status", Rec."Released Status"::Released);
                        Rec.CreateTransferOrder();
                    end;
                }
                action("Copy BOM Lines")
                {
                    ApplicationArea = All;
                    Visible = false; //B2BMSOn27Oct2022

                    trigger OnAction();
                    var
                        BOMLineR: Report "Quant Explo of BOM In Indent";
                    begin
                        IF rec."No." = '' then
                            rec.TestField(Rec."No.");
                        BOMLineR.GetInden(rec."No.");
                        BOMLineR.Run();
                    end;
                }
                action("Copy Indent")
                {
                    Caption = 'Copy Indent';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        Rec.TestField("Released Status", Rec."Released Status"::Open);
                        Rec.CopyIndent;
                    end;
                }
                separator("Approvals")
                {
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RelError: Label 'This document is enabled for workflow. Manual release is not possible.';
                        ItemVariantLRec: Record "Item Variant";
                        IndentLine: Record "Indent Line";
                        Techspec: Record "Technical Specifications";
                    begin
                        Rec.TestField("Shortcut Dimension 1 Code");
                        Rec.TestField("Shortcut Dimension 2 Code");
                        Rec.TestField("Shortcut Dimension 9 Code");
                        Rec.TestField(Purpose);
                        //B2BMSOn13Sep2022>>
                        IF allinoneCU.ISIndentDocworkflowenabled(Rec) then
                            Error(RelError);
                        //B2BMSOn13Sep2022<<
                        Rec.TESTFIELD("Document Date");

                        IndentLine.Reset();//B2BSSD02AUG2023
                        IndentLine.SetRange("Document No.", Rec."No.");
                        if IndentLine.FindSet() then begin
                            repeat
                                IndentLine.TestField("Unit of Measure");
                                IndentLine.TestField("Issue Location"); //B2BVCOn01Feb2024
                                IndentLine.TestField("Issue Sub Location"); //B2BVCOn01Feb2024
                            until IndentLine.Next() = 0;
                        end;

                        IndentLine.Reset();
                        IndentLine.SETRANGE("Document No.", Rec."No.");
                        IF IndentLine.FIND('-') THEN begin
                            repeat
                                //B2BMSOn27Oct2022>>
                                if IndentLine."Qty To Issue" <> 0 then begin
                                    IndentLine.TestField("Issue Sub Location");
                                    IndentLine.TestField("Issue Location");
                                end;
                                //B2BMSOn27Oct2022<<
                                //B2BMSOn01Nov2022>>
                                if IndentLine."Variant Code" = '' then begin
                                    ItemVariantLRec.Reset();
                                    ItemVariantLRec.SetRange("Item No.", IndentLine."No.");
                                    if ItemVariantLRec.FindFirst() then
                                        Error('Variant Code must not be empty as variants are defined against to the item - %1 in Line No. - %2.',
                                             IndentLine."No.", IndentLine."Line No.");
                                end;
                            //B2BMSOn01Nov2022
                            until IndentLine.Next() = 0;
                            Rec.ReleaseIndent
                        end ELSE
                            MESSAGE(Text001, Rec."No.");
                        CurrPage.UPDATE;
                    end;

                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        text000: Label 'Cannot Reopen the indent if the status is Cancel/Closed.';
                        ArchiveVersion: Integer;
                    begin
                        //B2BSSD29MAY2023
                        IndentHeader.Reset();
                        IndentHeader.SetRange("No.", Rec."No.");
                        if IndentHeader.FindFirst() then begin
                            if IndentHeader."Released Status" = IndentHeader."Released Status"::Released then begin
                                IndentHeader.TestField("Ammendent Comments");
                            end;
                        end;
                        //B2BSSD29MAY2023
                        IF NOT (Rec."Indent Status" = Rec."Indent Status"::Close) OR (Rec."Indent Status" = Rec."Indent Status"::Cancel) THEN BEGIN
                            //B2BMSOn02Nov2022>>
                            ArchiveIndHdr.Reset();
                            ArchiveIndHdr.SetCurrentKey("Archived Version");
                            ArchiveIndHdr.SetRange("No.", Rec."No.");
                            if ArchiveIndHdr.FindLast() then
                                ArchiveVersion := ArchiveIndHdr."Archived Version" + 1
                            else
                                ArchiveVersion := 1;

                            ArchiveIndHdr.Init();
                            ArchiveIndHdr.TransferFields(Rec);
                            ArchiveIndHdr."Archived Version" := ArchiveVersion;
                            ArchiveIndHdr."Archived By" := UserId;
                            ArchiveIndHdr.Insert();

                            IndentLine.Reset();
                            IndentLine.SetRange("Document No.", Rec."No.");
                            if IndentLine.FindSet() then
                                repeat
                                    ArchiveIndLine.Init();
                                    ArchiveIndLine.TransferFields(IndentLine);
                                    ArchiveIndLine."Archived Version" := ArchiveVersion;
                                    ArchiveIndLine."Archived By" := UserId;
                                    ArchiveIndLine.Insert();
                                until IndentLine.Next() = 0;
                            Message('Document Archived %1', Rec."No.");
                            //B2BMSOn02Nov2022<<
                            Rec.ReopenIndent;
                            Rec."Ammendent Comments" := '';//B2BSSD28JUN2023
                            CurrPage.UPDATE;
                        END ELSE
                            MESSAGE(text000);
                    end;
                }
                action("Ca&ncel")
                {
                    Caption = 'Ca&ncel';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //IF NOT ("Indent Status" ="Indent Status"::Closed) THEN BEGIN
                        Rec.CancelIndent;
                        CurrPage.UPDATE;
                        //END;
                    end;
                }
                action("Clo&se")
                {
                    Caption = 'Clo&se';
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //IF NOT ("Indent Status" ="Indent Status"::Cancel) THEN BEGIN
                        Rec.CloseIndent;
                        CurrPage.UPDATE;
                        //END;
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IndentHeader.SETRANGE(IndentHeader."No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::Indent, TRUE, TRUE, IndentHeader);
                end;
            }
            action("PrintMaterialIssue")
            {
                Caption = 'Print Material Issues';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IndentHeader.SETRANGE(IndentHeader."No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Material Issue Slip", TRUE, false, IndentHeader);
                end;
            }
            //B2BVCOn17Jun2024 >>
            action("Short Close")
            {
                Caption = 'ShortClose';
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    ShortcloseIndentHdr();
                end;
            }
            action("Cancel Indent")
            {
                Caption = 'Cancel';
                Ellipsis = true;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CancelIndentDoc();
                end;
            }
            //B2BVCOn17Jun2024 <<

        }
    }

    local procedure ShortcloseIndentHdr()
    var
        ConfirmText: Label 'Do you want to Short Close the Indent Document No. %1 ?';
        NotApplicableErr: Label 'Req. Qty and Qty Issued should not be same for Line %1';
        SuccessMsg: Label 'Indent Document No. %1 is Short Closed';
        AlredyShortClosed: Label 'Indent Document No.  %1 is already Short Closed';
        ShortClosed: Boolean;
        IndentLine: Record "Indent Line";
    begin
        if Rec.ShortClose then
            Error(AlredyShortClosed, Rec."No.");
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."No.");
        IndentLine.SetFilter("No.", '<>%1', '');
        IndentLine.SetFilter("Req.Quantity", '<>%1', 0);
        //IndentLine.SetRange(ShortClose, false);
        if IndentLine.FindSet() then
            repeat
                IndentLine.CalcFields("Qty Issued");
                IndentLine.TestField("Qty Issued");
                if IndentLine."Req.Quantity" = Abs(IndentLine."Qty Issued") then
                    Error(NotApplicableErr, IndentLine."Line No.");
            until IndentLine.Next = 0;
        if not Confirm(StrSubstNo(ConfirmText, Rec."No."), false) then
            exit;

        Clear(ShortClosed);
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."No.");
        IndentLine.SetFilter("No.", '<>%1', '');
        IndentLine.SetFilter("Req.Quantity", '<>%1', 0);
        //IndentLine.SetRange(ShortClose, false);
        if IndentLine.FindSet() then
            repeat
                IndentLine.ShortClose := true;
                if IndentLine."ShortClose Status" = IndentLine."ShortClose Status"::" " then
                    IndentLine."ShortClose Status" := IndentLine."ShortClose Status"::ShortClosed;
                IndentLine.CalcFields("Qty Issued");
                IndentLine."ShortClose Qty" := IndentLine."Req.Quantity" - Abs(IndentLine."Qty Issued");
                IndentLine."Req.Quantity" := Abs(IndentLine."Qty Issued");
                IndentLine."ShortClosed By" := UserId;
                IndentLine."ShortClose Date & Time" := CurrentDateTime;
                ShortClosed := true;
                IndentLine.Modify();
            until IndentLine.Next = 0;
        if ShortClosed then begin
            Rec.ShortClose := true;
            if Rec."ShortClose Status" = Rec."ShortClose Status"::" " then
                Rec."ShortClose Status" := Rec."ShortClose Status"::ShortClose;
            Rec.Modify();
        end;
        if Rec.ShortClose then
            Message(SuccessMsg, Rec."No.");

    end;

    local procedure CancelIndentDoc()
    var
        ConfirmText: Label 'Do you want to Cancelled the Indent Document No. %1 ?';
        AlredyCancelledOrder: Label 'Indent Document No.  %1 is already Cancelled';
        SuccessMsg: Label 'Indent Document No. %1 is Cancelled';
        ErrorMsg: Label 'Qty Issued Must be Zero, Document No. %1, Line No. %2';
        CancelOrder: Boolean;
        IndentLine: Record "Indent Line";
    begin
        if Rec.Cancel then
            Error(AlredyCancelledOrder, Rec."No.");
        if not Confirm(StrSubstNo(ConfirmText, Rec."No."), false) then
            exit;

        Clear(CancelOrder);
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."No.");
        IndentLine.SetFilter("No.", '<>%1', '');
        IndentLine.SetFilter("Req.Quantity", '<>%1', 0);
        //IndentLine.SetRange(CancelIndent, false);
        if IndentLine.FindSet() then
            repeat
                IndentLine.CalcFields("Qty Issued");
                if Abs(IndentLine."Qty Issued") <> 0 then
                    Error(ErrorMsg, IndentLine."Document No.", IndentLine."Line No.");
                if Abs(IndentLine."Qty Issued") = 0 then begin
                    IndentLine.CancelIndent := true;
                    if IndentLine."ShortClose Status" = IndentLine."ShortClose Status"::" " then
                        IndentLine."ShortClose Status" := IndentLine."ShortClose Status"::Cancelled;
                    if IndentLine.CancelIndent then
                        CancelOrder := true;
                    IndentLine.Modify();
                end;
            until IndentLine.Next = 0;
        if CancelOrder then begin
            Rec.Cancel := true;
            if Rec."ShortClose Status" = Rec."ShortClose Status"::" " then
                Rec."ShortClose Status" := Rec."ShortClose Status"::Cancel;
            Rec.Modify;
        end;
        if Rec.Cancel then
            Message(SuccessMsg, Rec, "No.");

    end;

    trigger OnAfterGetRecord();
    begin
        //Approval visible conditions - B2BMSOn09Sep2022>>
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(Rec.RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(Rec.RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
        //Approval visible conditions - B2BMSOn09Sep2022<<

        //B2BPGON10OCT2022
        if (Rec."Released Status" = Rec."Released Status"::Released) then
            PageEditable := false
        else
            PageEditable := true;
        //CurrPage.indentLine.Page.QTyToIssueNonEditable();
    end;
    //B2BVCOn28Sep22>>>
    trigger OnOpenPage()
    begin
        /*if (Rec."Released Status" = Rec."Released Status"::Released) then
            PageEditable := false
        else
            PageEditable := true;*/ //B2BPGON10OCT2022
    end;
    //B2BVCOn28Sep22>>>



    var
        IndentLine: Record "Indent Line";
        IndentHeader: Record "Indent Header";
        //B2BMSOn13Sep2022>>
        ArchiveIndHdr: Record "Archive Indent Header";
        ArchiveIndLine: record "Archive Indent Line";
        //B2BMSOn13Sep2022<<
        Text000: Label 'Do you want Convert to Quote?';
        Text001: Label 'There Is Nothing to Release for Indent %1';
        Text13002: Label 'The Order Is Authorized, You Cannot Resend For Authorization';
        Text13003: Label 'You Cannot Resend For Authorization';
        Text13004: Label 'This Order Has been Rejected. Please Create A New Order.';
        Text13700: Label 'You have %1 new Task(s).';
        Text13000: Label 'No Setup exists for this Amount.';
        Text13001: Label 'Do you want to send the order for Authorization?';
        Text13702: Label 'for your approval';
        Text13703: Label '"You have received the undermentioned document for authorisation: "';
        Text13704: Label '"Document Type: Purchase  "';
        Text13718: Label '"Not Authorised "';
        Text13719: Label '"To: "';
        Text13720: Label 'The undermentioned document has been RETURNED WITHOUT BEING AUTHORISED';
        Text13721: Label 'since the authorised signatory';
        Text13722: Label '"has not seen the document in the time specified. "';
        Text13723: Label '"You are requested to kindly resend the same for authorisation or forward it to "';
        Text13724: Label '"another authorised signatory. "';
        Text13725: Label 'No Body Is Responding to the mails.';
        Text13726: Label 'Approved';
        Text13727: Label '"The undermentioned document has been  APPROVED "';
        Text13728: Label 'You are requested to kindly proceed with subsequent processes and ensure prompt closure of this document.';
        Text13729: Label 'Rejected';
        Text13730: Label '"The undermentioned document has been REJECTED. "';
        Text13731: Label 'You are requested to kindly refer to the comments on the document to know the reason  for this document not being approved and take necessary action.';
        Text13705: Label '"Document No.: "';
        Text13706: Label 'Document Date:';
        Text13707: Label '"Vendor Name : "';
        Text13708: Label '"You are requested to verify and authorise the above document at the earliest. "';
        Text13709: Label '"Thank you, "';
        Text13710: Label '"From:  "';
        WFIndentLine: Record "Quotation Comparison";
        Company: Record 79;
        PurchSetup: Record 312;
        WFAmount: Decimal;
        IsValid: Boolean;
        UserSetup: Record 91;
        I: Integer;
        Link: Text[1000];
        FileName: Text[250];
        Context: Text[1000];
        File1: File;
        HideDialog: Boolean;
        ErrorNo: Integer;
        EntryNo: Integer;
        User: Record 2000000120;
        Indent: Page 50024;
        WFPurchLine: Record 39;
        IndentLineRec: Record "Indent Line";
        //Approval Actions Variables - B2BMSOn09Sep2022>>
        approvalmngmt: Codeunit "Approvals Mgmt.";
        allinoneCU: Codeunit "Approvals MGt 4";
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";
        WorkflowManagement: Codeunit "Workflow Management";
        OpenAppEntrExistsForCurrUser: Boolean;
        OpenApprEntrEsists: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;
        CanrequestApprovForFlow: Boolean;
        //Approval Actions Variables - B2BMSOn09Sep2022<<
        PageEditable: Boolean;//B2BVCOn28Sep22
        IndentLineGvar: Record "Indent Line";

}

