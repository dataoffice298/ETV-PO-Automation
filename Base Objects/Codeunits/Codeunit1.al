codeunit 50016 "MyBaseSubscr"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        IndentLine: Record "Indent Line";
        IssuedDateTime: DateTime;
        FromLocation: Code[20];
        ToLocation: Code[20];
        IssuedTo: Text[50];
        Comment: Text[500];

    [EventSubscriber(ObjectType::table, 83, 'OnBeforePostingItemJnlFromProduction', '', False, False)] //PKON22M17
    local procedure OnBeforePostingItemJnlFromProduction(var ItemJournalLine: Record "Item Journal Line"; Print: Boolean; var IsHandled: Boolean)
    var
        ProOrdCom: Record "Prod. Order Component";
        ItemJourLinesGrec: Record "Item Journal Line";
    begin
        ItemJourLinesGrec.RESET;
        ItemJourLinesGrec.CopyFilters(ItemJournalLine);
        IF ItemJourLinesGrec.FINDSET then
            Repeat
                ProOrdCom.RESET;
                ProOrdCom.SetRange("Prod. Order No.", ItemJourLinesGrec."Order No.");
                ProOrdCom.SetRange("Prod. Order Line No.", ItemJourLinesGrec."Order Line No.");
                ProOrdCom.SetRange("Line No.", ItemJourLinesGrec."Prod. Order Comp. Line No.");
                IF ProOrdCom.FINDSET THEN
                    REPEAT
                        ProOrdCom.CalcFields(ProOrdCom.Inventory);
                        IF ProOrdCom.Inventory < ProOrdCom."Expected Quantity" THEN
                            Error('Inventory availability is less than expected qunatity for some items. Please check "Shortage Report_50011"');
                    Until ProOrdCom.Next = 0;
            until ItemJourLinesGrec.Next = 0;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Purch. Rcpt. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    // FlowFieldsEditable := false;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Purch. Rcpt. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptHeaderInsert', '', false, false)]
    local procedure OnAfterPurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
        IsHandled: Boolean;
        DocumentAttachmentMgmt: Codeunit "Document Attachment Mgmt";
    begin
        // Triggered when a posted purchase cr. memo / posted purchase invoice is created
        if PurchaseHeader.IsTemporary() then
            exit;

        if PurchRcptHeader.IsTemporary() then
            exit;

        ToRecRef.GetTable(PurchRcptHeader); //B2BMSOn06Oct2022

        FromRecRef.GetTable(PurchaseHeader);

        if ToRecRef.Number > 0 then
            DocumentAttachmentMgmt.CopyAttachmentsForPostedDocs(FromRecRef, ToRecRef);
        //CopyAttachmentsForPostedDocs(FromRecRef, ToRecRef, IsHandled);
    end;
    //Invoice>>
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecInv(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Purch. Inv. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure OnAfterPurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
        IsHandled: Boolean;
        DocumentAttachmentMgmt: Codeunit "Document Attachment Mgmt";
    begin
        // Triggered when a posted purchase cr. memo / posted purchase invoice is created
        if PurchInvHeader.IsTemporary() then
            exit;

        if PurchHeader.IsTemporary() then
            exit;

        ToRecRef.GetTable(PurchInvHeader); //B2BMSOn06Oct2022

        FromRecRef.GetTable(PurchHeader);

        if ToRecRef.Number > 0 then
            DocumentAttachmentMgmt.CopyAttachmentsForPostedDocs(FromRecRef, ToRecRef);
        //CopyAttachmentsForPostedDocs(FromRecRef, ToRecRef, IsHandled);
    end;
    //invoice end<<

    //B2BVCOn11Oct2024 >>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", 'OnBeforeDocAttachForPostedPurchaseDocs', '', false, false)]
    local procedure OnBeforeDocAttachForPostedPurchaseDocs(var PurchaseHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var IsHandled: Boolean)
    var
        DocAttachment: Record "Document Attachment";
    begin
        DocAttachment.Reset;
        DocAttachment.SetRange("Table ID", Database::"Purch. Inv. Header");
        DocAttachment.SetRange("No.", PurchInvHeader."No.");
        if DocAttachment.FindFirst() then
            IsHandled := true;
    end;
    //B2BVCOn11Oct2024 <<

    /* local procedure CopyAttachmentsForPostedDocs(var FromRecRef: RecordRef; var ToRecRef: RecordRef; var IsHandled: Boolean)
     var
         FromDocumentAttachment: Record "Document Attachment";
         ToDocumentAttachment: Record "Document Attachment";
         FromFieldRef: FieldRef;
         ToFieldRef: FieldRef;
         FromDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
         FromNo: Code[20];
         ToNo: Code[20];
     begin
         IsHandled := true;

         FromDocumentAttachment.SetRange("Table ID", FromRecRef.Number);

         FromFieldRef := FromRecRef.Field(1);
         FromDocumentType := FromFieldRef.Value();
         FromDocumentAttachment.SetRange("Document Type", FromDocumentType);

         FromFieldRef := FromRecRef.Field(3);
         FromNo := FromFieldRef.Value();
         FromDocumentAttachment.SetRange("No.", FromNo);

         // Find any attached docs for headers (sales / purch)
         if FromDocumentAttachment.FindSet() then begin
             repeat
                 Clear(ToDocumentAttachment);
                 ToDocumentAttachment.Init();
                 ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                 ToDocumentAttachment.Validate("Table ID", ToRecRef.Number);

                 ToFieldRef := ToRecRef.Field(3);
                 ToNo := ToFieldRef.Value();
                 ToDocumentAttachment.Validate("No.", ToNo);
                 ToDocumentAttachment.Validate("Attached Date", CurrentDateTime);
                 if IsNullGuid(ToDocumentAttachment."Attached By") then
                     ToDocumentAttachment."Attached By" := UserSecurityId;
                 Clear(ToDocumentAttachment."Document Type");
                 ToDocumentAttachment.Insert;
             until FromDocumentAttachment.Next() = 0;
         end;
     end;*/

    //B2BMSOn06Oct2022>>
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDownAttachDoc(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        PurchRcptHdr: Record "Purch. Rcpt. Header";
    begin
        case DocumentAttachment."Table ID" of
            0:
                exit;
            DATABASE::"Purch. Rcpt. Header":
                begin
                    RecRef.Open(DATABASE::"Purch. Rcpt. Header");
                    if PurchRcptHdr.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PurchRcptHdr);
                end;
        end;
    end;
    //B2BMSOn06Oct2022<<

    procedure CreateFAMovememt(var IndentLine: Record "Indent Line")
    var
        FAMovementForm: Page "FA Movements Confirmation";
    begin
        FAMovementForm.Set(IndentLine);
        if FAMovementForm.RunModal = ACTION::Yes then begin
            FAMovementForm.ReturnPostingInfo(IssuedDateTime, IssuedTo, FromLocation, ToLocation, Comment);
            if Comment = '' then
                Error('Comment must have a value');
            if IssuedDateTime = 0DT then
                Error('Issued Date Time must have a value');
            if FromLocation = '' then
                Error('From Location must have a value');
            if ToLocation = '' then
                Error('To Location must have a value');

            if FromLocation = ToLocation then
                Error('From location and To location  must not be same value');
            InsertMovementEntries(IndentLine, IssuedDateTime, IssuedTo, FromLocation, ToLocation, Comment);
            Commit();
            Message('FA Movement created Sucessfully');
        end;
    end;

    procedure InsertMovementEntries(IndentLine: Record "Indent Line";
        IssuedDateTime: DateTime;
        IssuedTo: Text[50];
        FromLocation: Code[20];
        ToLocation: Code[20];
        Comment: Text[500])
    var
        InsertFAMovements: Record "Fixed Asset Movements";
        FAMovements: Record "Fixed Asset Movements";
        EntryNo: Integer;
    begin
        FAMovements.Reset();
        if FAMovements.FindLast() then
            EntryNo := FAMovements."Entry No." + 1
        else
            EntryNo := 1;
        InsertFAMovements.Init();
        InsertFAMovements."Entry No." := EntryNo;
        InsertFAMovements."FA No." := IndentLine."No.";
        InsertFAMovements."Document No." := IndentLine."Document No.";
        InsertFAMovements."Document Line No." := IndentLine."Line No.";
        InsertFAMovements."Issue to User Id" := IssuedTo;
        InsertFAMovements."Issued Date Time" := IssuedDateTime;
        InsertFAMovements."Created Date Time" := CurrentDateTime;
        InsertFAMovements."From Location" := FromLocation;
        InsertFAMovements."To Location" := ToLocation;
        InsertFAMovements.Comment := Comment;
        InsertFAMovements.Insert();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostCombineSalesOrderShipment', '', false, false)]
    local procedure OnAfterPostCombineSalesOrderShipment(var PurchaseHeader: Record "Purchase Header"; var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        CFactor: Decimal;
        LCDetail: Record "LC Details";
        LCOrder: Record "LC Orders";
        Text13701: label 'The LC that you have attached is expired.';
        Text13702: Label 'The order value %1 cannot be greater than the LC remaining value %2.';
    begin
        IF (PurchaseHeader."LC No." <> '') AND PurchaseHeader.Receive THEN BEGIN
            IF PurchaseHeader."Currency Factor" <> 0 THEN
                CFactor := PurchaseHeader."Currency Factor"
            ELSE
                CFactor := 1;
            LCDetail.GET(PurchaseHeader."LC No.");
            IF PurchaseHeader."Expected Receipt Date" > LCDetail."Expiry Date" THEN
                ERROR(Text13701);
            PurchaseHeader.CALCFIELDS("Amount");
            LCDetail.CALCFIELDS("Value Utilised");
            LCOrder.SETRANGE("LC No.", PurchaseHeader."LC No.");
            LCOrder.SETRANGE("Order No.", PurchaseHeader."No.");
            IF NOT LCOrder.FINDFIRST THEN BEGIN
                IF (PurchaseHeader."Amount" / CFactor) > (LCDetail."Latest Amended Value" - LCDetail."Value Utilised") THEN
                    ERROR(Text13702, PurchaseHeader."Amount" / CFactor, (LCDetail."Latest Amended Value" - LCDetail."Value Utilised"));
                LCOrder.INIT;
                LCOrder."LC No." := LCDetail."No.";
                LCOrder."Transaction Type" := LCDetail."Transaction Type";
                LCOrder."Issued To/Received From" := LCDetail."Issued To/Received From";
                LCOrder."Order No." := PurchaseHeader."No.";
                LCOrder."Shipment Date" := PurchaseHeader."Expected Receipt Date";
                LCOrder."Order Value" := PurchaseHeader."Amount" / CFactor;
                LCOrder.INSERT;
                LCDetail.Validate("LC Value"); //B2BMSOn06Oct2022
                LCDetail.Modify(); //B2BMSOn06Oct2022
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostDropOrderShipment', '', false, false)]
    local procedure OnBeforePostDropOrderShipment(var SalesHeader: Record "Sales Header"; var TempDropShptPostBuffer: Record "Drop Shpt. Post. Buffer" temporary)
    var
        CFactor: Decimal;
        LCDetail: Record "LC Details";
        LCOrder: Record "LC Orders";
        Text13700: label 'The LC that you have attached is expired.';
        Text13701: Label 'The order value %1 cannot be greater than the LC remaining value %2.';
    begin
        IF (SalesHeader."LC No." <> '') AND SalesHeader.Ship THEN BEGIN
            IF SalesHeader."Currency Factor" <> 0 THEN
                CFactor := SalesHeader."Currency Factor"
            ELSE
                CFactor := 1;
            LCDetail.GET(SalesHeader."LC No.");
            IF SalesHeader."Shipment Date" > LCDetail."Expiry Date" THEN
                ERROR(Text13700);
            SalesHeader.CALCFIELDS("Amount");
            LCDetail.CALCFIELDS("Value Utilised");
            LCOrder.SETRANGE("LC No.", SalesHeader."LC No.");
            LCOrder.SETRANGE("Order No.", SalesHeader."No.");
            IF NOT LCOrder.FINDFIRST THEN BEGIN
                IF (SalesHeader."Amount" / CFactor) > LCDetail."Latest Amended Value" - LCDetail."Value Utilised" THEN
                    ERROR(Text13701, SalesHeader."Amount" / CFactor, (LCDetail."Latest Amended Value" - LCDetail."Value Utilised"));
                LCOrder.INIT;
                LCOrder."LC No." := LCDetail."No.";
                LCOrder."Transaction Type" := LCDetail."Transaction Type";
                LCOrder."Issued To/Received From" := LCDetail."Issued To/Received From";
                LCOrder."Order No." := SalesHeader."No.";
                LCOrder."Shipment Date" := SalesHeader."Shipment Date";
                LCOrder."Order Value" := SalesHeader."Amount" / CFactor;
                LCOrder.INSERT;
            END;
        END;
    end;

    procedure LCRelease(LCDetail: Record "LC Details")
    var
        Text13700: Label 'Do you want to Release?';
        Text13701: Label 'The LC has been Released.';
        Text13702: Label 'The LC is already Released.';
    begin
        IF CONFIRM(Text13700) THEN
            IF NOT LCDetail.Released THEN BEGIN
                LCDetail.TESTFIELD("LC Value");
                LCDetail.TESTFIELD("LC No.");
                LCDetail.TESTFIELD("Expiry Date");
                LCDetail.VALIDATE("LC Value");
                IF LCDetail."Type of LC" = LCDetail."Type of LC"::Foreign THEN
                    LCDetail.TESTFIELD("Currency Code");
                IF LCDetail."Type of Credit Limit" = LCDetail."Type of Credit Limit"::Revolving THEN
                    LCDetail.TESTFIELD("Revolving Cr. Limit Types");
                LCDetail.Released := TRUE;
                LCDetail.MODIFY;
                MESSAGE(Text13701);
            END ELSE
                MESSAGE(Text13702)
        ELSE
            EXIT;
    end;


    procedure LCClose(LCDetail: Record "LC Details")
    var
        Text13709: Label 'Do you want to close LC ?';
        Text13707: Label 'The LC has been closed.';
        Text13708: Label 'The LC is already closed.';
    begin
        IF CONFIRM(Text13709) THEN
            IF NOT LCDetail.Closed THEN BEGIN
                LCDetail.TESTFIELD(Released);
                LCDetail.Closed := TRUE;
                LCDetail.MODIFY;
                MESSAGE(Text13707);
            END ELSE
                MESSAGE(Text13708)
        ELSE
            EXIT;
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    procedure OnInsertILECostRefNo(VAR NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; VAR ItemLedgEntryNo: Integer)
    var
        IndentLine: Record "Indent Line";
        INDENTHEADER: Record "Indent Header";

    begin
        I := 1;
        NewItemLedgEntry."Indent No." := ItemJournalLine."Indent No.";
        NewItemLedgEntry."Indent Line No." := ItemJournalLine."Indent Line No.";
        NewItemLedgEntry."Qty issue&Return" := ItemJournalLine."Qty issue&Return";//B2BSSD10JUL2023
        if IndentLine.Get(NewItemLedgEntry."Indent No.", NewItemLedgEntry."Indent Line No.") then
            if INDENTHEADER.Get(IndentLine."Document No.") then
                if I = 1 then
                    INDENTHEADER.ArchiveQuantityIssued(INDENTHEADER, IndentLine, NewItemLedgEntry);
        if NewItemLedgEntry."Indent Line No." <> 0 then begin
            IndentLine.Get(NewItemLedgEntry."Indent No.", NewItemLedgEntry."Indent Line No.");
            IndentLine.NoHeadStatusCheck(true);
            IndentLine.Validate("Delivery Location");
            //B2BSSD03MAY2023>>
            if NewItemLedgEntry."Entry Type" = NewItemLedgEntry."Entry Type"::"Negative Adjmt." then begin
                IndentLine."Avail.Qty" := IndentLine."Avail.Qty" - ItemJournalLine.Quantity;
                IndentLine.VALIDATE("Qty To Issue", 0); //B2BMSOn07Nov2022
            end else
                if NewItemLedgEntry."Entry Type" = NewItemLedgEntry."Entry Type"::"Positive Adjmt." then begin
                    IndentLine."Avail.Qty" := IndentLine."Avail.Qty" + ItemJournalLine.Quantity;
                    IndentLine."Qty To Return" := 0; //B2BSSD25JUL2023
                end;
            IndentLine.Modify();
            I += 1;
        end;
    end;

    //B2BMSOn28Oct2022>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnBeforeGetConditionalCardPageID', '', false, false)]
    local procedure OnBeforeGetConditionalCardPageID(RecRef: RecordRef; var CardPageID: Integer; var IsHandled: Boolean);
    var
        IndHdr: Record "Indent Header";
    begin
        case RecRef.Number of
            DATABASE::"Indent Header":
                begin
                    RecRef.SetTable(IndHdr);
                    if not IndHdr."Indent Transfer" then
                        CardPageID := Page::"Indent Header"
                    else
                        CardPageID := Page::"Transfer Indent Header";
                    IsHandled := true;
                end;
        end;
    end;
    //B2BMSOn28Oct2022<<


    //B2BSSD25Jan2023<<
    // [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertTermsConditions(var Rec: Record "Purchase Header")
    Var
        TermsAndConditions: Record "PO Terms And Conditions";
        TermsAndConditionsetup: Record "Terms&ConditionSetUp";
        LineNo: Integer;
    begin
        LineNo := 10000;
        //if Rec."Document Type" = rec."Document Type"::Quote then begin
        TermsAndConditionsetup.Reset();
        //TermsAndConditionsetup.SetRange("Line Type", Rec."Document Type");
        if TermsAndConditionsetup.FindSet then begin
            repeat
                TermsAndConditions.Init();
                TermsAndConditions.DocumentNo := Rec."No.";
                TermsAndConditions.LineNo := LineNo;
                TermsAndConditions.Sequence := TermsAndConditionsetup.Sequence;
                TermsAndConditions.LineType := TermsAndConditionsetup."Line Type";
                TermsAndConditions.Description := TermsAndConditionsetup.Description;
                TermsAndConditions.Insert();
                LineNo += 10000;
            until TermsAndConditionsetup.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnBeforeOnDelete', '', false, false)]
    local procedure OnBeforeOnDelete(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        TermsAndConditions: Record "PO Terms And Conditions";
    begin
        TermsAndConditions.Reset();
        TermsAndConditions.SetRange(DocumentType, TermsAndConditions.DocumentType);
        TermsAndConditions.SetRange(DocumentNo, PurchaseHeader."No.");
        if TermsAndConditions.FindSet() then;
        TermsAndConditions.DeleteAll();
    end;
    //B2BSSD25Jan2023>>

    //B2BSSD16JUN2023>>
    [EventSubscriber(ObjectType::Report, Report::"Copy Fixed Asset", 'OnOnPreReportOnBeforeFA2Insert', '', true, true)]
    local procedure OnOnPreReportOnBeforeFA2Insert(var FixedAsset2: Record "Fixed Asset"; var FixedAsset: Record "Fixed Asset")
    begin
        FixedAsset2."available/Unavailable" := false;
        FixedAsset2."Serial No." := '';
        FixedAsset2."Model No." := ''; //22-04-2025
        FixedAsset2.Make_B2B := ''; //22-04-2025
        FixedAsset2."FA Location Code" := '';
        FixedAsset2."FA Sub Location" := '';
        FixedAsset2.Acquired := false;
        FixedAsset2."QC Enabled B2B" := false;
    end;
    //B2BSSD16JUN2023<<
    //B2BPJ 4thOct23 >>>>>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WhseReceive: Boolean; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WhseShip: Boolean)
    begin
        PurchRcptHeader."Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
        PurchRcptHeader."Vendor Invoice Date" := PurchaseHeader."Vendor Invoice Date";
    end;

    Var
        I: Integer;
    //B2BPJ 4thOct23 <<<<<<<<


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader.Invoice then
            PurchaseHeader.TestField("Posting No. Series");
    end;

    //B2BAJ02012024

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."PO Narration" := PurchaseHeader."PO Narration";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."PO Narration" := GenJournalLine."PO Narration";
    end;

    [EventSubscriber(ObjectType::Table, 1173, 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRefRecpt(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Purch. Rcpt. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"Purch. Inv. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;

    end;

    [EventSubscriber(ObjectType::Page, PAGE::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRefRecpt(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Purch. Rcpt. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    FlowFieldsEditable := false;
                end;
            DATABASE::"Purch. Inv. Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    FlowFieldsEditable := false;
                end;

        end;
    end;


    /* [EventSubscriber(ObjectType::Table, 1173, 'OnAfterInitFieldsFromRecRef', '', false, false)]
     local procedure OnAfterInitFieldsFromRecRefInv(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
     var
         FieldRef: FieldRef;
         RecNo: Code[20];
     begin
         case RecRef.Number of

         end;
     end;

     [EventSubscriber(ObjectType::Page, PAGE::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
     local procedure OnAfterOpenForRecRefInv(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
     var
         FieldRef: FieldRef;
         RecNo: Code[20];
     begin
         case RecRef.Number of

         end;
     end;*/


    //B2BVCOn15Mar2024 >>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeInsertPurchOrderLine', '', false, false)]
    local procedure OnBeforeInsertPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; PurchQuoteLine: Record "Purchase Line"; PurchQuoteHeader: Record "Purchase Header")
    var
        IndentReqLine: Record "Indent Requisitions";
    begin
        if IndentReqLine.Get(PurchOrderLine."Indent Req No", PurchOrderLine."Indent Req Line No") then begin
            IndentReqLine."Requisition Type" := IndentReqLine."Requisition Type"::"Purch Order";
            IndentReqLine."Purch Order No." := PurchOrderLine."Document No.";
            IndentReqLine.Modify;
        end;
    end;
    //B2BVCOn15Mar2024 <<
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeApproveSelectedApprovalRequest', '', false, false)]
    local procedure OnBeforeApproveSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    var
        IndentHead: Record "Indent Header";
        UserSetup: Record "User Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipiants: List of [Text];
        Body: Text;
        Text001: Label 'Please find Indent Number: %1 dt.%2 is raised for the purpose %3 is waiting for your approval.  Please approve the same.';
        Text002: Label 'Please find Indent Requisition Number: %1 dt.%2 is raised for the purpose %3 is waiting for your approval.  Please approve the same.';
        Sub: Label 'Request for Indent Approval';
        Sub1: Label 'Request for Indent Requisition Approval';
        ApprovalEntryLRec: Record "Approval Entry";
        IndentReqHead: Record "Indent Req Header";
        PurchaseHeader: Record "Purchase Header";
        Text003: Label 'Please find Purchase Order Number: %1 dt.%2 is waiting for your approval.  Please approve the same.';
        Sub2: Label 'Request for Purchase Order Approval';

    begin
        ApprovalEntryLRec.Reset();
        ApprovalEntryLRec.SetRange("Document No.", ApprovalEntry."Document No.");
        ApprovalEntryLRec.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        ApprovalEntryLRec.SetRange(Status, ApprovalEntry.Status::Created);
        if ApprovalEntryLRec.FindFirst() then begin
            if IndentHead.Get(ApprovalEntry."Document No.") then begin
                UserSetup.Get(ApprovalEntryLRec."Approver ID");
                UserSetup.TestField("E-Mail");
                Recipiants.Add(UserSetup."E-Mail");
                Body += StrSubstNo(Text001, IndentHead."No.", IndentHead."Document Date", IndentHead.Purpose);
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
            end else
                if IndentReqHead.Get(ApprovalEntry."Document No.") then begin
                    UserSetup.Get(ApprovalEntryLRec."Approver ID");
                    UserSetup.TestField("E-Mail");
                    Recipiants.Add(UserSetup."E-Mail");
                    Body += StrSubstNo(Text002, IndentReqHead."No.", IndentReqHead."Document Date", IndentReqHead.Purpose);
                    EmailMessage.Create(Recipiants, Sub1, '', true);
                    EmailMessage.AppendToBody('Dear Sir/Madam,');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody(Body);
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('This is auto generated mail by system for approval information.');
                    Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                    Message('Email Send Successfully');
                end else
                    if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, ApprovalEntry."Document No.") then begin
                        UserSetup.Get(ApprovalEntryLRec."Approver ID");
                        UserSetup.TestField("E-Mail");
                        Recipiants.Add(UserSetup."E-Mail");
                        Body += StrSubstNo(Text003, PurchaseHeader."No.", PurchaseHeader."Document Date");
                        EmailMessage.Create(Recipiants, Sub2, '', true);
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
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterRejectSelectedApprovalRequest', '', false, false)]
    local procedure OnAfterRejectSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        IndentHead: Record "Indent Header";
        UserSetup: Record "User Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipiants: List of [Text];
        Body: Text;
        Text001: Label 'Please find Indent Number: %1 dt.%2 is raised for the purpose %3 has been rejected / returned by your HOD with the comments %4';
        Text002: Label 'Please find Indent Requisition Number: %1 dt.%2 is raised for the purpose %3 has been rejected / returned by your HOD with the comments %4';
        Sub: Label 'Indent Approval Status';
        ApprovalEntryLRec: Record "Approval Entry";
        ApprovalCommentLine: Record "Approval Comment Line";
        IndentReqHead: Record "Indent Req Header";
        PurchaseHeader: Record "Purchase Header";
        Text003: Label 'Please find Purchase Order Number: %1 dt.%2 has been rejected / returned by your HOD with the comments.%3';
        Sub2: Label 'Request for Purchase Order Approval';
    begin
        ApprovalCommentLine.Reset();
        ApprovalCommentLine.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalCommentLine.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        if ApprovalCommentLine.FindFirst() then;
        ApprovalEntryLRec.Reset();
        ApprovalEntryLRec.SetRange("Document No.", ApprovalEntry."Document No.");
        ApprovalEntryLRec.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        if ApprovalEntryLRec.FindFirst() then begin
            if IndentHead.Get(ApprovalEntry."Document No.") then begin
                UserSetup.Get(IndentHead."User Id");
                UserSetup.TestField("E-Mail");
                Recipiants.Add(UserSetup."E-Mail");
                Body += StrSubstNo(Text001, IndentHead."No.", IndentHead."Document Date", IndentHead.Purpose, ApprovalCommentLine.Comment);
                EmailMessage.Create(Recipiants, Sub, '', true);
                EmailMessage.AppendToBody('Dear Indenter,');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody(Body);
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('This is auto generated mail by system for information.');
                Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                Message('Email Send Successfully');
            end else
                if IndentReqHead.Get(ApprovalEntry."Document No.") then begin
                    IndentHead.Get(IndentReqHead."Indent No.");
                    UserSetup.Get(IndentHead."User Id");
                    UserSetup.TestField("E-Mail");
                    Recipiants.Add(UserSetup."E-Mail");
                    Body += StrSubstNo(Text001, IndentReqHead."No.", IndentReqHead."Document Date", IndentReqHead.Purpose, ApprovalCommentLine.Comment);
                    EmailMessage.Create(Recipiants, Sub, '', true);
                    EmailMessage.AppendToBody('Dear Indenter,');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody(Body);
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('This is auto generated mail by system for information.');
                    Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                    Message('Email Send Successfully');
                end else
                    if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, ApprovalEntry."Document No.") then begin
                        UserSetup.Get(ApprovalEntryLRec."Approver ID");
                        UserSetup.TestField("E-Mail");
                        Recipiants.Add(UserSetup."E-Mail");
                        Body += StrSubstNo(Text003, PurchaseHeader."No.", PurchaseHeader."Document Date", ApprovalCommentLine.Comment);
                        EmailMessage.Create(Recipiants, Sub2, '', true);
                        EmailMessage.AppendToBody('Dear Indenter,');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody(Body);
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('This is auto generated mail by system for information.');
                        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                        Message('Email Send Successfully');
                    end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterDelegateApprovalRequest', '', false, false)]
    local procedure OnAfterDelegateApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        IndentHead: Record "Indent Header";
        UserSetup: Record "User Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipiants: List of [Text];
        Body: Text;
        Text001: Label 'Please find Indent Number: %1 dt.%2 is raised for the purpose %3 has been Delegated for Approval. Please Approve the same.';
        Text002: Label 'Please find Indent Requisition Number: %1 dt.%2 is raised for the purpose %3 has been Delegated for Approval. Please Approve the same.';
        Sub: Label 'Indent Approval Status';
        Sub1: Label 'Indent Requisition Approval Status';
        ApprovalEntryLRec: Record "Approval Entry";
        IndentReqHead: Record "Indent Req Header";
        ApprovalUserSetup: Record "User Setup";
        Text003: Label 'Please find Purchase Order Number: %1 dt.%2 has been Delegated for Approval. Please Approve the same.';
        Sub2: Label 'Purchase Order Approval Status';
        PurchaseHeader: Record "Purchase Header";
    begin
        ApprovalEntryLRec.Reset();
        ApprovalEntryLRec.SetRange("Document No.", ApprovalEntry."Document No.");
        ApprovalEntryLRec.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        if ApprovalEntryLRec.FindFirst() then begin
            if IndentHead.Get(ApprovalEntry."Document No.") then begin
                if ApprovalUserSetup.Get(ApprovalEntryLRec."Approver ID") then
                    UserSetup.Get(ApprovalUserSetup."Approver ID");
                UserSetup.TestField("E-Mail");
                Recipiants.Add(UserSetup."E-Mail");
                Body += StrSubstNo(Text001, IndentHead."No.", IndentHead."Document Date", IndentHead.Purpose);
                EmailMessage.Create(Recipiants, Sub, '', true);
                EmailMessage.AppendToBody('Dear Sir/Madam,');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody(Body);
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('This is auto generated mail by system for information.');
                Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                Message('Email Send Successfully');
            end else
                if IndentReqHead.Get(ApprovalEntry."Document No.") then begin
                    IndentHead.Get(IndentReqHead."Indent No.");
                    if ApprovalUserSetup.Get(ApprovalEntryLRec."Approver ID") then
                        UserSetup.Get(ApprovalUserSetup."Approver ID");
                    UserSetup.TestField("E-Mail");
                    Recipiants.Add(UserSetup."E-Mail");
                    Body += StrSubstNo(Text001, IndentReqHead."No.", IndentReqHead."Document Date", IndentReqHead.Purpose);
                    EmailMessage.Create(Recipiants, Sub1, '', true);
                    EmailMessage.AppendToBody('Dear Sir/Madam,');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody(Body);
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('<BR></BR>');
                    EmailMessage.AppendToBody('This is auto generated mail by system for information.');
                    Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                    Message('Email Send Successfully');
                end else
                    if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, ApprovalEntry."Document No.") then begin
                        if ApprovalUserSetup.Get(ApprovalEntryLRec."Approver ID") then
                            UserSetup.Get(ApprovalUserSetup."Approver ID");
                        UserSetup.TestField("E-Mail");
                        Recipiants.Add(UserSetup."E-Mail");
                        Body += StrSubstNo(Text003, PurchaseHeader."No.", PurchaseHeader."Document Date");
                        EmailMessage.Create(Recipiants, Sub2, '', true);
                        EmailMessage.AppendToBody('Dear Sir/Madam,');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody(Body);
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('This is auto generated mail by system for information.');
                        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                        Message('Email Send Successfully');
                    end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', false, false)]
    local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    var
        UserSetup: Record "User Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipiants: List of [Text];
        Body: Text;
        Text001: Label 'Please find Purchase Order Number: %1 dt. %2 has been approved by your HOD.';
        Sub: Label 'Request for Purchase Order Approval';
        ApprovalEntry: Record "Approval Entry";
    begin
        if not PreviewMode then begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
            ApprovalEntry.SetRange("Document Type", PurchaseHeader."Document Type");
            ApprovalEntry.SetRange("Document No.", PurchaseHeader."No.");
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
            if ApprovalEntry.FindLast() then begin
                UserSetup.Get(PurchaseHeader."User Id");
                UserSetup.TestField("E-Mail");
                Recipiants.Add(UserSetup."E-Mail");
                Body += StrSubstNo(Text001, PurchaseHeader."No.", PurchaseHeader."Document Date");
                EmailMessage.Create(Recipiants, Sub, '', true);
                EmailMessage.AppendToBody('Dear Indenter,');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody(Body);
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('<BR></BR>');
                EmailMessage.AppendToBody('This is auto generated mail by system for information.');
                Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                Message('Email Send Successfully');
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure OnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; var PurchaseLine: Record "Purchase Line"; var PurchaseHeader: Record "Purchase Header"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
    begin
        //ItemJournalLine."Shortcut Dimension 3 Code" := PurchaseLine."Shortcut Dimension 3 Code";
        ItemJournalLine.Validate("Shortcut Dimension 3 Code", PurchaseLine."Shortcut Dimension 3 Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."Shortcut Dimension 3 Code" := ItemJournalLine."Shortcut Dimension 3 Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selections", 'OnBeforeGetVendorEmailAddress', '', false, false)]
    local procedure OnBeforeGetVendorEmailAddress(BuyFromVendorNo: Code[20]; var ToAddress: Text; ReportUsage: Option; var IsHandled: Boolean; RecVar: Variant)
    var
        OrderAddress: Record "Order Address";
        RecRef: RecordRef;
        PurchaseHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        Contact: Record Contact;
    begin
        IsHandled := true;
        if ToAddress = '' then begin
            if Contact.Get(BuyFromVendorNo) then
                ToAddress := Contact."E-Mail";
        end;

        if ToAddress = '' then
            if Vendor.Get(BuyFromVendorNo) then
                ToAddress := Vendor."E-Mail";

        OrderAddress.Reset();
        OrderAddress.SetRange("Vendor No.", BuyFromVendorNo);
        OrderAddress.SetRange("Mail Alert", true);
        if OrderAddress.FindSet() then
            repeat
                if ToAddress <> '' then
                    ToAddress += ';' + OrderAddress."E-Mail"
                else
                    ToAddress := OrderAddress."E-Mail";
            until OrderAddress.Next = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeRunPurchPost', '', false, false)]
    local procedure OnBeforeRunPurchPost(var PurchaseHeader: Record "Purchase Header")
    var
        GateEntryHdr: Record "Gate Entry Header_B2B";
        PurchLine: Record "Purchase Line";
        TextLbl: Label 'Please Post the Gate Entry Inward against Document No. %1, Line No. %2';
    begin
        //B2BVCOn28Jun2024 >>
        if PurchaseHeader.Receive then begin
            PurchLine.Reset();
            PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
            PurchLine.SetRange("Document No.", PurchaseHeader."No.");
            if PurchLine.FindSet() then
                repeat
                    if PurchLine.Select then begin
                        PurchLine.TestField("Qty. to Accept B2B");
                        GateEntryHdr.Reset();
                        GateEntryHdr.SetRange("Entry Type", GateEntryHdr."Entry Type"::Inward);
                        GateEntryHdr.SetRange("Purchase Order No.", PurchLine."Document No.");
                        GateEntryHdr.SetRange("Purchase Order Line No.", PurchLine."Line No.");
                        if GateEntryHdr.FindFirst() then
                            Error(TextLbl, GateEntryHdr."Purchase Order No.", GateEntryHdr."Purchase Order Line No.");
                    end;
                    PurchLine.Validate("Qty. to Receive", PurchLine."Qty. to Accept B2B");
                    PurchLine.Modify;
                until PurchLine.Next = 0;
            //B2BVCOn28Jun2024 <<
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PurchLine: Record "Purchase Line";
        //PurchLine: Record "Purchase Line";
        PurchLine1: Record "Purchase Line";
        QuantitytoInvoice: Decimal;
        Text001: Label 'Completed Invioce';
    begin
        //B2BVCOn28Jun2024>>
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchLine.FindSet() then
            repeat
                if PurchLine."Qty. to Accept B2B" <> 0 then begin
                    PurchLine."Quantity Accepted B2B" += PurchLine."Qty. to Accept B2B";
                    PurchLine."Qty. to Accept B2B" := 0;
                    PurchLine.Inward := false;
                    PurchLine.Modify;
                end;
            until PurchLine.Next = 0;
        //B2BVCOn28Jun2024 <<
        //B2BSSD16Aug2024 >>
        PurchLine.Reset();
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchLine.FindFirst() then begin
            repeat
                Clear(QuantitytoInvoice);
                QuantitytoInvoice := PurchLine.Quantity;
                if QuantitytoInvoice = PurchLine."Quantity Invoiced" then
                    PurchLine."Posted Invioce" := true;
                PurchLine.Modify();
            until PurchLine.Next() = 0;

            PurchLine1.Reset();
            PurchLine1.SetRange("Document Type", PurchLine."Document Type"::Order);
            PurchLine1.SetRange("Document No.", PurchLine."Document No.");
            PurchLine1.SetRange("Posted Invioce", false);
            if PurchLine1.FindSet() then begin
                PurchaseHeader.Reset();
                PurchaseHeader.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchaseHeader.SetRange("No.", PurchLine."Document No.");
                if PurchaseHeader.FindFirst() then
                    PurchaseHeader."Posted Invioce" := false;
                PurchaseHeader.Modify();
            end else begin
                PurchaseHeader.SetRange("Document Type", PurchLine."Document Type"::Order);
                PurchaseHeader.SetRange("No.", PurchLine."Document No.");
                if PurchaseHeader.FindFirst() then
                    PurchaseHeader."Posted Invioce" := true;
                PurchaseHeader.Modify();
            end;
        end;
        //B2BSSD16Aug2024 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeSendEmail', '', false, false)]
    local procedure OnBeforeSendEmail(var TempEmailItem: Record "Email Item" temporary; var IsFromPostedDoc: Boolean; var PostedDocNo: Code[20]; var HideDialog: Boolean; var ReportUsage: Integer; var EmailSentSuccesfully: Boolean; var IsHandled: Boolean; EmailDocName: Text[250]; SenderUserID: Code[50]; EmailScenario: Enum "Email Scenario")
    var
        DocumentAttachment: Record "Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        AttcahmentInstream: InStream;
        AttchmentOutStream: OutStream;
        FilePathName: Text;
        TempFile: File;
        FileName: Text;
        FileMngt: Codeunit "File Management";
        PurchLine: Record "Purchase Line";
    begin
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("No.", PostedDocNo);
        DocumentAttachment.SetRange("Document Type", DocumentAttachment."Document Type"::Order);
        DocumentAttachment.SetRange(Select, true);
        if DocumentAttachment.FindSet() then begin
            repeat
                Clear(FilePathName);
                Clear(FileName);
                Clear(TempFile);
                FilePathName := DocumentAttachment."File Path";
                TempFile.Open(FilePathName);
                TempFile.CreateInStream(AttcahmentInstream);
                TempBlob.CreateOutStream(AttchmentOutStream, TextEncoding::UTF8);
                CopyStream(AttchmentOutStream, AttcahmentInstream);
                FileName := DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension";
                //FileName := FileMngt.BLOBExport(TempBlob, FileName, true);
                TempBlob.CreateInStream(AttcahmentInstream);
                TempEmailItem.AddAttachment(AttcahmentInstream, FileName);
            until DocumentAttachment.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Enum Assignment Management", 'OnGetPurchApprovalDocumentType', '', false, false)]
    local procedure OnGetPurchApprovalDocumentType(PurchDocumentType: Enum "Purchase Document Type"; var ApprovalDocumentType: Enum "Approval Document Type"; var IsHandled: Boolean)
    begin
        if PurchDocumentType = PurchDocumentType::Enquiry then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeCheckPurchaseHeaderPendingApproval', '', false, false)]
    local procedure OnBeforeCheckPurchaseHeaderPendingApproval(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Exchange Rate" then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforePrePostApprovalCheckPurch', '', false, false)]
    local procedure OnBeforePrePostApprovalCheckPurch(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Exchange Rate" then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterPostItemJnlLine', '', false, false)]
    local procedure OnAfterPostItemJnlLines(var ItemJournalLine: Record "Item Journal Line"; ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean; var ItemRegister: Record "Item Register"; var ItemLedgEntryNo: Integer; var ItemApplnEntryNo: Integer)
    var
        IndentLine: Record "Indent Line";
        QtyIssued: Decimal;
        ILE: Record "Item Ledger Entry";
        LineCount: Integer;
        CountVar: Integer;
        IndentHdr: Record "Indent Header";
    begin
        //B2BVCOn19Jun2024 >>
        Clear(QtyIssued);
        ILE.Reset();
        ILE.SetRange("Indent No.", ItemLedgerEntry."Indent No.");
        ILE.SetRange("Indent Line No.", ItemLedgerEntry."Indent Line No.");
        ILE.SetFilter(Quantity, '<%1', 0);
        if ILE.FindSet() then begin
            repeat
                QtyIssued += ILE.Quantity;
            until ILE.Next = 0;

            IndentLine.Reset();
            IndentLine.SetRange("Document No.", ILE."Indent No.");
            IndentLine.SetRange("Line No.", ILE."Indent Line No.");
            if IndentLine.FindFirst() then begin
                if IndentLine."Req.Quantity" = Abs(QtyIssued) then begin
                    IndentLine.Closed := true;
                    if IndentLine."ShortClose Status" = IndentLine."ShortClose Status"::" " then
                        IndentLine."ShortClose Status" := IndentLine."ShortClose Status"::Closed;
                    IndentLine.Modify;
                end;
            end;
            LineCount := 0;
            CountVar := 0;
            IndentLine.Reset();
            IndentLine.SetRange("Document No.", ILE."Indent No.");
            IndentLine.SetFilter("No.", '<>%1', '');
            if IndentLine.FindSet() then
                repeat
                    LineCount += 1;
                    IndentLine.CalcFields("Qty Issued");
                    if IndentLine."Req.Quantity" = Abs(IndentLine."Qty Issued") then
                        CountVar += 1;
                until IndentLine.Next = 0;
            if LineCount = CountVar then begin
                if IndentHdr.Get(ILE."Indent No.") then begin
                    if IndentHdr."ShortClose Status" = IndentHdr."ShortClose Status"::" " then
                        IndentHdr."ShortClose Status" := IndentHdr."ShortClose Status"::Closed;
                    IndentHdr.Modify;
                end;
            end;

        end;
        //B2BVCOn19Jun2024 <<
    end;

    //To keep Orders after completely invoiced 
    //using the Below method, sales orders can be kept*********Start*******B2BSSD

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure OnBeforeDeleteAfterPosting(var PurchaseHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var SkipDelete: Boolean; CommitIsSupressed: Boolean; var TempPurchLine: Record "Purchase Line" temporary; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
            SkipDelete := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Post", 'OnBeforeFinalizePosting', '', false, false)]
    local procedure OnBeforeFinalizePosting(var PurchaseHeader: Record "Purchase Header"; var TempPurchLineGlobal: Record "Purchase Line" temporary; var EverythingInvoiced: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        EverythingInvoiced := false;
    end;
    //************END*****************B2BSSD

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        IndentReqHead: Record "Indent Req Header";
    begin
        if IndentReqHead.Get(ApprovalEntry."Document No.") then begin
            IndentReqHead."Last Modified Date" := ApprovalEntry."Last Date-Time Modified";
            IndentReqHead.Modify();
        end;
    end;

    //>>B2BSpon16Aug2024>> savarappa
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', false, false)]
    local procedure OnAfterReleasePurchaseDoc1(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        if PurchaseHeader.Status = PurchaseHeader.Status::Released then begin
            ApprovalEntry.Reset();
            ApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
            ApprovalEntry.SetRange("Document Type", PurchaseHeader."Document Type");
            ApprovalEntry.SetRange("Document No.", PurchaseHeader."No.");
            ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
            if ApprovalEntry.FindLast() then begin
                PurchaseHeader."Draft Date" := DT2Date(ApprovalEntry."Last Date-Time Modified");
                PurchaseHeader.Modify();
            end;

        end;
    end;
    //<<B2BSpon16Aug2024<<savarappa
    //B2BVCOn01Oct2024 >>
    /*  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
     procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line")
     var
         DocAttachment: Record "Document Attachment";
     begin
         DocAttachment.RESET;
         DocAttachment.SETRANGE("No.", PurchaseHeader."No.");
         DocAttachment.SetRange("Table ID", Database::"Purchase Header");
         DocAttachment.SetRange("Document Type", DocAttachment."Document Type"::Order);
         IF NOT DocAttachment.FINDFIRST THEN BEGIN
             ERROR('Attachment missing.  Kindly attach the document to post the Purchase Order No. %1,', PurchaseHeader."No.");
         END
     end; */
    //B2BVCOn01Oct2024 <<
    //B2BSpon20Sep2024 savarappa>> 
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterGetReportSelectionsUsageFromDocumentType', '', false, false)]
    local procedure OnAfterGetReportSelectionsUsageFromDocumentType(PurchaseHeader: Record "Purchase Header"; var ReportSelectionsUsage: Option; var DocTxt: Text[150])
    var
        ReportSelections: Record "Report Selections";
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Enquiry:
                ReportSelectionsUsage := ReportSelections.Usage::"P.Enquiry".AsInteger();

        end;

    end;
    //B2BSpon20Sep2024<<
    //B2BSpon20Sep2024>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Report Distribution Management", 'OnAfterGetFullDocumentTypeText', '', false, false)]
    local procedure OnAfterGetFullDocumentTypeText(DocumentVariant: Variant; var DocumentTypeText: Text[50])
    var
        PurchaseHeader: Record "Purchase Header";
        DocumentRecordRef: RecordRef;
        PurchaseEnquiryDocTypeTxt: Label 'Purchase Enquiry';
    begin
        case DocumentRecordRef.Number of
            DATABASE::"Purchase Header":
                begin
                    case PurchaseHeader."Document Type" of
                        PurchaseHeader."Document Type"::Enquiry:
                            DocumentTypeText := PurchaseEnquiryDocTypeTxt;
                    end;

                end;
        end;
    end;
    //B2BSpon20Sep2024<<
    //B2BSpon20Sep2024>>
    [EventSubscriber(ObjectType::Page, Page::"Report Selection - Purchase", 'OnSetUsageFilterOnAfterSetFiltersByReportUsage', '', false, false)]
    local procedure OnSetUsageFilterOnAfterSetFiltersByReportUsage(ReportUsage2: Enum "Report Selection Usage Purchase"; var Rec: Record "Report Selections")
    begin
        case ReportUsage2 of
            "Report Selection Usage Purchase"::Enquiry:
                Rec.SetRange(Usage, "Report Selection Usage"::"P.Enquiry");
        end;
    end;
    //B2BSpon20Sep2024 savarappa<<
    //BNaveenB2B25092024 >>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeGetEmailSubject', '', false, false)]

    local procedure OnBeforeGetEmailSubject(PostedDocNo: Code[20]; EmailDocumentName: Text[250]; ReportUsage: Integer; var EmailSubject: Text[250]; var IsHandled: Boolean)
    var
        ReportUsageEnum: Enum "Report Selection Usage";
        PurchaseHeaderRec: Record "Purchase Header";
        OrderDate: Date;
        ResponsiblityCenter: Code[10];
    begin
        Clear(OrderDate);
        Clear(ResponsiblityCenter);
        PurchaseHeaderRec.Reset();
        PurchaseHeaderRec.SetRange("No.", PostedDocNo);
        if PurchaseHeaderRec.FindFirst() then begin
            OrderDate := PurchaseHeaderRec."Order Date";
            ResponsiblityCenter := PurchaseHeaderRec."Responsibility Center";
        end;
        ReportUsageEnum := "Report Selection Usage".FromInteger(ReportUsage);

        if ReportUsageEnum <> ReportUsageEnum::"P.Order" then
            exit;
        if not PurchaseHeaderRec.Amendment and not PurchaseHeaderRec.Regularization and not PurchaseHeaderRec."Cancelled Order" then
            EmailSubject := 'Purchase Order ref. No: ' + PostedDocNo + ' dated ' + Format(OrderDate) + ' of ' + ResponsiblityCenter + 'EENADU TELIVISON PRIVATE LIMITED Division.'
        else
            if PurchaseHeaderRec.Amendment and PurchaseHeaderRec.Regularization then
                EmailSubject := 'Amendment cum Regularization Purchase Order ref. No: ' + PostedDocNo + ' dated ' + Format(OrderDate) + ' of ' + ResponsiblityCenter + 'EENADU TELIVISON PRIVATE LIMITED Division.'
            else
                if PurchaseHeaderRec.Amendment and not PurchaseHeaderRec.Regularization then
                    EmailSubject := 'Amendment Purchase Order No: ' + PostedDocNo + ' dated ' + Format(OrderDate) + ' of ' + ResponsiblityCenter + 'EENADU TELIVISON PRIVATE LIMITED Division.'
                else
                    if PurchaseHeaderRec.Regularization and not PurchaseHeaderRec.Amendment then
                        EmailSubject := 'Regularization Purchase Order No: ' + PostedDocNo + ' dated ' + Format(OrderDate) + ' of ' + ResponsiblityCenter + 'EENADU TELIVISON PRIVATE LIMITED Division.'
                    else
                        if PurchaseHeaderRec."Cancelled Order" and not PurchaseHeaderRec.Amendment and not PurchaseHeaderRec.Regularization then
                            EmailSubject := 'Cancellation of Purchase Order No: ' + PostedDocNo + ' dated ' + Format(OrderDate) + ' of ' + ResponsiblityCenter + 'EENADU TELIVISON PRIVATE LIMITED Division.';
        IsHandled := true;

    end;
    //BNaveenB2B25092024 <<
    //Vendor Approvals

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidateBuyFromVendorNo', '', false, false)]
    local procedure OnBeforeValidateBuyFromVendorNo(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; CallingFieldNo: Integer; var SkipBuyFromContact: Boolean)

    //  local procedure OnBeforeValidateBuyFromVendorNo(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; CallingFieldNo: Integer; var SkipBuyFromContact: Boolean; var IsHandled: Boolean)
    var
        vendor: Record Vendor;
    begin
        if vendor.Get(PurchaseHeader."Buy-from Vendor No.") then
            if vendor."Approval Status" <> vendor."Approval Status"::Released then
                Error('Vendor Approval Status must be Released');
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetstatusTPendingApprovalVendor(RecRef: RecordRef; var IsHandled: boolean)
    var
        VendorRec: Record Vendor;
    begin
        case RecRef.Number() of
            Database::Vendor:
                begin
                    RecRef.SetTable(VendorRec);
                    VendorRec."Approval Status" := VendorRec."Approval Status"::"Pending Approval";
                    VendorRec.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleasedocumentVendor(RecRef: RecordRef; var Handled: boolean)
    var
        VendorRec: Record Vendor;
    begin
        case RecRef.Number() of
            Database::Vendor:
                begin
                    RecRef.SetTable(VendorRec);
                    VendorRec."Approval Status" := VendorRec."Approval Status"::Released;
                    VendorRec.Blocked := VendorRec.Blocked::" ";
                    VendorRec.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnopendocumentFAGLJournalLine(RecRef: RecordRef; var Handled: boolean)
    var
        VendorRec: Record Vendor;
    begin
        case RecRef.Number() of
            Database::Vendor:
                begin
                    RecRef.SetTable(VendorRec);
                    VendorRec."Approval Status" := VendorRec."Approval Status"::Open;
                    VendorRec.Blocked := VendorRec.Blocked::All;
                    VendorRec.Modify();
                    Handled := true;
                end;
        end;
    end;

    //customer
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetstatusToPendingApprovalcust(RecRef: RecordRef; var IsHandled: boolean)
    var
        CustomerRec: Record Customer;
    begin
        case RecRef.Number() of
            Database::Customer:
                begin
                    RecRef.SetTable(CustomerRec);
                    CustomerRec."Approval Status" := CustomerRec."Approval Status"::"Pending Approval";
                    CustomerRec.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleasedocumentcust(RecRef: RecordRef; var Handled: boolean)
    var
        CustomerRec: Record Customer;
    begin
        case RecRef.Number() of
            Database::Customer:
                begin
                    RecRef.SetTable(CustomerRec);
                    CustomerRec."Approval Status" := CustomerRec."Approval Status"::Released;
                    CustomerRec.Blocked := CustomerRec.Blocked::" ";
                    CustomerRec.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnopendocumentFAGLJournalLine1(RecRef: RecordRef; var Handled: boolean)
    var
        CustomerRec: Record Customer;
    begin
        case RecRef.Number() of
            Database::Customer:
                begin
                    RecRef.SetTable(CustomerRec);
                    CustomerRec."Approval Status" := CustomerRec."Approval Status"::Open;
                    CustomerRec.Blocked := CustomerRec.Blocked::All;
                    CustomerRec.Modify();
                    Handled := true;
                end;
        end;
    end;

    /*      [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateBuyFromVendorNo', '', false, false)]
     local procedure OnBeforeValidateBuyFromVendorNo(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; CallingFieldNo: Integer; var SkipBuyFromContact: Boolean)

     //  local procedure OnBeforeValidateBuyFromVendorNo(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; CallingFieldNo: Integer; var SkipBuyFromContact: Boolean; var IsHandled: Boolean)
     var
         vendor: Record Vendor;
     begin
         if vendor.Get(PurchaseHeader."Buy-from Vendor No.") then
             if vendor."Approval Status" <> vendor."Approval Status"::Released then
                 Error('Vendor Approval Status must be Released');
     end; */




}





