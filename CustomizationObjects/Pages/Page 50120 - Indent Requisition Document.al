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
                }
                field("No.Series"; Rec."No.Series")
                {
                    ApplicationArea = All;
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
                //   Visible = ShowAct;
                //
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
                        // CreateIndents.RESET;
                        // CreateIndents.SETRANGE("Document No.", Rec."No.");
                        // CreateIndents.SETRANGE("Carry out Action", TRUE);
                        CurrPage.Indentrequisations.Page.SetSelectionFilter(CreateIndents);//B2BSSD18APR2023
                        CLEAR(VendorList);
                        VendorList.LOOKUPMODE(TRUE);
                        IF VendorList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            VendorList.SetSelection(Vendor);
                            IF Vendor.COUNT >= 1 THEN BEGIN
                                POAutomation.CreateEnquiries(CreateIndents, Vendor, Rec."No.Series");
                                MESSAGE(Text0010);
                            END ELSE
                                EXIT;
                        END;
                    END;
                    /* IndentReqLine.Reset();
                     IndentReqLine.SetRange("Document No.", Rec."No.");
                     if IndentReqLine.FindSet() then begin
                         repeat
                             IndentLineRec.Reset();
                             IndentLineRec.SetRange("Document No.", IndentReqLine."Indent No.");
                             IndentLineRec.SetRange("Line No.", IndentReqLine."Indent Line No.");
                             if IndentLineRec.FindSet() then begin
                                 repeat
                                     //    SetSelectionFilter(IndentLineRec);

                                     IndentLineRec.Status := IndentLineRec.Status::Enqiury;
                                     IndentLineRec.Modify();
                                 until IndentLineRec.Next() = 0;
                             end;
                         until IndentReqLine.Next() = 0;
                     end;*/
                end;
            }
            action("Create &Quote")
            {
                Caption = 'Create &Quote';

                ApplicationArea = All;
                Image = NewSalesQuote;
                // Visible = ShowAct;

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
                        CreateIndents.RESET;
                        CreateIndents.SETRANGE("Document No.", Rec."No.");
                        CreateIndents.SETRANGE("Carry out Action", TRUE);
                        CLEAR(VendorList);
                        VendorList.LOOKUPMODE(TRUE);
                        VendorList.RUNMODAL;
                        VendorList.SetSelection(Vendor);
                        IF Vendor.COUNT >= 1 THEN BEGIN
                            POAutomation.CreateQuotes(CreateIndents, Vendor, Rec."No.Series");
                            MESSAGE(Text0011);
                        END ELSE
                            EXIT;
                    END;
                    /*  IndentReqLine.Reset();
                      IndentReqLine.SetRange("Document No.", Rec."No.");
                      if IndentReqLine.FindSet() then begin
                          repeat
                              IndentLineRec.Reset();
                              IndentLineRec.SetRange("Document No.", IndentReqLine."Indent No.");
                              IndentLineRec.SetRange("Line No.", IndentReqLine."Indent Line No.");
                              if IndentLineRec.FindSet() then begin
                                  //  repeat
                                  IndentLineRec.Status := IndentLineRec.Status::Quote;
                                  IndentLineRec.Modify();
                                  ///  until IndentLineRec.Next() = 0;
                              end;
                          until IndentReqLine.Next() = 0;
                      end;*/
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
                begin
                    //B2BSSD09MAY2023>>
                    if Rec."Create Purchase Order" = true then
                        Error('Purchase Order already created');
                    //B2BSSD09MAY2023<<
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
                        UpdateReqQty;
                        POAutomation.CreateOrder2(CreateIndents, Vendor, Rec."No.Series");
                        //B2BSSD09MAY2023>>
                        Rec."Create Purchase Order" := true;
                        CurrPage.Update();
                        //B2BSSD09MAY2023<<
                        MESSAGE(Text001);
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
                        Rec.Modify();
                        Message('Document has been Released.');
                    end;
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
                    if rec."Status" = rec."Status"::"Pending Approval" then
                        rec."Status" := rec."Status"::Open;
                    Rec.Modify();
                end;
            }

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
                        Rec.Modify();
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
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(Rec.RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(Rec.RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
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