pageextension 50101 PostedOrderPageExt extends "Purchase Order"
{
    layout
    {

        //B2BSSD28FEB2023<<
        addafter("Include GST in TDS Base")
        {
            field(Regularization; Rec.Regularization)
            {
                ApplicationArea = all;
            }
            //B2BVCOn12Mar2024 >>
            field(Amendment; Rec.Amendment)
            {
                ApplicationArea = All;
            }
            field("Short Closed by"; Rec."Short Closed by")
            {
                ApplicationArea = all;
            }
            field("Short Closed Date & Time"; Rec."Short Closed Date & Time")
            {
                ApplicationArea = all;
            }
            field(ShortClosed; Rec.ShortClosed)
            {
                ApplicationArea = All;
            }
            field("Cancelled Order"; Rec."Cancelled Order")
            {
                ApplicationArea = All;
                Caption = 'Order Cancelled';
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Caption = 'Project Code';
                Visible = false;
            }
            //B2BVCOn12Mar2024 <<
            field("Cancellation Reason"; Rec."Cancellation Reason")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cancellation Reason field.';
            }
        }
        addafter(Regularization) //B2BAJ02012024
        {
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = All;
            }
            field("PO Narration"; "PO Narration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Value of PO Narration';
            }
            field("Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Value of Your Reference';
            }
        }

        //B2BSSD28FEB2023>>
        addlast("Invoice Details")
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
                Editable = true;//B2BSCM08SEP2023

            }
            field("Bill of Entry No"; Rec."Bill of Entry No")
            {
                ApplicationArea = All;
                Editable = true;//B2BSCM08SEP2023
                                // ShowMandatory = true; //B2BSCM08SEP2023
            }
            field("EPCG No."; Rec."EPCG No.")
            {
                ApplicationArea = all;
                Editable = true;//B2BSCM08SEP2023

            }
            field("EPCG Scheme"; Rec."EPCG Scheme")
            {
                ShowMandatory = true;
                ApplicationArea = all;
                Editable = true;//B2BSCM08SEP2023

            }
            field("Import Type"; Rec."Import Type")
            {
                ShowMandatory = true;
                Editable = true;
                ApplicationArea = all;
            }
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = All;
            }

        }

        addafter("Vendor Invoice No.")//B2BSSD20MAR2023
        {
            field("Vendor Invoice Date"; Rec."Vendor Invoice Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor Invoice Date")//B2BSSD20MAR2023
        {
            field("Programme Name"; Rec."Programme Name")
            {
                ApplicationArea = All;
                Caption = 'Programme Name';
            }
        }
        addafter(Status)//B2BSSD18JUN2023
        {
            field("Purchase order"; Rec."Purchase order")
            {
                ApplicationArea = All;
            }
            field("Ammendent Comments"; Rec."Ammendent Comments")
            {
                ApplicationArea = All;
                Caption = 'Ammendent Comments';
            }
            field("Vendor Quotation No."; Rec."Vendor Quotation No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor Quotation No.';
                Editable = FieldEditable;
            }
            field("Vendor Quotation Date"; Rec."Vendor Quotation Date") //B2BVCOn18Mar2024
            {
                ApplicationArea = All;
                Caption = 'Vendor Quotation Date';
                Editable = FieldEditable;
            }
        }
        modify("Shipment Method Code")
        {
            Caption = 'Delivery';
            Editable = FieldEditable; //B2BVCOn07Aug2024
        }
        modify("Payment Terms Code")
        {
            Caption = 'Payment Term';
            Editable = FieldEditable; //B2BVCOn07Aug2024
        }
        addafter("Cancelled Order")
        {
            field("Exchange Rate"; Rec."Exchange Rate")
            {
                ApplicationArea = All;

            }
            field("Draft Date"; Rec."Draft Date")//B2BSPon16Aug2024//savarappa
            {
                ApplicationArea = All;
                //B2BAnusha20Jan2025>>
                Caption = 'Released Date';
                Editable = false;
            }
        }
        modify("Purchaser Code") //B2BVCOn07Aug2024
        {
            Editable = FieldEditable;
        }
        modify("Foreign Trade") //B2BVCOn07Aug2024
        {
            Editable = FieldEditable;
        }
        //B2BAnusha20Jan2025>>
        modify("Document Date")
        {
            Caption = 'Draft Date';
        }
        addafter("Buy-from Address 2")
        {
            field("Buy-from Address 3"; Rec."Buy-from Address 3")
            {
                ApplicationArea = All;
                Caption = 'Address 3';
            }
        }


        //B2BSSD25Jan2023<<
        addafter(PurchLines)
        {
            part(TrermsAndCondition; "Terms and Condition")
            {
                ApplicationArea = all;
                SubPageLink = DocumentNo = field("No.");
                SubPageView = WHERE(DocumentType = const(Order), Type = filter("Terms & Conditions")); //B2BVCOn23Sep2024
                UpdatePropagation = Both;
                Editable = FieldEditable1; //B2BVCOn07Aug2024
            }
            part(PoTermsAndSpecification; "PO Terms and Specifications") //B2BVCOn23Sep2024
            {
                ApplicationArea = All;
                SubPageLink = DocumentNo = field("No.");
                SubPageView = WHERE(DocumentType = const(Order), Type = filter(Specifications));
                UpdatePropagation = Both;
                Editable = FieldEditable1;
            }
        }
        //B2BSSD25Jan2023>>

        //B2BSSD14FEB2023<<
        /*  modify("Attached Documents")
           {
               Visible = false;
           }*/
        modify("Ship-to Name")//B2BSSD27MAR2023
        {
            Editable = true;
        }
        modify("Ship-to Address 2")//B2BSSD27MAR2023
        {
            Editable = true;
        }

        modify("No. of Archived Versions")
        {
            Importance = Promoted;
        }
        modify("Transaction Specification")//B2BSCM08SEP2023
        {
            Editable = true;
            ShowMandatory = true;
            Caption = 'Price Basis';
        }
        modify("Transaction Type")//B2BSCM08SEP2023
        {
            Editable = true;
            ShowMandatory = true;
            Caption = 'Taxes';
        }
        modify("Transport Method")//B2BSCM08SEP2023
        {
            Editable = true;
            ShowMandatory = true;
        }

        addafter("Attached Documents")
        {
            part(AttachmentDocPurOrd; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments1';
                Provider = PurchLines;
                /* SubPageLink = "Table ID" = CONST(50202),
                "No." = FIELD("Indent No."), "Line No." = field("Indent Line No."); */
                SubPageLink =
                "No." = FIELD("Indent No."), "Line No." = field("Indent Line No."),
                  "Document Type" = FIELD("Document Type");
                ;
            }
        }
        //B2BSSD14FEB2023>>
        addafter(Control3)
        {
            part(PurchLineItemPicture; "Purchase Line Item Picture")
            {
                ApplicationArea = All;
                Provider = PurchLines;
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
        }





    }

    actions
    {
        //B2BVCOn03Oct2022>>
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                Err001: Label 'Qty. to Accept and Qty. to Reject must not be greater than Quantity. Line No. %1';
                Error002: TextConst ENN = 'Quantity Receive can not be Grater then QC Accepted Quantity';
                ImportTypeError: TextConst ENN = 'Import type Must have value in Invoice details Tab';//B2BSCM25SEP2023
                Text0001: Label 'This Purchase Order has been Short Closed. We cannot post it.';
            begin
                //B2BSSD09AUG2023>>
                purchaseLinevar.Reset();
                purchaseLinevar.SetRange("Document Type", Rec."Document Type");
                purchaseLinevar.SetRange("Document No.", Rec."No.");
                if purchaseLinevar.FindSet() then begin
                    repeat
                        if (purchaseLinevar.ShortClosed = true) and (purchaseLinevar."Outstanding Quantity" = 0) then
                            Error(Text0001);
                    until purchaseLinevar.Next() = 0;
                end;
                //B2BSSD09AUG2023<

                PurchLine.Reset();
                PurchLine.SetRange("Document No.", Rec."No.");
                PurchLine.SetRange("Document Type", Rec."Document Type");
                PurchLine.SetFilter("Qty. to Receive", '>0');
                PurchLine.SetRange(CWIP, true);
                if PurchLine.FindSet() then
                    repeat
                        CWIPDetails.Reset();
                        CWIPDetails.SetRange("Document No.", PurchLine."Document No.");
                        CWIPDetails.SetRange("Document Line No.", PurchLine."Line No.");
                        if not CWIPDetails.FindSet() then
                            Error(ErrLbl, PurchLine."No.", PurchLine."Line No.")
                        else
                            if (CWIPDetails.Count < (PurchLine."Qty. to Receive" + PurchLine."Quantity Received")) and (PurchLine."Unit of Measure Code" = 'NOS') then
                                Error(Err2Lbl, PurchLine."No.", PurchLine."Line No.")
                    until PurchLine.Next() = 0;


                Rec.TestField("Import Type", ErrorInfo.Create(ImportTypeError, true, PurchaseHeader));//B2BSCM25SEP2023
                if rec."EPCG Scheme" = rec."EPCG Scheme"::"Under EPCG" then
                    Rec.TestField("EPCG No.");

                GateEntry.Reset();
                GateEntry.SetRange("Source No.", Rec."No.");
                if GateEntry.FindFirst() then begin
                    PurchLine.Reset();
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            if (PurchLine."Ref. Posted Gate Entry" = '') then
                                Error('Gate entry available for the purchase document. Hence, It must be filled in Line No. %1.', PurchLine."Line No.");
                        until PurchLine.Next = 0;
                end;

                PurchLine.Reset();
                PurchLine.SetRange("Document No.", Rec."No.");
                if PurchLine.FindSet() then
                    repeat
                        if (PurchLine."Qty. to Accept B2B" + PurchLine."Qty. to Reject B2B"
                            + PurchLine."Quantity Accepted B2B") > PurchLine.Quantity then
                            Error(Err001);
                    until PurchLine.Next = 0;


                //B2BSSD09AUG2023>>
                purchaseLinevar.Reset();
                purchaseLinevar.SetRange("Document No.", Rec."No.");
                purchaseLinevar.SetRange(Type, purchaseLinevar.Type::Item);
                purchaseLinevar.SetRange(Type, purchaseLinevar.Type::"Fixed Asset");
                purchaseLinevar.SetRange(Type, purchaseLinevar.Type::Description);
                if purchaseLinevar.FindSet() then begin
                    // repeat
                    purchaseLinevar.TestField("Qty Accepted Inward_B2B");
                    //until purchaseLinevar.Next() = 0;
                end;
                //B2BSSD09AUG2023<<

                //B2BAnusha12262024>>
                PurchaseLineRec.Reset();
                PurchaseLineRec.SetRange("Document No.", Rec."No.");
                if PurchaseLineRec.FindSet() then
                    repeat
                        PostedGateEntryRec.Reset();
                        PostedGateEntryRec.SetRange("No.", PurchaseLineRec."Posted Gate Entry No.");
                        if PostedGateEntryRec.FindLast() then begin
                            if Rec."Posting Date" < PostedGateEntryRec."Posting Date" then
                                Error(Err3lbl);
                        end;
                    until PurchaseLineRec.Next() = 0;
                //B2BAnusha12262024<<
            end;


        }

        //B2BSSD13MAR2023<<
        /* //B2BSCM20SEP2023
                modify(Receipts)
                {


                    trigger OnAfterAction()
                    var
                    begin
                        purchaseLinevar.Reset();
                        purchaseLinevar.SetRange("Document No.", Rec."No.");
                        if purchaseLinevar.FindSet() then begin
                            if purchaseLinevar.Type = purchaseLinevar.Type::Item then
                                purchaseLinevar.TestField("Qty. to Accept B2B");
                        end;
                    end;
                } //B2BSSD13MAR2023<<
                  */
        //B2BVCOn03Oct2022<<
        //B2BVCOn04Oct2022>>
        modify(Release)
        {
            trigger OnBeforeAction()
            var
            //ImportTypeError: TextConst ENN = 'Import type Must have value in Invoice details Tab';
            begin
                //B2BSSD16JUN2023>>
                PurchLine.Reset();
                PurchLine.SetRange("Document No.", Rec."No.");
                if PurchLine.FindSet() then begin
                    repeat
                        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
                            PurchLine.TestField("FA Class Code");
                            PurchLine.TestField("FA SubClass Code");
                            PurchLine.TestField("Serial No.");
                            PurchLine.TestField(Make_B2B);
                            PurchLine.TestField("Model No.");
                        end;
                        PurchLine.TestField("GST Group Code");//B2BSCM22SEP2023
                        PurchLine.TestField("HSN/SAC Code");//B2BSCM22SEP2023
                    until PurchLine.Next() = 0;
                end;
                //B2BSSD16JUN2023<<
                if (Rec."LC No." = '') then begin
                    LCDetails.Reset();
                    LCDetails.SetRange("Issued To/Received From", Rec."Buy-from Vendor No.");
                    LCDetails.SetRange("Transaction Type", LCDetails."Transaction Type"::Purchase);
                    LCDetails.SetRange(Released, true);
                    if LCDetails.FindFirst() then
                        Error('There is a Released LC document against this Vendor. To proceed, please provide LC No. in Purchase Order');
                end;
                //B2BSSD29JUN2023>>
                // Rec.TestField("Import Type", ErrorInfo.Create(ImportTypeError, true, PurchaseHeader));
                Rec.TestField("Payment Terms Code");
                /* Rec.TestField("Transaction Specification");
                Rec.TestField("Transaction Type");
                Rec.TestField("Transport Method"); */
                // Rec.TestField("EPCG Scheme");
                //B2BSSD29JUN2023<<

                // PurchLine.Reset();
                // PurchLine.SetRange("Document No.", Rec."No.");
                // PurchLine.SetRange("Document Type", Rec."Document Type");
                // PurchLine.SetFilter("Qty. to Receive", '>0');
                // PurchLine.SetRange(CWIP, true);
                // if PurchLine.FindSet() then
                //     repeat
                //         CWIPDetails.Reset();
                //         CWIPDetails.SetRange("Document No.", PurchLine."Document No.");
                //         CWIPDetails.SetRange("Document Line No.", PurchLine."Line No.");
                //         if not CWIPDetails.FindSet() then
                //             Error(ErrLbl, PurchLine."No.", PurchLine."Line No.")
                //         else
                //             if (CWIPDetails.Count < (PurchLine."Qty. to Receive" + PurchLine."Quantity Received")) and (PurchLine."Unit of Measure Code" = 'NOS') then
                //                 Error(Err2Lbl, PurchLine."No.", PurchLine."Line No.")
                //     until PurchLine.Next() = 0;
            end;
        }
        //B2BVCOn04Oct2022<<<

        //B2BSSD29JUN2023>>
        modify(Reopen)
        {
            trigger OnBeforeAction()
            var
                PurchaseHeadArchive: Record "Purchase Header Archive";
                ArchiveManagement: Codeunit ArchiveManagement;
                ReleasePurchDoc: Codeunit "Release Purchase Document";

            begin
                if Rec.Status = rec.Status::Released then begin
                    Rec.TestField("Ammendent Comments");

                end;
                ArchiveManagement.ArchivePurchDocument(Rec);
                ReleasePurchDoc.PerformManualReopen(Rec);
                Rec."Ammendent Comments" := '';
            end;
        }
        //B2BSSD29JUN2023<<

        //B2BMSOn11Nov2022>>
        addafter(Print)
        {
            action(PrintRegularization)
            {
                ApplicationArea = Suite;
                Caption = 'Print Purchase Order Report';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'Prepare to print the regularization document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    RegErr: Label 'This is not a regularization order';
                begin
                    //if not Rec.Regularization then
                    //Error(RegErr);
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Regularization Order", true, false, PurchaseHeader);
                end;
            }
            action(PrintRegularizationNew)
            {
                ApplicationArea = Suite;
                Caption = 'Print Purchase Order Report New';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'Prepare to print the regularization document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    RegErr: Label 'This is not a regularization order';
                begin
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Regularization Order New", true, false, PurchaseHeader);
                end;
            }

        }
        //B2BSSD14Feb2023<<
        addafter("Request Approval")
        {
            action("Workflow User Group")
            {
                ApplicationArea = Basic, Suite;
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

            }
        }

        //B2BSSD12APR2023>>
        addafter(PrintRegularization)
        {
            action(POFormat)
            {
                ApplicationArea = Suite;
                Caption = 'Print PO Format Order';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category10;
                Visible = false;
                ToolTip = 'Prepare to print the Purchase Order. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"PO FORMAT", true, false, PurchaseHeader);
                end;
            }
        }
        addafter(POFormat)
        {
            action(GRNReceipt)
            {
                ApplicationArea = Suite;
                Caption = 'GRN RECEIPT';
                Ellipsis = true;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category10;
                ToolTip = 'Prepare to print the GRN Report. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PostedPurReceipt: Record "Purch. Rcpt. Header";
                begin
                    PostedPurReceipt.Reset();
                    PostedPurReceipt.SetRange("Order No.", Rec."No.");
                    Report.RunModal(Report::"GRN RECEIPT", true, false, PostedPurReceipt);
                end;
            }
        }
        //B2BSSDSSD12APR2023<<
        modify(DocAttach)
        {
            Visible = false;
        }
        //B2BSSD14Feb2023>>
        //B2BVCOn12Mar2024 >>
        addafter("F&unctions")
        {
            action("Short Close")
            {
                ApplicationArea = All;
                Image = PostOrder;
                ToolTip = 'Short Close the order based on Qty Received and Invoiced';
                trigger OnAction()
                begin
                    ShortCloseHdr();
                    if Rec.ShortClosed then begin
                        PurchLineGRec.Reset();
                        PurchLineGRec.SetRange("Document Type", Rec."Document Type");
                        PurchLineGRec.SetRange("Document No.", Rec."No.");
                        if PurchLineGRec.FindSet() then
                            repeat
                                if IndentReqLine.Get(PurchLineGRec."Indent Req No", PurchLineGRec."Indent Req Line No") then begin
                                    IndentReqLine.CalcFields("Received Quantity");
                                    IndentReqLine."Qty. Ordered" := IndentReqLine."Received Quantity";
                                    IndentReqLine.Validate("Remaining Quantity", (IndentReqLine.Quantity - IndentReqLine."Qty. Ordered"));
                                    IndentReqLine."PO Vendor" := PurchLineGRec."Buy-from Vendor No.";
                                    IndentReqLine.Modify;
                                end;
                            until PurchLineGRec.Next = 0;
                    end;
                end;

            }
            action("Cancel Order")
            {
                ApplicationArea = All;
                Image = Cancel;
                trigger OnAction()
                begin
                    CancelOrderHdr();
                    if Rec."Cancelled Order" then begin
                        PurchLineGRec.Reset();
                        PurchLineGRec.SetRange("Document Type", Rec."Document Type");
                        PurchLineGRec.SetRange("Document No.", Rec."No.");
                        if PurchLineGRec.FindSet() then
                            repeat
                                if IndentReqLine.Get(PurchLineGRec."Indent Req No", PurchLineGRec."Indent Req Line No") then begin
                                    IndentReqLine.CalcFields("Received Quantity");
                                    IndentReqLine."Received Quantity" := 0;
                                    IndentReqLine."Qty. Ordered" := IndentReqLine."Received Quantity";
                                    IndentReqLine.Quantity := IndentReqLine."Remaining Quantity" + PurchLineGRec.Quantity;
                                    IndentReqLine.Validate("Remaining Quantity", IndentReqLine.Quantity);
                                    IndentReqLine."PO Vendor" := PurchLineGRec."Buy-from Vendor No.";
                                    IndentReqLine.Modify;
                                end;
                            until PurchLineGRec.Next = 0;
                    end;
                end;
            }

        }
        //B2BVCOn12Mar2024 <<
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Payment Terms Code");
                /* Rec.TestField("Transaction Specification");
                Rec.TestField("Transaction Type");
                Rec.TestField("Transport Method"); */

                PurchLine.Reset();
                PurchLine.SetRange("Document No.", Rec."No.");
                if PurchLine.FindSet() then begin
                    repeat
                        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
                            PurchLine.TestField("FA Class Code");
                            PurchLine.TestField("FA SubClass Code");
                            PurchLine.TestField("Serial No.");
                            PurchLine.TestField(Make_B2B);
                            PurchLine.TestField("Model No.");
                        end;
                        PurchLine.TestField("GST Group Code");//B2BSCM22SEP2023
                        PurchLine.TestField("HSN/SAC Code");//B2BSCM22SEP2023
                    until PurchLine.Next() = 0;
                end;
                if (Rec."LC No." = '') then begin
                    LCDetails.Reset();
                    LCDetails.SetRange("Issued To/Received From", Rec."Buy-from Vendor No.");
                    LCDetails.SetRange("Transaction Type", LCDetails."Transaction Type"::Purchase);
                    LCDetails.SetRange(Released, true);
                    if LCDetails.FindFirst() then
                        Error('There is a Released LC document against this Vendor. To proceed, please provide LC No. in Purchase Order');
                end;

                PurchLine.Reset();
                PurchLine.SetRange("Document No.", Rec."No.");
                PurchLine.SetRange("Document Type", Rec."Document Type");
                PurchLine.SetFilter("Qty. to Receive", '>0');
                PurchLine.SetRange(CWIP, true);
                if PurchLine.FindSet() then
                    repeat
                        CWIPDetails.Reset();
                        CWIPDetails.SetRange("Document No.", PurchLine."Document No.");
                        CWIPDetails.SetRange("Document Line No.", PurchLine."Line No.");
                        if not CWIPDetails.FindSet() then
                            Error(ErrLbl, PurchLine."No.", PurchLine."Line No.")
                        else
                            if (CWIPDetails.Count < (PurchLine."Qty. to Receive" + PurchLine."Quantity Received")) and (PurchLine."Unit of Measure Code" = 'NOS') then
                                Error(Err2Lbl, PurchLine."No.", PurchLine."Line No.")
                    until PurchLine.Next() = 0;
            end;

            trigger OnAfterAction()
            var
                UserSetup: Record "User Setup";
                Email: Codeunit Email;
                EmailMessage: Codeunit "Email Message";
                Recipiants: List of [Text];
                Body: Text;
                Sub: Label 'Request for Purchase Order Approval';
                ApprovalEntryLRec: Record "Approval Entry";
                Text001: Label 'Please find Purchase Order Number: %1 dt.%2 is waiting for your approval.  Please approve the same.';
            begin
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


    }
    //B2BVCOn12Mar2024 >>

    //B2BVCOn07Aug2024 >>
    trigger OnAfterGetRecord()
    begin
        if (Rec.Status = Rec.Status::Released) or (Rec."Cancelled Order" = true) then
            FieldEditable := false
        else
            FieldEditable := true;

        if (Rec.Status = Rec.Status::Released) and (Rec."Cancelled Order" = false) then
            FieldEditable1 := false
        else
            FieldEditable1 := true;
    end;
    //B2BVCOn07Aug2024 <<
    local procedure ShortCloseHdr()
    var
        PurchLine: Record "Purchase Line";
        ConfirmText: Label 'Do you want to Short Close the Purchase Order %1 ?';
        NotApplicableErr: Label 'Qty Received and Qty Invoiced should be matching for Line %1';
        SuccessMsg: Label 'Purchase Order %1 is Short Closed';
        AlredyShortClosed: Label 'Purchase Order   %1 is already Short Closed';//
        ShortClosed: Boolean;
    begin
        if rec.ShortClosed = true then
            Error(AlredyShortClosed, rec."No.");
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type"::Order);
        PurchLine.SetRange("Document No.", Rec."No.");
        PurchLine.SetFilter("No.", '<>%1', '');
        PurchLine.SetFilter(Quantity, '<>%1', 0);
        PurchLine.SetRange(ShortClosed, false);
        //PurchLine.TestField("Quantity Received");
        if PurchLine.FindSet() then
            repeat
                if PurchLine."Quantity Invoiced" <> PurchLine."Quantity Received" then
                    Error(NotApplicableErr, PurchLine."Line No.");
                PurchLine.TestField("Quantity Received");//
            until PurchLine.Next() = 0;
        if not Confirm(StrSubstNo(ConfirmText, Rec."No."), false) then
            exit;

        Clear(ShortClosed);
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type"::Order);
        PurchLine.SetRange("Document No.", Rec."No.");
        PurchLine.SetFilter("No.", '<>%1', '');
        PurchLine.SetFilter(Quantity, '<>%1', 0);
        PurchLine.SetRange(ShortClosed, false);
        if PurchLine.FindSet() then begin
            repeat
                if (PurchLine.Quantity = PurchLine."Quantity Received") then//
                    Error('Quantity must not be equal to Quantity Received');//

                if PurchLine."Quantity Invoiced" = PurchLine."Quantity Received" then begin
                    PurchLine.ShortClosed := true;
                    PurchLine."Posted Invioce" := true;
                    PurchLine.Quantity := PurchLine."Quantity Invoiced";
                    PurchLine."Short Close Quantity" := PurchLine."Outstanding Quantity";
                    //if PurchLine."Short Close Quantity" <> 0 then begin
                    //PurchLine."Outstanding Quantity" := 0;
                    //PurchLine."Outstanding Qty. (Base)" := 0;
                    //end;
                    PurchLine."Short Closed by" := UserId;
                    PurchLine."Short Closed Date & Time" := CurrentDateTime;
                    if PurchLine."Short Close Quantity" <> 0 then begin
                        PurchLine."Outstanding Quantity" := 0;
                        PurchLine.Validate("Qty. to Receive", 0);
                        PurchLine.Validate("Qty. to Invoice", 0);
                        PurchLine."Outstanding Qty. (Base)" := 0;
                        ShortClosed := true;
                    end;
                    PurchLine.Modify();
                    //ShortClosed := true;
                end;
            until PurchLine.Next() = 0;
            if ShortClosed then begin

                rec."Short Closed by" := UserId;
                Rec."Short Closed Date & Time" := CurrentDateTime;
                Rec.ShortClosed := true;
                Rec."Posted Invioce" := true;
                Rec.Modify();
            end;
        end;
        Message(SuccessMsg, Rec."No.");
    end;
    //B2BVCOn12Mar2024 <<
    local procedure CancelOrderHdr()
    var
        PurchLine: Record "Purchase Line";
        ConfirmText: Label 'Do you want to Cancelled the Purchase Order %1 ?';
        AlredyCancelledOrder: Label 'Purchase Order  %1 is already Order Cancelled';
        SuccessMsg: Label 'Purchase Order %1 is Cancelled';
        ErrorMsg: Label 'Quantity Received Must be Zero, Document No. %1, Line No. %2';
        CancelOrder: Boolean;
    begin
        if Rec."Cancelled Order" then
            Error(AlredyCancelledOrder, Rec."No.");
        if not Confirm(StrSubstNo(ConfirmText, Rec."No."), false) then
            exit;

        Clear(CancelOrder);
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type"::Order);
        PurchLine.SetRange("Document No.", Rec."No.");
        PurchLine.SetRange(CancelOrder, false);
        PurchLine.SetFilter("No.", '<>%1', '');
        PurchLine.SetFilter(Quantity, '<>%1', 0);
        if PurchLine.FindSet() then
            repeat
                if PurchLine."Quantity Received" <> 0 then
                    Error(ErrorMsg, PurchLine."Document No.", PurchLine."Line No.");
                if PurchLine."Quantity Received" = 0 then begin
                    PurchLine.CancelOrder := true;
                    if PurchLine.CancelOrder then
                        CancelOrder := true;
                    PurchLine.Modify();
                end;
            until PurchLine.Next = 0;
        if CancelOrder then begin
            Rec."Cancelled Order" := true;
            Rec.Modify;
        end;
        Message(SuccessMsg, Rec."No.");
    end;

    var
        cu90: Codeunit "Purch.-Post";
        GateEntry: Record "Posted Gate Entry Line_B2B";
        PurchLine: Record "Purchase Line";
        LCDetails: Record "LC Details";
        PurchaseHeader: Record "Purchase Header";
        purchaseLinevar: Record "Purchase Line";
        POAutomation: Codeunit "PO Automation";
        ErrorTxt: TextConst ENN = 'RGP Inward Must Be Post';
        ErrorTxt1: TextConst ENN = 'Quantity cannot Received More Then Accepted Inward Quantity';
        PurchLineGRec: Record "Purchase Line";
        IndentReqLine: Record "Indent Requisitions";
        CWIPDetails: Record "CWIP Details";
        PurchaseLine: Record "Purchase Line";
        FieldEditable, FieldEditable1 : Boolean;
        ErrLbl: Label 'You must define CWIP details for the Item No. %1 and Line No. %2.';
        Err2Lbl: Label 'CWIP details must be defined for the total receiving quantity of Item No. %1 and Line No. %2.';
        Err3lbl: Label 'Posting Date Must not be Less than Inward Gate Posting Date';
        PostedGateEntryRec: Record "Posted Gate Entry Header_B2B";
        PurchaseLineRec: Record "Purchase Line";
}