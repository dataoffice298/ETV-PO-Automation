page 50175 "Transfer Indent Header"
{
    // version PH1.0,PO1.0,REP1.0

    PageType = ListPlus;
    SourceTable = "Indent Header";
    Caption = 'CAM REQUEST';
    SourceTableView = where("Indent Transfer" = const(true));


    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = PageEditable; //B2BPGON10OCT2022
                Caption = 'General';
                field("No."; rec."No.")
                {
                    AssistEdit = true;
                    //Editable = PageEditable;//B2BVCOn28Sep22
                    ApplicationArea = All;
                    trigger OnAssistEdit();
                    begin

                        if "Indent Transfer" = false then begin
                            IF rec.AssistEdit(Rec) THEN
                                CurrPage.UPDATE;
                        end;

                        if "Indent Transfer" = true then begin
                            IF rec.AssistEditTransferINd(Rec) THEN
                                CurrPage.UPDATE;
                        end;
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    //Editable = PageEditable;//B2BVCOn28Sep22

                }
                field(Indentor; rec.Indentor)
                {
                    Caption = 'Indentor';
                    ApplicationArea = all;
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                field(Department; rec.Department)
                {
                    Visible = false;
                    ApplicationArea = all;
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("Document Date"; rec."Document Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                    //Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("Released Status"; rec."Released Status")
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                    //Editable = false;//B2BVCOn28Sep22

                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = all;
                    //Editable = PageEditable;//B2BVCOn28Sep22

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
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("Ammendent Comments"; Rec."Ammendent Comments")
                {
                    ApplicationArea = All;
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                //B2BMSOn13Sep2022<<

                // >> B2BPAV 
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 1 Code';
                    //Editable =  PageEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")//B2BSSD16MAR2023
                {
                    ApplicationArea = All;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = Location;
                    //Editable = (Status = Status::Open) AND EnableTransferFields;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that items are transferred from.';
                    // Editable = PageEditable;//B2BVCOn28Sep22

                    //B2BMSOn27Oct2022>>
                    trigger OnValidate()
                    var
                        Userwisesetup: Codeunit UserWiseSecuritySetup;
                    begin
                        UpdateIndentLineLocation();
                        if (Rec."Transfer-from Code" <> '') and (Rec."Transfer-to Code" <> '') then begin
                            if Rec."Transfer-from Code" = Rec."Transfer-to Code" then
                                Error('Transfer-From and Transfer-To Codes must not be the same.');
                        end;

                    end;
                    //B2BMSOn27Oct2022<<
                }
                field("Sub Location code"; "Sub Location code")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        UpdateIndentLineLocation();
                    end;
                }
                field("Physical Location"; "Physical Location")
                {
                    ApplicationArea = all;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = Location;
                    // Editable = (Status = Status::Open) AND EnableTransferFields;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                    //Editable = PageEditable;//B2BVCOn28Sep22

                    //B2BMSOn27Oct2022>>
                    /*trigger OnValidate()
                    begin
                        if (Rec."Transfer-from Code" <> '') and (Rec."Transfer-to Code" <> '') then begin
                            if Rec."Transfer-from Code" = Rec."Transfer-to Code" then
                                Error('Transfer-From and Transfer-To Codes must not be the same.');
                        end;
                    end;*/
                    //B2BMSOn27Oct2022<<

                }
                field("FA Sub Location code"; "FA Sub Location code")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        ab: Code[50];
                        cd: Code[50];
                    begin
                        ab := CopyStr(format("Transfer-from Code") + Format("Sub Location code"), 1, 50);

                        cd := CopyStr(format("Transfer-to Code") + Format("FA Sub Location code"), 1, 50);
                        if ab = cd then
                            error('FA Location & FA Sub location must not be same as transfer from location & sublocation');

                    end;
                }
                field("FA Physical Location"; "FA Physical Location")
                {
                    ApplicationArea = all;
                }


                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = Location;
                    // Editable = EnableTransferFields;
                    // Enabled = (NOT "Direct Transfer") AND (Status = Status::Open);
                    ToolTip = 'Specifies the in-transit code for the transfer order, such as a shipping agent.';
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("programme Name"; Rec."programme Name")//B2BSSD20MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'programme Name';
                }
                field(Purpose; Rec.Purpose)//B2BSSD23MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'Purpose';
                }
                /*   field(Post; Post)
                  {
                      ApplicationArea = all;
                  } */
            }
            //B2BPAV<<
            part(TransferindentLine; "Transfer Indent Line")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
                Editable = PageEditable;//B2BVCOn28Sep22
            }
        }

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
                Visible = OpenApprEntrEsists;
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
                Visible = OpenAppEntrExistsForCurrUser;

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
                Visible = (Not OpenApprEntrEsists);
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    Rec.TESTFIELD("Released Status", Rec."Released Status"::Open);
                    Rec.TESTFIELD(Indentor);
                    Rec.TestField("Shortcut Dimension 1 Code");
                    Rec.TestField("Shortcut Dimension 2 Code");
                    Rec.TestField("Shortcut Dimension 9 Code");//B2BSSD23MAR2023
                    Rec.LOCKTABLE;
                    IndentLine.RESET;
                    IndentLine.SETRANGE("Document No.", Rec."No.");
                    IF IndentLine.FINDSET THEN
                        REPEAT
                            IF IndentLine.Type <> IndentLine.Type::Description THEN BEGIN
                                IndentLine.TESTFIELD(IndentLine."No.");
                                IndentLine.TESTFIELD(IndentLine."Req.Quantity");
                            END;
                        UNTIL IndentLine.NEXT = 0;
                    IF allinoneCU.CheckIndentDocApprovalsWorkflowEnabled(Rec) then
                        allinoneCU.OnSendIndentDocForApproval(Rec);

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
                                ArchiveIndLine.Init();
                                ArchiveIndLine.TransferFields(IndentLine);
                                ArchiveIndLine."Archived Version" := ArchiveVersion;
                                ArchiveIndLine."Archived By" := UserId;
                                ArchiveIndLine.Insert();
                            until IndentLine.Next() = 0;
                        Message('Archived Document %1', Rec."No.");
                    end;
                }
                action("Create Issue Jounal Batch")
                {
                    ApplicationArea = all;
                    Caption = 'Create Issue Jounal Batch';
                    image = CreateLinesFromJob;
                    Visible = false;//BaluOn19Oct2022
                    trigger OnAction();
                    begin
                        Rec.TestField("Released Status", Rec."Released Status"::Released);
                        IndentLineRec.SETCURRENTKEY("Document No.", "Line No.");
                        IndentLineRec.RESET();
                        IndentLineRec.SETRANGE("Document No.", Rec."No.");
                        if not IndentLineRec.FINDFIRST() then
                            ERROR('No Line with Qty. to Issue > 0');
                        Rec.CreateItemJnlLine();
                        CurrPage.Update();
                    end;
                }
                action("Create Return Jnl. Batch")
                {
                    Visible = false;//BaluOn19Oct2022
                    ApplicationArea = all;
                    Caption = 'Create Return Jnl. Batch';
                    image = Create;
                    trigger OnAction();
                    begin
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
                action(ShowItemJournalIssue)
                {
                    Visible = false;//BaluOn19Oct2022
                    ApplicationArea = ALL;
                    Caption = 'Show Item Journal Issue';
                    Image = ShowList;
                    trigger onaction()
                    var
                        ItemJournalLine: Record "Item Journal Line";
                        ItemJournal: Page "Item Journal";
                        PurchaseSetup: Record "Purchases & Payables Setup";
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
                    END;
                }

                action(ShowItemJournalBatchReturn)
                {
                    Visible = false;//BaluOn19Oct2022
                    ApplicationArea = ALL;
                    Caption = 'Show ItemJournal Batch Return';
                    Image = ShowList;
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
                    //Visible = false;
                    Image = TransferOrder;
                    Applicationarea = all;
                    trigger OnAction()
                    begin
                        Rec.TestField("Released Status", Rec."Released Status"::Released);
                        Rec.CreateTransferOrder();
                    end;
                }
                action(FaPost)
                {
                    Caption = 'POST';
                    ApplicationArea = All;
                    Image = Post;

                    trigger OnAction()
                    var
                        Text003: Label 'Do you want to post the Indent?';
                        Fa: Record "Fixed Asset";

                        transfeIndentLine: Record "Indent Line";
                        errorlbl: Label 'Type must be equal to Fixed Asset in Indent Line: Document No.=%1, Line No.=%2';

                    begin
                        rec.TestField("Released Status");
                        rec.TestField("FA Physical Location");
                        rec.TestField("FA Sub Location code");
                        rec.TestField("Physical Location");
                        rec.TestField("Sub Location code");
                        IF NOT CONFIRM(Text003) THEN
                            EXIT;

                        transfeIndentLine.Reset();
                        transfeIndentLine.SetRange("Document No.", rec."No.");
                        if transfeIndentLine.FindSet() then begin
                            repeat
                                if not (transfeIndentLine.type = transfeIndentLine.Type::"Fixed Assets") then
                                    Error(errorlbl, transfeIndentLine."Document No.", transfeIndentLine."Line No.");
                                Fa.Reset();
                                Fa.SetRange("No.", transfeIndentLine."No.");
                                if Fa.FindFirst() then begin
                                    Fa."FA Location Code" := rec."Transfer-to Code";
                                    fa."FA Sub Location" := rec."FA Sub Location code";
                                    fa."Physical-Location" := rec."FA Physical Location";
                                    fa.Modify();

                                end;
                                Post := true;
                                transfeIndentLine.Post := true;
                            until transfeIndentLine.Next() = 0;
                        end;


                    end;
                }

                action("Copy BOM Lines")
                {
                    Visible = false;//BaluOn19Oct2022
                    ApplicationArea = All;

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
                    Image = CopyDocument;//B2BSSD02Jan2023

                    trigger OnAction();
                    var

                    begin
                        Rec.CopyTransforIndent();
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

                    trigger OnAction()
                    var
                        RelError: Label 'This document is enabled for workflow. Manual release is not possible.';
                    begin
                        //B2BMSOn13Sep2022>>
                        IF allinoneCU.ISIndentDocworkflowenabled(Rec) then
                            Error(RelError);
                        //B2BMSOn13Sep2022<<
                        Rec.TESTFIELD("Document Date");
                        IndentLine.SETRANGE("Document No.", Rec."No.");
                        IF IndentLine.FIND('-') THEN
                            Rec.ReleaseIndent
                        ELSE
                            MESSAGE(Text001, Rec."No.");
                        CurrPage.UPDATE;
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        text000: Label 'Cannot Reopen the indent if the status is Cancel/Closed.';
                    begin
                        IF NOT (Rec."Indent Status" = Rec."Indent Status"::Close) OR (Rec."Indent Status" = Rec."Indent Status"::Cancel) THEN BEGIN
                            Rec.ReopenIndent;
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
                Visible = false;//BaluOn19Oct2022
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IndentHeader.SETRANGE(IndentHeader."No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"Material Issue Slip", TRUE, false, IndentHeader);
                end;
            }

        }
    }

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
    //BaluOn19Oct2022>>
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //  rec."Indent Transfer" := true;
        //B2BMSOn27Oct2022>>
        LocationRec.Reset();
        LocationRec.SetRange("Use As In-Transit", true);
        if LocationRec.FindFirst() then
            Rec."In-Transit Code" := LocationRec.Code;
        //B2BMSOn27Oct2022<<
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        myInt: Integer;
    begin
        rec."Indent Transfer" := true;


    end;
    //BaluOn19Oct2022<<

    procedure UpdateIndentLineLocation()
    var
        IndentLine: Record "Indent Line";
    begin
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."No.");
        if IndentLine.FindSet() then
            repeat
                IndentLine."Transfer-from Code" := Rec."Transfer-from Code";
                IndentLine."Sub Location code" := Rec."Sub Location code";
                IndentLine.Modify();
            until IndentLine.Next() = 0;
    end;

    var
        IndentLine: Record "Indent Line";
        IndentHeader: Record "Indent Header";
        LocationRec: Record Location;
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
}

