page 50120 "Indent Requisition Document"
{
    PageType = Document;
    SourceTable = "Indent Req Header";


    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;

                    trigger OnAssistEdit();
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Resposibility Center"; Rec."Resposibility Center")
                {
                    ApplicationArea = All;
                    //   Editable = FieldEditable;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    //Editable = FieldEditable;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    //B2BKM14MAY2024
                    trigger OnValidate()
                    begin
                        if Rec.Type = Rec.Type then
                            Rec."No.Series" := '';
                    end;
                    //B2BKM14MAY2024
                }
                field("No.Series"; Rec."No.Series")
                {
                    ApplicationArea = All;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = false;
                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEditRFQ(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("RFQ Date"; Rec."RFQ Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RFQ Date field.';
                }
                field("Indent No."; "Indent No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 1 Code';
                    Editable = FieldEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 2 Code';
                    Editable = FieldEditable;
                }
                //B2BSSD17FEB2023<<
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 9 Code';
                    Editable = FieldEditable;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Project Code';
                    Editable = false;
                }
                //B2BSSD17FEB2023>>
                field("programme Name"; Rec."programme Name")//B2BSSD20MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'programme Name';
                }
                field(Purpose; Rec.Purpose)//B2BSSD21MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'Purpose';
                }
                field("Req Status"; Rec."Req Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleTxt;
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                }
                field(Cancel; Rec.Cancel)
                {
                    ApplicationArea = All;
                }
            }
            part(Indentrequisations; 50119)
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        //B2BSSD31Jan2023<<
        area(FactBoxes)
        {
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
            part(AttachmentDoc; "Document Attachment Factbox")
            {
                Editable = false;
                ApplicationArea = All;
                Caption = 'Attachments';
                Provider = Indentrequisations;
                SubPageLink = "Table ID" = CONST(50202),
                             "No." = FIELD("Indent No."), "Line No." = field("Indent Line No.");
            }
        }
        //B2BSSD31Jan2023>>
    }

    actions
    {
        area(processing)
        {
            action("Get Requisition Lines")
            {
                Caption = 'Get Indent Lines';
                ApplicationArea = All;
                Image = GetLines;

                trigger OnAction();
                var
                    IndentReqLine: Record "Indent Requisitions";
                    IndentLineRec: Record "Indent Line";
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    Clear(IndentReqLines);
                    IndentReqLines.GetValue(Rec."No.", Rec."Resposibility Center");
                    IndentReqLines.RUN;


                    IndentReqLine.Reset();
                    IndentReqLine.SetRange("Document No.", Rec."No.");
                    if IndentReqLine.FindSet() then begin
                        repeat
                            IndentLineRec.Reset();
                            IndentLineRec.SetRange("Document No.", IndentReqLine."Indent No.");
                            IndentLineRec.SetRange("Line No.", IndentReqLine."Indent Line No.");
                            if IndentLineRec.FindSet() then begin
                                repeat

                                    IndentLineRec.Status := IndentLineRec.Status::"Indent Requisition";
                                    IndentLineRec.Modify();
                                until IndentLineRec.Next() = 0;
                            end;
                        until IndentReqLine.Next() = 0;
                    end;
                    Message('Lines Inserted Successfully.');
                end;
            }
            action("Create &Enquiry")
            {
                Caption = 'Create &Enquiry';
                ApplicationArea = All;
                Image = Create;
                trigger OnAction();
                var
                    IndentReqLine: Record "Indent Requisitions";
                    IndentLineRec: Record "Indent Line";

                begin
                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Enquiry);
                    Carry := 0;
                    Indentreqline.RESET;
                    Indentreqline.SETRANGE("Document No.", Rec."No.");
                    IF Indentreqline.FIND('-') THEN
                        REPEAT
                            IF Indentreqline."Carry out Action" THEN
                                Carry += 1;
                        UNTIL Indentreqline.NEXT = 0;
                    IF Carry <= 0 THEN
                        ERROR('Carry out action should not be blank');
                    IF Indentreqline.FIND('-') THEN BEGIN
                        IF NOT CONFIRM(Text003) THEN
                            EXIT;
                        CurrPage.Indentrequisations.Page.SetSelectionFilter(CreateIndents);//B2BSSD18APR2023
                        if CreateIndents.Find('-') then
                            repeat
                                if CreateIndents."Remaining Quantity" = 0 then
                                    Error('Purchase Order Already Created,Indent Line No.%1', CreateIndents."Line No.");
                            until CreateIndents.Next = 0;
                        CLEAR(VendorListNew);
                        VendorListNew.LOOKUPMODE(TRUE);
                        IF VendorListNew.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            VendorListNew.SetSelectionFilter(Vendor);
                            Vendor.Reset();
                            Vendor.SetRange(Selected, true);
                            if Vendor.FindSet() then begin
                                POAutomation.CreateEnquiries(CreateIndents, Vendor, Rec."No.Series");
                                Vendor.Reset();
                                Vendor.SetRange(Selected, true);
                                if Vendor.FindSet() then
                                    Vendor.ModifyAll(Selected, false);
                                MESSAGE(Text0010);
                            END ELSE
                                EXIT;
                        END;
                    END;
                end;
            }
            action("Create &Quote")
            {
                Caption = 'Create &Quote';

                ApplicationArea = All;
                Image = NewSalesQuote;
                trigger OnAction();
                var
                    IndentReqLinerec: Record "Indent Requisitions";
                    IndentLineRec: Record "Indent Line";
                begin

                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Quote);
                    Carry := 0;
                    Indentreqline.RESET;
                    Indentreqline.SETRANGE("Document No.", Rec."No.");
                    IF Indentreqline.FIND('-') THEN
                        REPEAT
                            IF Indentreqline."Carry out Action" THEN
                                Carry += 1;
                        UNTIL Indentreqline.NEXT = 0;

                    IF Carry <= 0 THEN
                        ERROR('Carry out action should not be blank');

                    IF Indentreqline.FIND('-') THEN BEGIN
                        IF NOT CONFIRM(Text004) THEN
                            EXIT;
                        CurrPage.Indentrequisations.Page.SetSelectionFilter(CreateIndents);
                        if CreateIndents.Find('-') then
                            repeat
                                if CreateIndents."Remaining Quantity" = 0 then
                                    Error('Purchase Order Already Created,Indent Line No.%1', CreateIndents."Line No.");
                            until CreateIndents.Next = 0;
                        CLEAR(VendorListNew);
                        VendorListNew.LOOKUPMODE(TRUE);
                        IF VendorListNew.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            VendorListNew.SetSelectionFilter(Vendor);
                            Vendor.Reset();
                            Vendor.SetRange(Selected, true);
                            IF Vendor.FindSet() THEN BEGIN
                                POAutomation.CreateQuotes(CreateIndents, Vendor, Rec."No.Series");
                                Vendor.Reset();
                                Vendor.SetRange(Selected, true);
                                if Vendor.FindSet() then
                                    Vendor.ModifyAll(Selected, false);
                                MESSAGE(Text0011);
                            END ELSE
                                EXIT;
                        end;
                    END;
                end;
            }
            action("Purchase Indent Report")//B2Banusha22NOV2024
            {
                Caption = 'Staff Purchase Indent Report';
                ApplicationArea = All;
                Image = Report;
                trigger OnAction()
                var
                    IndentRequestionLinesRec: Record "Indent Requisitions";
                    IndentRequestionspage: page "Indent Requisitions SubForm";
                    IndentReqHeaderRec: Record "Indent Req Header";
                    PurchaseorderReport: Report "Purchase Order Report";
                    PurchaserCodevar: Text;
                    Previouspurchcode, IndentNo : Code[30];
                    DocumentDate: Date;
                begin
                    IndentRequestionLinesRec.Reset();
                    IndentRequestionLinesRec.SetRange("Document No.", Rec."No.");
                    IndentRequestionLinesRec.Setfilter("Purchaser Code", '<>%1', '');
                    IndentRequestionLinesRec.SetCurrentKey("Purchaser Code");
                    IndentRequestionLinesRec.SetAscending("Purchaser Code", true);
                    if IndentRequestionLinesRec.FindSet() then
                        repeat
                            if Previouspurchcode <> IndentRequestionLinesRec."Purchaser Code" then begin
                                Previouspurchcode := IndentRequestionLinesRec."Purchaser Code";
                                if PurchaserCodevar = '' then
                                    PurchaserCodevar := IndentRequestionLinesRec."Purchaser Code"
                                else
                                    PurchaserCodevar := PurchaserCodevar + '|' + IndentRequestionLinesRec."Purchaser Code";
                            end;
                        until IndentRequestionLinesRec.Next() = 0;

                    IndentRequestionLinesRec.Reset();
                    IndentRequestionLinesRec.SetRange("Document No.", Rec."No.");
                    IndentNo := Rec."No.";
                    DocumentDate := Rec."Document Date";

                    Clear(PurchaseorderReport);
                    PurchaseorderReport.SetDocumentDate(DocumentDate, IndentNo);
                    PurchaseorderReport.Setpurchasercode(PurchaserCodevar);
                    PurchaseorderReport.RunModal();
                end;
            }
            action("Create &Purchase Order")
            {
                Caption = 'Create &Purchase Order';
                ApplicationArea = All;
                Image = MakeOrder;
                //   Visible = ShowAct;

                trigger OnAction();
                var
                    IndentReqLine: Record "Indent Requisitions";
                    IndentLineRec: Record "Indent Line";
                    IndentReqLineRec: Record "Indent Requisitions";
                    Count: Integer;
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Release);
                    Rec.TESTFIELD(Type, Rec.Type::Order);
                    Carry := 0;
                    CheckRemainingQuantity;
                    Indentreqline.RESET;
                    Indentreqline.SETRANGE("Document No.", Rec."No.");
                    IF Indentreqline.FIND('-') THEN
                        REPEAT
                            IF Indentreqline."Carry out Action" THEN
                                Carry += 1;
                        UNTIL Indentreqline.NEXT = 0;
                    IF Carry <= 0 THEN
                        ERROR('Carry out action should not be blank');
                    IF Indentreqline.FIND('-') THEN BEGIN
                        IF NOT CONFIRM(Text005) THEN
                            EXIT;
                        CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        CurrPage.Indentrequisations.Page.SetSelectionFilter(CreateIndents);
                        if CreateIndents.Find('-') then
                            repeat
                                //if CreateIndents."Purch Order No." <> '' then
                                if CreateIndents."Remaining Quantity" = 0 then
                                    Error('Purchase Order Already Created,Indent Line No.%1', CreateIndents."Line No.");
                            until CreateIndents.Next = 0;
                        UpdateReqQty;
                        POAutomation.CreateOrder2(CreateIndents, Vendor, Rec."No.Series");
                        MESSAGE(Text001);
                        IndentReqLineRec.Reset();
                        IndentReqLineRec.SetRange("Document No.", Rec."No.");
                        IndentReqLineRec.SetFilter("Purch Order No.", '<>%1', '');
                        if IndentReqLineRec.Find('-') then
                            repeat
                                Count += 1;
                            until IndentReqLineRec.Next = 0;
                        if Count = Carry then begin
                            Rec."Create Purchase Order" := true;
                            CurrPage.Update();
                        end;
                    END;

                    /*  IndentReqLine.Reset();
                      IndentReqLine.SetRange("Document No.", Rec."No.");
                      if IndentReqLine.FindSet() then begin
                          repeat
                              IndentLineRec.Reset();
                              IndentLineRec.SetRange("Document No.", IndentReqLine."Indent No.");
                              IndentLineRec.SetRange("Line No.", IndentReqLine."Indent Line No.");
                              if IndentLineRec.FindSet() then begin
                                  repeat
                                      //    SetSelectionFilter(IndentLineRec);
                                      IndentLineRec.Status := IndentLineRec.Status::Quote;
                                      IndentLineRec.Modify();
                                  until IndentLineRec.Next() = 0;
                              end;
                          until IndentReqLine.Next() = 0;
                      end;*/

                end;
            }

            /*  action("Re&lease")
              {
                  Caption = 'Re&lease';
                  Image = ReleaseDoc;
                  ApplicationArea = All;

                  trigger OnAction();
                  var
                      IndentReqLine: Record "Indent Requisitions";
                      RelText1: Label 'Document released and Moved to Local Indent Requisition List.';
                      RelText2: Label 'Document released and Moved to Central Indent Requisition List.';
                      WorkflowManagement: Codeunit "Workflow Management";
                  begin

                      Rec.TestField("No.Series");
                      Rec.TestField(Status, Rec.Status::Open);
                      IndentReqLine.Reset();
                      IndentReqLine.SetRange("Document No.", Rec."No.");
                      if not IndentReqLine.FindFirst() then begin
                          Error('No Lines Found');
                      end;
                      //B2BSCM20SEP2023>>
                      if IndentReqLine.FindSet() then begin
                          repeat
                              IndentReqLine.TestField("Qty. To Order");
                          until IndentReqLine.Next() = 0;
                      end; //B2BSCM20SEP2023<<
                      Rec.TestField("Resposibility Center");
                      Rec.TESTFIELD("Document Date");


                      Rec.Status := Rec.Status::Release;
                      Rec.MODIFY;
                      if Rec."Resposibility Center" = 'LOCAL REQ' then
                          Message(RelText1);
                      if Rec."Resposibility Center" = 'CENTRL REQ' then
                          Message(RelText2);

                      IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendIndentRequisitionDoc1forApprovalCode()) then
                          error('Workflow is enabled. You can not release manually.');

                      IF Rec."Status" <> Rec."Status"::Release then BEGIN
                          Rec."Status" := Rec."Status"::Release;
                          Rec.Modify();
                          Message('Document has been Released.');
                      end;

                  end;

              }*/
            action("Re&lease")
            {
                ApplicationArea = all;
                Caption = 'Re&lease New';
                ShortCutKey = 'Ctrl+F11';
                Image = ReleaseDoc;

                ToolTip = 'Executes the Re&lease action.';
                trigger OnAction()
                var
                    WorkflowManagement: Codeunit "Workflow Management";
                    allinoneCU: Codeunit "Approvals MGt 4";
                    RelText1: Label 'Document released and Moved to Local Indent Requisition List.';
                    RelText2: Label 'Document released and Moved to Central Indent Requisition List.';
                begin
                    //IF WorkflowManagement.CanExecuteWorkflow(Rec, Approvalmgmt.run) then
                    //if allinoneCU.CheckIndentRequisitionDoc1ApprovalsWorkflowEnabled(Rec) then
                    //  error('Workflow is enabled. You can not release manually.');
                    if (Rec.Type = Rec.Type::Enquiry) or (Rec.Type = Rec.Type::Quote) then begin
                        Rec.TestField("RFQ No.");
                        Rec.TestField("No.Series");
                        Rec.TestField(Status, Rec.Status::Open);
                        IndentReqLine.Reset();
                        IndentReqLine.SetRange("Document No.", Rec."No.");
                        if not IndentReqLine.FindFirst() then begin
                            Error('No Lines Found');
                        end;
                        //B2BSCM20SEP2023>>
                        if IndentReqLine.FindSet() then begin
                            repeat
                                IndentReqLine.TestField("Qty. To Order");
                            until IndentReqLine.Next() = 0;
                        end; //B2BSCM20SEP2023<<
                        Rec.TestField("Resposibility Center");
                        Rec.TESTFIELD("Document Date");
                        if Rec."Resposibility Center" = 'LOCAL REQ' then
                            Message(RelText1);
                        if Rec."Resposibility Center" = 'CENTRL REQ' then
                            Message(RelText2);


                        IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendIndentRequisitionDoc1forApprovalCode()) then
                            error('Workflow is enabled. You can not release manually.');

                        IF Rec.Status <> Rec.Status::Release then BEGIN
                            Rec.Status := Rec.Status::Release;
                            //Rec.Modify();
                            Message('Document has been Released.');
                        end;
                    end
                    else
                        if Rec.Type = Rec.Type::Order then begin
                            Rec.TestField("No.Series");
                            Rec.TestField(Status, Rec.Status::Open);
                            IndentReqLine.Reset();
                            IndentReqLine.SetRange("Document No.", Rec."No.");
                            if not IndentReqLine.FindFirst() then begin
                                Error('No Lines Found');
                            end;
                            //B2BSCM20SEP2023>>
                            if IndentReqLine.FindSet() then begin
                                repeat
                                    IndentReqLine.TestField("Qty. To Order");
                                until IndentReqLine.Next() = 0;
                            end; //B2BSCM20SEP2023<<
                            Rec.TestField("Resposibility Center");
                            Rec.TESTFIELD("Document Date");
                            if Rec."Resposibility Center" = 'LOCAL REQ' then
                                Message(RelText1);
                            if Rec."Resposibility Center" = 'CENTRL REQ' then
                                Message(RelText2);


                            IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendIndentRequisitionDoc1forApprovalCode()) then
                                error('Workflow is enabled. You can not release manually.');

                            IF Rec.Status <> Rec.Status::Release then BEGIN
                                Rec.Status := Rec.Status::Release;
                                //Rec.Modify();
                                Message('Document has been Released.');
                            end;
                        end;
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Image = Action;
                //  Visible = OpenApprEntrEsists;
                trigger OnAction()
                begin
                    approvalmngmt.ApproveRecordApprovalRequest(Rec.RecordId());
                end;
            }


            action("Send Approval Request1")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                //Visible = Not OpenApprEntrEsists and CanrequestApprovForFlow;
                ToolTip = 'Executes the Send Approval Request action.';
                trigger OnAction()
                var
                    ApprovalsCodeunit: Codeunit "Approvals MGt 4";
                    UserSetup: Record "User Setup";
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                    Recipiants: List of [Text];
                    Body: Text;
                    Text001: Label 'Please find Indent Requisition Number: %1 dt.%2 is raised for the purpose %3 is waiting for your approval.  Please approve the same.';
                    Sub: Label 'Request for Indent Requisition Approval';
                    ApprovalEntryLRec: Record "Approval Entry";

                begin
                    Rec.TestField("No.Series");
                    Rec.TestField(Status, Rec.Status::Open);
                    IndentReqLine.Reset();
                    IndentReqLine.SetRange("Document No.", Rec."No.");
                    if not IndentReqLine.FindFirst() then begin
                        Error('No Lines Found');
                    end;
                    //B2BSCM20SEP2023>>
                    if IndentReqLine.FindSet() then begin
                        repeat
                            IndentReqLine.TestField("Qty. To Order");
                        until IndentReqLine.Next() = 0;
                    end; //B2BSCM20SEP2023<<
                    Rec.TestField("Resposibility Center");
                    Rec.TESTFIELD("Document Date");
                    IF ApprovalsCodeunit.CheckIndentRequisitionDoc1ApprovalsWorkflowEnabled(rec) then
                        ApprovalsCodeunit.OnSendIndentRequisitionDoc1ForApproval(Rec);
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
                //Visible = CanCancelapprovalforrecord or CanCancelapprovalforflow;
                trigger OnAction()
                var
                    ApprovalsCodeunit: Codeunit "Approvals MGt 4";
                begin
                    ApprovalsCodeunit.OnCancelIndentRequisitionDoc1ForApproval(Rec);
                    //if rec."Status" = rec."Status"::"Pending Approval" then
                    //rec."Status" := rec."Status"::Open;
                end;
            }
            /* action("Workflow User Group")
            {
                ApplicationArea = All;
                Image = Users;
                //Visible = NOT OpenApprovalEntriesExist;
                //Visible = false;
                trigger OnAction()
                var
                    WorkflowUserGroup: Record "Workflow User Group";
                    PurchPaySetup: Record "Purchases & Payables Setup";
                begin
                    PurchPaySetup.GET;
                    PurchPaySetup.TESTFIELD("Indent Workflow User Group");
                    WorkflowUserGroup.RESET;
                    WorkflowUserGroup.SETRANGE(Code, PurchPaySetup."Indent Workflow User Group");
                    WorkflowUserGroup.FINDSET;
                    PAGE.RUN(1531, WorkflowUserGroup);
                end;

            } */

            action("Approval Entries")
            {
                ApplicationArea = All;
                Image = Entries;
                //Visible = openapp;
                ToolTip = 'Executes the Approval Entries action.';
                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                    ApprovalEntry: Record "Approval Entry";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", DATABASE::"Indent Req Header");
                    ApprovalEntry.SetRange("Document No.", Rec."No.");
                    ApprovalEntries.SetTableView(ApprovalEntry);
                    ApprovalEntries.RUN;
                end;
            }




            action("Re&open")
            {
                Caption = 'Re&open';
                Image = ReOpen;
                ApplicationArea = All;
                // Visible = ShowAct;

                trigger OnAction();
                var
                    ReText01: Label 'Document has been re-opened and moved to Indent Requisition List.';
                begin
                    Rec.TestField(Status, Rec.Status::Release);
                    IF Rec."Status" <> Rec."Status"::Open then BEGIN
                        Rec."Status" := Rec."Status"::Open;
                        //Rec.Modify();
                        Message(ReText01);
                    end;
                end;
            }

        }
        area(navigation)
        {
            group(Orders)
            {
                action("Created &Order")
                {
                    Caption = 'Open Created Order';
                    ApplicationArea = All;
                    Image = Open;
                    //    Visible = ShowAct;

                    trigger OnAction();
                    begin
                        CreatedOrders;
                    end;
                }

                action(OpenEnquiries)
                {
                    Caption = 'Open Created Enquiries';
                    ApplicationArea = All;
                    Image = ShowList;
                    // Visible = ShowAct;

                    trigger OnAction()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Enquiry);
                        PurchHeader.SETRANGE("Indent Requisition No", Rec."No.");
                        IF PurchHeader.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Purchase Enquiry List", PurchHeader);
                    end;
                }

                action(OpenQuotes)
                {
                    Caption = 'Open Created Quotes';
                    ApplicationArea = All;
                    Image = EntriesList;
                    // Visible = ShowAct;

                    trigger OnAction()
                    var
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.RESET;
                        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
                        PurchHeader.SETRANGE("Indent Requisition No", Rec."No.");
                        IF PurchHeader.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Purchase Quotes", PurchHeader);
                    end;
                }
            }
            group(print)
            {
                action("ETPL Indent Report")
                {
                    Caption = 'ETPL Indent Report';
                    ApplicationArea = All;
                    Image = Print;
                    trigger OnAction()
                    var
                        IndentReqHeader: Record "Indent Req Header";
                    begin
                        IndentReqHeader.Reset();
                        IndentReqHeader.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"ETPL Indent Report", true, false, IndentReqHeader);
                    end;
                }
                //B2BAnusha23Jan2025>>
                action("Indent Requisition Report")
                {
                    Caption = 'Indent Requisition Report';
                    ApplicationArea = All;
                    Image = Print;
                    trigger OnAction()
                    var
                        IndentReqHeader: Record "Indent Req Header";
                    begin
                        IndentReqHeader.Reset();
                        IndentReqHeader.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Indent Requisition Report", true, false, IndentReqHeader);
                    end;
                }
                //B2BAnusha23Jan2025<<
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Re&lease_Promoted"; "Re&lease")
                {
                }
                actionref("Re&open_Promoted"; "Re&open")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Functions', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Get Requisition Lines_Promoted"; "Get Requisition Lines")
                {
                }
                actionref("Create &Enquiry_Promoted"; "Create &Enquiry")
                {
                }
                actionref("Create &Quote_Promoted"; "Create &Quote")
                {
                }
                actionref("Create &Purchase Order_Promoted"; "Create &Purchase Order")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Created &Order_Promoted"; "Created &Order")
                {
                }
                actionref(OpenEnquiries_Promoted; OpenEnquiries)
                {
                }
                actionref(OpenQuotes_Promoted; OpenQuotes)
                {
                }
            }
            group(Category_Category6)
            {
                Caption = 'Print', Comment = 'Generated from the PromotedActionCategories property index 5.';
                actionref(Indent_Promoted; "ETPL Indent Report")
                {
                }
                actionref(Indent_Requestion; "Indent Requisition Report") { }//B2BAnusha23Jan2025>>
            }
        }
    }

    var
        Carry: Integer;
        IndentReqHeader: Record "Indent Req Header";
        Indentreqline: Record "Indent Requisitions";
        POAutomation: Codeunit 50026;
        CreateIndents: Record "Indent Requisitions";
        Vendor: Record 23;
        VendorList: Page 27;
        VendorListNew: page "Vendor List_B2B";
        PurchaseOrder: Record 38;
        Usermgt: Codeunit 5700;
        "-----Mail": Integer;
        Email: Text[50];
        StrVar: Text[50];
        Chr: Char;
        allinoneCU: Codeunit "Approvals MGt 4";
        MailCreated: Boolean;
        "---": Integer;
        UserSetupApproval: Page 119;
        UserSetup2: Record 91;
        IndentReqLines: Report "Indent Requestion Lines";
        Text001: Label 'Orders are created successfully.';
        Text003: Label 'Do you want to create Enquiries?';
        Text004: Label 'Do you want to create Quotations?';
        Text005: Label 'Do you want to create Orders?';
        Text0010: Label 'Enquiries Created Successfully';
        Text0011: Label 'Quotes Created Successfully';
        FieldEditable: Boolean;
        IndentReq: Record "Indent Requisitions";
        StyleTxt: Text;
    // ShowAct: Boolean;

    procedure CheckRemainingQuantity();
    var
        IndentReqHeaderCheck: Record "Indent Req Header";
        IndentRequisitionsCheck: Record "Indent Requisitions";
        CountVar: Integer;
        Text001: Label 'You Cannot create PO . Quantity not more than Zero.';
    begin
        CountVar := 0;
        IndentReqHeaderCheck.RESET;
        IndentReqHeaderCheck.SETRANGE("No.", Rec."No.");
        IF IndentReqHeaderCheck.FINDFIRST THEN
            IndentRequisitionsCheck.RESET;
        IndentRequisitionsCheck.SETRANGE("Document No.", IndentReqHeaderCheck."No.");
        IF IndentRequisitionsCheck.FINDSET THEN
            REPEAT
                //IF IndentRequisitionsCheck."Remaining Quantity" <> 0 THEN
                CountVar += 1;
            UNTIL IndentRequisitionsCheck.NEXT = 0;
        IF CountVar = 0 THEN
            ERROR(Text001);
    end;

    procedure CreatedOrders();
    var
        PurchHeader: Record 38;
    begin
        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("Indent Requisition No", Rec."No.");
        IF PurchHeader.FINDSET THEN
            PAGE.RUNMODAL(0, PurchHeader);
    end;

    procedure UpdateReqQty();
    var
        IndenReqRec: Record "Indent Requisitions";
        IndentLineRec: Record "Indent Line";
        IndentReqHeaderRec: Record "Indent Req Header";
        QuantyLvar: Decimal;
        IndentLineRec2: Record "Indent Line";
    begin
        IndenReqRec.RESET;
        IndenReqRec.SETRANGE("Document No.", Rec."No.");
        IF IndenReqRec.FINDSET THEN BEGIN
            REPEAT

                CLEAR(QuantyLvar);
                IF IndenReqRec."Qty. To Order" > IndenReqRec."Vendor Min.Ord.Qty" THEN
                    QuantyLvar := IndenReqRec."Qty. To Order"
                ELSE
                    QuantyLvar := IndenReqRec."Vendor Min.Ord.Qty";
                IndentLineRec.RESET;
                IndentLineRec.SETRANGE("Indent Req No", IndenReqRec."Document No.");
                IndentLineRec.SETRANGE("Indent Req Line No", IndenReqRec."Line No.");
                IndentLineRec.SETFILTER(IndentLineRec."Req.Quantity", '<>%1', 0);
                IndentLineRec.SETFILTER(IndentLineRec."Req.Quantity", '>=%1', QuantyLvar);
                IF IndentLineRec.FINDSET THEN BEGIN
                    IndentLineRec."Req.Quantity" := IndentLineRec."Req.Quantity" - QuantyLvar;
                    IF IndentLineRec."Req.Quantity" < 0 THEN
                        IndentLineRec."Req.Quantity" := 0;
                    IndentLineRec."Req.Quantity" := IndentLineRec."Quantity (Base)";//B2BSSD12/26/2023
                    IndentLineRec.MODIFY;
                    CLEAR(QuantyLvar);
                END ELSE
                    IndentLineRec2.RESET;
                IndentLineRec2.SETRANGE("Indent Req No", IndenReqRec."Document No.");
                IndentLineRec2.SETRANGE("Indent Req Line No", IndenReqRec."Line No.");
                IndentLineRec2.SETFILTER("Req.Quantity", '<>%1', 0);
                IndentLineRec2.SETFILTER("Req.Quantity", '<%1', QuantyLvar);
                IF IndentLineRec2.FINDSET THEN
                    REPEAT

                        IF ((QuantyLvar <> 0) AND (QuantyLvar >= IndentLineRec2."Req.Quantity")) THEN BEGIN
                            QuantyLvar -= IndentLineRec2."Req.Quantity";
                            IndentLineRec2."Req.Quantity" := 0;
                            IndentLineRec2.MODIFY;
                        END ELSE
                            IF ((QuantyLvar <> 0) AND (QuantyLvar < IndentLineRec2."Req.Quantity")) THEN BEGIN
                                IndentLineRec2."Req.Quantity" -= QuantyLvar;
                                IndentLineRec2.MODIFY;
                                CLEAR(QuantyLvar);
                            END;

                    UNTIL IndentLineRec2.NEXT = 0;

            UNTIL IndenReqRec.NEXT = 0;
        END;
    end;

    trigger OnInit()
    begin
        Rec.Status := Rec.Status::Open;
    end;

    /* trigger OnAfterGetRecord();
     begin

         if (Rec.Status = Rec.Status::Release) then begin
             FieldEditable := false;
             ShowAct := true;
         end else begin
             FieldEditable := true;
             ShowAct := false;
         end;

     end;*
    /* trigger OnAfterGetRecord();
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
     end;*/
    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.SetStyle();
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(Rec.RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(Rec.RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
    end;

    trigger OnOpenPage()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        Count: Integer;
        ReleaseCount: Integer;
        PurchOrderCount: Integer;
        IndentReqLine: Record "Indent Requisitions";
        Linecount: Integer;
    begin
        IndentReq.Reset();
        IndentReq.SetRange("Document No.", Rec."No.");
        IndentReq.SetFilter("Remaining Quantity", '%1', 0);
        IndentReq.SetFilter("Purch Order No.", '<>%1', '');
        if IndentReq.FindSet() then begin
            repeat
                Clear(PurchOrderCount);
                Clear(ReleaseCount);
                PurchLine.Reset();
                PurchLine.SetRange("Indent Req No", IndentReq."Document No.");
                PurchLine.SetRange("Indent Req Line No", IndentReq."Line No.");
                PurchLine.SetRange(CancelOrder, false);
                if PurchLine.FindSet() then begin
                    repeat
                        PurchOrderCount += 1;
                        if PurchHeader.Get(PurchHeader."Document Type"::Order, PurchLine."Document No.") then begin
                            if PurchHeader.Status = PurchHeader.Status::Released then
                                ReleaseCount += 1;
                        end;
                    until PurchLine.Next = 0;
                    if PurchOrderCount = ReleaseCount then
                        IndentReq."Order Status" := IndentReq."Order Status"::Completed
                    else
                        IndentReq."Order Status" := IndentReq."Order Status"::Pending;
                end else begin
                    PurchInvHeader.Reset();
                    PurchInvHeader.SetRange("Order No.", IndentReq."Purch Order No.");
                    if PurchInvHeader.FindFirst() then
                        IndentReq."Order Status" := IndentReq."Order Status"::Completed;
                end;
                IndentReq.Modify();
            until IndentReq.Next = 0;
        end;

        Clear(Linecount);
        Clear(Count);
        IndentReqLine.Reset();
        IndentReqLine.SetRange("Document No.", Rec."No.");
        if IndentReqLine.FindSet() then begin
            repeat
                Linecount += 1;
                if IndentReqLine."Order Status" = IndentReqLine."Order Status"::Completed then
                    Count += 1;
            until IndentReqLine.Next = 0;
            if Linecount = Count then
                Rec."Req Status" := Rec."Req Status"::Completed
            else
                Rec."Req Status" := Rec."Req Status"::Pending;
            Rec.Modify();
        end;
    end;




    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Open;
    end;

    var
        OpenAppEntrExistsForCurrUser: Boolean;
        OpenApprEntrEsists: Boolean;

        CanrequestApprovForFlow: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;

        // approvalmngmt: Codeunit "Approvals MGt 3"
        approvalmngmt: Codeunit "Approvals Mgmt.";
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";

}