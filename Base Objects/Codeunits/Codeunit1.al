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

                    FlowFieldsEditable := false;
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
    begin
        // Triggered when a posted purchase cr. memo / posted purchase invoice is created
        if PurchaseHeader.IsTemporary() then
            exit;

        if PurchRcptHeader.IsTemporary() then
            exit;

        ToRecRef.GetTable(PurchRcptHeader); //B2BMSOn06Oct2022

        FromRecRef.GetTable(PurchaseHeader);

        if ToRecRef.Number > 0 then
            CopyAttachmentsForPostedDocs(FromRecRef, ToRecRef, IsHandled);
    end;

    local procedure CopyAttachmentsForPostedDocs(var FromRecRef: RecordRef; var ToRecRef: RecordRef; var IsHandled: Boolean)
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
    end;

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
    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterInsertEvent', '', false, false)]
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
        FixedAsset2."Model No." := '';
        FixedAsset2.Make_B2B := '';
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeInsertPurchOrderLine', '', false, false)]
    local procedure OnBeforeInsertPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; PurchQuoteLine: Record "Purchase Line"; PurchQuoteHeader: Record "Purchase Header")
    var
        IndentRequisition: Record "Indent Requisitions";
    begin
        IndentRequisition.Reset();
        IndentRequisition.SetRange("Document No.", PurchOrderLine."Indent Req No");
        IndentRequisition.SetRange("Line No.", PurchOrderLine."Indent Req Line No");
        if IndentRequisition.FindFirst() then begin
            IndentRequisition."Requisition Type" := IndentRequisition."Requisition Type"::"Purch Order";
            IndentRequisition."Purch Order No." := PurchOrderLine."Document No.";
            IndentRequisition.Modify;
        end;
    end;

}





