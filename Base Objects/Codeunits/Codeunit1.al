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
        myInt: Integer;
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
            if IssuedTo = '' then
                Error('Issued To User must have a value');
            if FromLocation = ToLocation then
                Error('From location and To location  must not be same value');
            InsertMovementEntries(IndentLine, IssuedDateTime, IssuedTo, FromLocation, ToLocation, Comment);
            Commit();
            Message('FA Movement created Sucessfully');
        end;
    end;

    local procedure InsertMovementEntries(IndentLine: Record "Indent Line";
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
        with PurchaseHeader do begin
            IF ("LC No." <> '') AND Receive THEN BEGIN
                IF "Currency Factor" <> 0 THEN
                    CFactor := "Currency Factor"
                ELSE
                    CFactor := 1;
                LCDetail.GET("LC No.");
                IF "Expected Receipt Date" > LCDetail."Expiry Date" THEN
                    ERROR(Text13701);
                CALCFIELDS("Amount");
                LCDetail.CALCFIELDS("Value Utilised");
                LCOrder.SETRANGE("LC No.", "LC No.");
                LCOrder.SETRANGE("Order No.", "No.");
                IF NOT LCOrder.FINDFIRST THEN BEGIN
                    IF ("Amount" / CFactor) > (LCDetail."Latest Amended Value" - LCDetail."Value Utilised") THEN
                        ERROR(Text13702, "Amount" / CFactor, (LCDetail."Latest Amended Value" - LCDetail."Value Utilised"));
                    LCOrder.INIT;
                    LCOrder."LC No." := LCDetail."No.";
                    LCOrder."Transaction Type" := LCDetail."Transaction Type";
                    LCOrder."Issued To/Received From" := LCDetail."Issued To/Received From";
                    LCOrder."Order No." := "No.";
                    LCOrder."Shipment Date" := "Expected Receipt Date";
                    LCOrder."Order Value" := "Amount" / CFactor;
                    LCOrder.INSERT;
                    LCDetail.Validate("LC Value"); //B2BMSOn06Oct2022
                    LCDetail.Modify(); //B2BMSOn06Oct2022
                END;
            END;
        end;
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
        with SalesHeader do begin
            IF ("LC No." <> '') AND Ship THEN BEGIN
                IF "Currency Factor" <> 0 THEN
                    CFactor := "Currency Factor"
                ELSE
                    CFactor := 1;
                LCDetail.GET("LC No.");
                IF "Shipment Date" > LCDetail."Expiry Date" THEN
                    ERROR(Text13700);
                CALCFIELDS("Amount");
                LCDetail.CALCFIELDS("Value Utilised");
                LCOrder.SETRANGE("LC No.", "LC No.");
                LCOrder.SETRANGE("Order No.", "No.");
                IF NOT LCOrder.FINDFIRST THEN BEGIN
                    IF ("Amount" / CFactor) > LCDetail."Latest Amended Value" - LCDetail."Value Utilised" THEN
                        ERROR(Text13701, "Amount" / CFactor, (LCDetail."Latest Amended Value" - LCDetail."Value Utilised"));
                    LCOrder.INIT;
                    LCOrder."LC No." := LCDetail."No.";
                    LCOrder."Transaction Type" := LCDetail."Transaction Type";
                    LCOrder."Issued To/Received From" := LCDetail."Issued To/Received From";
                    LCOrder."Order No." := "No.";
                    LCOrder."Shipment Date" := "Shipment Date";
                    LCOrder."Order Value" := "Amount" / CFactor;
                    LCOrder.INSERT;
                END;
            END;
        end;
    end;

    procedure LCRelease(LCDetail: Record "LC Details")
    var
        Text13700: Label 'Do you want to Release?';
        Text13701: Label 'The LC has been Released.';
        Text13702: Label 'The LC is already Released.';
    begin
        WITH LCDetail DO BEGIN
            IF CONFIRM(Text13700) THEN
                IF NOT Released THEN BEGIN
                    TESTFIELD("LC Value");
                    TESTFIELD("LC No.");
                    TESTFIELD("Expiry Date");
                    VALIDATE("LC Value");
                    IF "Type of LC" = "Type of LC"::Foreign THEN
                        TESTFIELD("Currency Code");
                    IF "Type of Credit Limit" = "Type of Credit Limit"::Revolving THEN
                        TESTFIELD("Revolving Cr. Limit Types");
                    Released := TRUE;
                    MODIFY;
                    MESSAGE(Text13701);
                END ELSE
                    MESSAGE(Text13702)
            ELSE
                EXIT;
        END;
    end;


    procedure LCClose(LCDetail: Record "LC Details")
    var
        Text13709: Label 'Do you want to close LC ?';
        Text13707: Label 'The LC has been closed.';
        Text13708: Label 'The LC is already closed.';
    begin
        WITH LCDetail DO BEGIN
            IF CONFIRM(Text13709) THEN
                IF NOT Closed THEN BEGIN
                    TESTFIELD(Released);
                    Closed := TRUE;
                    MODIFY;
                    MESSAGE(Text13707);
                END ELSE
                    MESSAGE(Text13708)
            ELSE
                EXIT;
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    procedure OnInsertILECostRefNo(VAR NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; VAR ItemLedgEntryNo: Integer)
    var
        IndentLine: Record "Indent Line";
    begin
        NewItemLedgEntry."Indent No." := ItemJournalLine."Indent No.";
        NewItemLedgEntry."Indent Line No." := ItemJournalLine."Indent Line No.";

        if NewItemLedgEntry."Indent Line No." <> 0 then begin
            IndentLine.Get(NewItemLedgEntry."Indent No.", NewItemLedgEntry."Indent Line No.");
            IndentLine.NoHeadStatusCheck(true);
            IndentLine.Validate("Delivery Location");
            IndentLine.Modify();
        end;
    end;
}

