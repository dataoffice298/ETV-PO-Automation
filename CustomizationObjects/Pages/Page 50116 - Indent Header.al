page 50116 "Indent Header"
{
    // version PH1.0,PO1.0,REP1.0

    PageType = ListPlus;
    SourceTable = "Indent Header";
    Caption = 'Indent Document';
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    AssistEdit = true;
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        // IF rec.AssistEdit(xRec) THEN
                        //     CurrPage.UPDATE;
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field(Indentor; rec.Indentor)
                {
                    Caption = 'Indentor';
                    ApplicationArea = all;
                }
                field(Department; rec.Department)
                {
                    Visible = true;
                    ApplicationArea = all;
                }
                field("Document Date"; rec."Document Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                }
                field("Released Status"; rec."Released Status")
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = all;
                }
                field(Authorized; rec.Authorized)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = Location;
                    //Editable = (Status = Status::Open) AND EnableTransferFields;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that items are transferred from.';
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                    ApplicationArea = Location;
                    // Editable = (Status = Status::Open) AND EnableTransferFields;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                }
            }
            part(indentLine; 50023)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
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
                Visible = Not OpenApprEntrEsists and CanrequestApprovForFlow;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin
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
                action("Create Issue Jounal Batch")
                {
                    ApplicationArea = all;
                    Caption = 'Create Issue Jounal Batch';
                    image = CreateLinesFromJob;
                    trigger OnAction();
                    begin
                        IndentLineRec.SETCURRENTKEY("Document No.", "Line No.");
                        IndentLineRec.RESET();
                        IndentLineRec.SETRANGE("Document No.", "No.");
                        //  IndentLineRec.SETFILTER("Qty. to Issue", '<>%1', 0);
                        if not IndentLineRec.FINDFIRST() then
                            ERROR('No Line with Qty. to Issue > 0');


                        IndentLineRec.RESET();
                        IndentLineRec.SETCURRENTKEY("Document No.", "Line No.");
                        IndentLineRec.SETRANGE("Document No.", "No.");
                        //  IndentLineRec.SETFILTER("Qty. to Issue", '<>%1', 0);
                        if IndentLineRec.FINDSET() then
                            repeat
                                IndentLineRec.CALCFIELDS("Req.Quantity");
                                IndentLineRec.CALCFIELDS("Available Stock");
                            //          IndentLineRec.CALCFIELDS("Quantity Issued");
                            //          if IndentLineRec."Qty. to Issue" > (IndentLineRec.Quantity - IndentLineRec."Quantity Issued") then
                            //              ERROR(Text002Lbl, (IndentLineRec.Quantity - IndentLineRec."Quantity Issued"));
                            until IndentLineRec.NEXT() = 0;
                        CreateItemJnlLine();
                        CurrPage.Update();
                    end;
                }
                action("Create Return Jnl. Batch")
                {
                    ApplicationArea = all;
                    Caption = 'Create Return Jnl. Batch';
                    image = Create;
                    trigger OnAction();
                    begin
                        IndentLineRec.Reset();
                        IndentLineRec.SETRANGE("Document No.", "No.");
                        IndentLineRec.SETFILTER("Req.Quantity", '<>%1', 0);
                        if IndentLineRec.FIND('-') then
                            CreateReturnItemJnlLine()
                        else
                            Error('Please check value in Qty. to Return field. It should not be empty and atleast have in one line.');
                        CurrPage.Update();
                    end;
                }
                action("Copy BOM Lines")
                {
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

                    trigger OnAction();
                    begin
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

                    trigger OnAction();
                    begin
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

        }
    }

    trigger OnAfterGetRecord();
    begin
        //Approval visible conditions - B2BMSOn09Sep2022>>
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
        //Approval visible conditions - B2BMSOn09Sep2022<<
    end;

    var
        IndentLine: Record 50037;
        IndentHeader: Record 50010;
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
        WFIndentLine: Record 50041;
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
        IndentLineRec: Record 50037;
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
}

