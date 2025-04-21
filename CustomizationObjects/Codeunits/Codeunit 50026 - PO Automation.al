codeunit 50026 "PO Automation"
{
    trigger OnRun();
    begin
    end;

    var
        Text001: Label 'Do you want to create Indent for Template %1?';
        Text002: Label 'Indent %1 Created';
        Item: Record 27;
        Text005: Label '"Rating of payment term code  ''%1'' Should not be zero "';
        Text006: Label 'Payment Term Code  should not be blank in Quotation No: %1';
        CreateIndents4: Record "Indent Requisitions";
        ItemUnitofMeasure: Record 5404;
        ConversionQty: Decimal;
        CreateIndents5: Record "Indent Requisitions";
        TEXT50050: Label 'Vendor No. must have Value in Lines.';

    procedure CreateIndents(TemplateName: Code[20]; "Jnl.BatchName": Code[20]);
    var
        IndentHeader: Record "Indent Header";
        IndentLine: Record "Indent Line";
        ReqLine: Record 246;
        PPSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF NOT CONFIRM(Text001, FALSE, TemplateName) THEN
            EXIT;
        ReqLine.SETRANGE("Worksheet Template Name", TemplateName);
        ReqLine.SETRANGE("Journal Batch Name", "Jnl.BatchName");
        IF ReqLine.FIND('-') THEN BEGIN
            IndentHeader.INIT;
            PPSetup.GET;
            IndentHeader."No." := NoSeriesMgt.GetNextNo(PPSetup."Indent Nos.", WORKDATE, TRUE);
            IndentHeader."Due Date" := ReqLine."Due Date";
            IndentHeader."Document Date" := WORKDATE;
            IndentHeader."Delivery Location" := ReqLine."Location Code";
            IndentHeader."User Id" := USERID;
            IndentHeader."Indent Status" := IndentHeader."Indent Status"::Indent;
            IndentHeader.INSERT;
            REPEAT
                IndentLine.INIT;
                IndentLine."Line No." := IndentLine."Line No." + 10000;
                IndentLine."Document No." := IndentHeader."No.";
                IndentLine."No." := ReqLine."No.";
                IndentLine.VALIDATE("No.");
                IndentLine."Req.Quantity" := ReqLine.Quantity;
                IndentLine.VALIDATE("Req.Quantity");
                IndentLine."Due Date" := ReqLine."Due Date";
                IndentLine."Delivery Location" := ReqLine."Location Code";
                IndentLine."Indent Status" := IndentLine."Indent Status"::Indent;
                IndentLine.INSERT;
            UNTIL ReqLine.NEXT = 0;
        END;
        MESSAGE(Text002, IndentHeader."No.");
        ReqLine.DELETEALL;
    end;

    procedure GetIndentLines();
    var
        CreateIndents: Record "Indent Requisitions";
        IndentLine: Record "Indent Line";
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        PPsetup: Record 312;
    begin
        CreateIndents.RESET;
        CreateIndents.DELETEALL;
        IndentLine.RESET;
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
        IndentLine.SETRANGE("Release Status", IndentLine."Release Status"::Released);
        IF IndentLine.FIND('-') THEN
            REPEAT
                PPsetup.GET;
                IF PPsetup."Cumulation of Indents" THEN BEGIN
                    CreateIndents.RESET;
                    CreateIndents.SETRANGE("Item No.", IndentLine."No.");
                    CreateIndents.SETRANGE("Location Code", IndentLine."Delivery Location");
                    CreateIndents.SETRANGE("Variant Code", IndentLine."Variant Code");
                    CreateIndents.SETRANGE("Due Date", IndentLine."Due Date");
                END ELSE BEGIN
                    CreateIndents.RESET;
                    CreateIndents.SETRANGE("Indent No.", IndentLine."Document No.");
                    CreateIndents.SETRANGE("Item No.", IndentLine."No.");
                    CreateIndents.SETRANGE("Location Code", IndentLine."Delivery Location");
                    CreateIndents.SETRANGE("Variant Code", IndentLine."Variant Code");
                    CreateIndents.SETRANGE("Due Date", IndentLine."Due Date");
                    CreateIndents.SETRANGE(Department, IndentLine.Department);
                END;
                IF CreateIndents.FIND('+') THEN BEGIN
                    Item2.RESET;
                    ItemUnitofMeasure.RESET;
                    Item2.GET(IndentLine."No.");
                    ItemUnitofMeasure.GET(IndentLine."No.", IndentLine."Unit of Measure");
                    IF Item2."Base Unit of Measure" <> IndentLine."Unit of Measure" THEN BEGIN
                        IF ItemUnitofMeasure."Qty. per Unit of Measure" <> 0 THEN
                            CreateIndents.Quantity += IndentLine."Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure";
                    END ELSE
                        CreateIndents.Quantity += IndentLine."Req.Quantity";
                    CreateIndents.MODIFY;
                END ELSE BEGIN
                    CreateIndents.INIT;
                    CreateIndents."Line Type" := IndentLine.Type; //ETVPO1.1
                    CreateIndents."Item No." := IndentLine."No.";
                    CreateIndents."Indent No." := IndentLine."Document No.";
                    CreateIndents."Indent Line No." := IndentLine."Line No.";
                    CreateIndents.Description := IndentLine.Description;
                    CreateIndents."Variant Code" := IndentLine."Variant Code";
                    CreateIndents."Variant Description" := IndentLine."Variant Description"; //B2BSCM11JAN2024
                    CreateIndents."Indent Status" := IndentLine."Indent Status";
                    CreateIndents."Release Status" := IndentLine."Release Status";
                    CreateIndents."Due Date" := IndentLine."Due Date";
                    CreateIndents."Location Code" := IndentLine."Delivery Location";
                    CreateIndents."Shortcut Dimension 3 Code" := IndentLine."Shortcut Dimension 3 Code";//B2BKM25APR2024
                    Message('%1..%2', CreateIndents."Location Code", IndentLine."Delivery Location");
                    //CreateIndents."Location Code" := IndentLine.l
                    CreateIndents.Department := IndentLine.Department;
                    Item2.RESET;
                    ItemUnitofMeasure.RESET;
                    Item2.GET(CreateIndents."Item No.");
                    CreateIndents."Vendor No." := IndentLine."Vendor No.";
                    ItemUnitofMeasure.GET(IndentLine."No.", IndentLine."Unit of Measure");
                    IF Item2."Base Unit of Measure" = IndentLine."Unit of Measure" THEN BEGIN
                        CreateIndents."Unit of Measure" := IndentLine."Unit of Measure";
                        CreateIndents.Quantity := IndentLine."Req.Quantity";
                    END ELSE BEGIN
                        CreateIndents."Unit of Measure" := Item2."Base Unit of Measure";
                        IF ItemUnitofMeasure."Qty. per Unit of Measure" <> 0 THEN
                            CreateIndents.Quantity := (IndentLine."Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure");
                    END;
                    CreateIndents.INSERT;
                END;
            UNTIL IndentLine.NEXT = 0;
        CreateIndents.RESET;
    end;

    procedure InsertIndentItemvendor(var CreateIndents: Record "Indent Requisitions"; var Vendor: Record 23);
    var
        indentReqDoc: Record "Indent Req Header";
        IndentVendorItems: Record "Indent Vendor Items";
        ItemVendor: Record 99;
        CreateIndentsLocal: Record "Indent Requisitions";
        Text000: Label 'Default Vendor is not Mentioned In the Vendor Item Catalog For  Item No ''%1''';
        Text001: Label 'First Select Vendor';
    begin
        IndentVendorItems.DELETEALL;
        //CreateIndents.COPYFILTERS(CreateIndentsLocal);
        IF (Vendor.FIND('-')) THEN begin
            repeat
                IF CreateIndents.FIND('-') THEN
                    REPEAT
                        IndentVendorItems.INIT;
                        IndentVendorItems."Line Type" := CreateIndents."Line Type"; //ETVPO1.1
                        IndentVendorItems."Item No." := CreateIndents."Item No.";
                        IndentVendorItems.Quantity := CreateIndents."Qty. To Order";//B2BSCM12SEP2023
                        IndentVendorItems."Variant Code" := CreateIndents."Variant Code";
                        IndentVendorItems."Variant Description" := CreateIndents."Variant Description"; //B2BSCM11JAN2024
                        IndentVendorItems."Indent No." := CreateIndents."Indent No.";
                        IndentVendorItems."Indent Line No." := CreateIndents."Indent Line No.";
                        IndentVendorItems."Due Date" := CreateIndents."Due Date";
                        IndentVendorItems.Check := FALSE;
                        IndentVendorItems."Location Code" := CreateIndents."Location Code";
                        IndentVendorItems."Unit Of Measure" := CreateIndents."Unit of Measure";
                        IndentVendorItems.Department := CreateIndents.Department;
                        IndentVendorItems."Indent Req No" := CreateIndents."Document No.";
                        IndentVendorItems."Indent Req Line No" := CreateIndents."Line No.";
                        IndentVendorItems."Shortcut Dimension 1 Code" := CreateIndents."Shortcut Dimension 1 Code"; //B2BPAV
                        IndentVendorItems."Shortcut Dimension 2 Code" := CreateIndents."Shortcut Dimension 2 Code"; //B2BPAV
                        IndentVendorItems."Shortcut Dimension 9 Code" := CreateIndents."Shortcut Dimension 9 Code";//B2BSSD20FEB2023
                        IndentVendorItems."Shortcut Dimension 3 Code" := CreateIndents."Shortcut Dimension 3 Code";
                        IndentVendorItems."Sub Location Code" := CreateIndents."Sub Location Code";
                        //B2BSSD29MAR2023<<
                        indentReqDoc.Reset();
                        indentReqDoc.SetRange("No.", CreateIndents."Document No.");
                        if indentReqDoc.FindFirst() then begin
                            IndentVendorItems."Programme Name" := indentReqDoc."programme Name";
                            IndentVendorItems.Purpose := indentReqDoc.Purpose;
                        end;
                        //B2BSSD29MAR2023>>
                        IndentVendorItems."Spec Id" := CreateIndents."Spec Id";
                        IndentVendorItems."Vendor No." := Vendor."No.";
                        IndentVendorItems.INSERT;
                    // IF NOT (Vendor.FIND('-')) THEN
                    //     ERROR(Text001, IndentVendorItems."Item No.")
                    // ELSE
                    //     REPEAT
                    //         IndentVendorItems."Vendor No." := Vendor."No.";
                    //         IndentVendorItems.INSERT;
                    //     UNTIL Vendor.NEXT = 0;
                    //IndentVendorItems.INSERT;
                    UNTIL CreateIndents.NEXT = 0;
            UNTIL Vendor.NEXT = 0;
        end else
            ERROR(Text001, IndentVendorItems."Item No.");
    end;

    procedure InsertOrderItemvendor(var CreateIndentsLocal: Record "Indent Requisitions");
    var
        IndentVendorItems: Record "Indent Vendor Items";
        ItemVendor: Record 99;
        CreateIndents: Record "Indent Requisitions";
        Text000: Label 'Default Vendor is not Mentioned In the Vendor Item Catalog For  Item No ''%1''';
    begin
        IndentVendorItems.DELETEALL;
        CreateIndents.COPYFILTERS(CreateIndentsLocal);
        IF CreateIndents.FIND('-') THEN
            REPEAT
                IndentVendorItems.INIT;
                IndentVendorItems."Line Type" := CreateIndents."Line Type"; //ETVPO1.1
                IndentVendorItems."Item No." := CreateIndents."Item No.";
                IndentVendorItems.Quantity := CreateIndents.Quantity;
                IndentVendorItems."Variant Code" := CreateIndents."Variant Code";
                IndentVendorItems."Variant Description" := CreateIndents."Variant Description"; //B2BSCM11JAN2024
                IndentVendorItems."Indent No." := CreateIndents."Indent No.";
                IndentVendorItems."Indent Line No." := CreateIndents."Indent Line No.";
                IndentVendorItems."Due Date" := CreateIndents."Due Date";
                IndentVendorItems.Check := FALSE;
                IndentVendorItems."Location Code" := CreateIndents."Location Code";
                IndentVendorItems."Unit Of Measure" := CreateIndents."Unit of Measure";
                IndentVendorItems."Vendor No." := CreateIndents."Vendor No.";
                IndentVendorItems.Department := CreateIndents.Department;
                IndentVendorItems."Indent Req No" := CreateIndents."Document No.";
                IndentVendorItems."Indent Req Line No" := CreateIndents."Line No.";
                IndentVendorItems."Shortcut Dimension 1 Code" := CreateIndents."Shortcut Dimension 1 Code";//B2BPAV
                IndentVendorItems."Shortcut Dimension 2 Code" := CreateIndents."Shortcut Dimension 2 Code";//B2BPAV
                IndentVendorItems."Shortcut Dimension 3 Code" := CreateIndents."Shortcut Dimension 3 Code";//B2BKM25APR2024
                IndentVendorItems.INSERT;
            UNTIL CreateIndents.NEXT = 0;
    end;

    procedure CreateEnquiries(var CreateIndentsEnquiry: Record "Indent Requisitions"; var Vendor: Record 23; var Noseries: Code[20]);
    var
        IndentVendorItems: Record "Indent Vendor Items";
        IndentVendorEnquiry: Record "Indent Vendor Items";
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        NoSeriesMgt: Codeunit 396;
        PPSetup: Record 312;
        CreateIndents2: Record "Indent Requisitions";
        IndentLine: Record "Indent Line";
        indentHeader: Record "Indent Header";//B2BSSD20FEB2023
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        BaseUOMQtyMeasure: Decimal;
        PurchUOMQtyMeasure: Decimal;
        LineNo: Integer;
        PrevVendor: Code[20];
        IndentLineRec: Record "Indent Line";
        IndentReqLine: Record "Indent Requisitions";
        IndentReqHeader: Record "Indent Req Header";
    begin
        PPSetup.GET;
        CreateIndents4.COPYFILTERS(CreateIndentsEnquiry);
        InsertIndentItemvendor(CreateIndentsEnquiry, Vendor);
        IndentVendorItems.Reset();
        IndentVendorItems.SetCurrentKey("Vendor No.");
        IndentVendorItems.SETRANGE(Check, false);
        //IF IndentVendorItems.FIND('-') THEN
        if IndentVendorItems.FindSet() then
            REPEAT
                if PrevVendor <> IndentVendorItems."Vendor No." then begin
                    PrevVendor := IndentVendorItems."Vendor No.";
                    IndentVendorEnquiry.Reset();
                    IndentVendorEnquiry.SETRANGE("Vendor No.", IndentVendorItems."Vendor No.");
                    IndentVendorEnquiry.SETRANGE("Location Code", IndentVendorItems."Location Code");
                    IF IndentVendorEnquiry.FIND('-') THEN BEGIN
                        PurchaseHeader.INIT;
                        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Enquiry;
                        PurchaseHeader."No." := NoSeriesMgt.GetNextNo(Noseries, WORKDATE, TRUE);
                        PurchaseHeader.Insert(true);
                        PurchaseHeader."Buy-from Vendor No." := IndentVendorEnquiry."Vendor No.";
                        PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                        PurchaseHeader."Due Date" := IndentVendorEnquiry."Due Date";
                        PurchaseHeader."Expected Receipt Date" := IndentVendorEnquiry."Due Date";
                        PurchaseHeader.VALIDATE("Expected Receipt Date");
                        PurchaseHeader.VALIDATE("Due Date");
                        PurchaseHeader."Order Date" := WORKDATE;
                        PurchaseHeader."Document Date" := WORKDATE;
                        PurchaseHeader."Indent Requisition No" := IndentVendorEnquiry."Indent Req No";
                        PurchaseHeader."Location Code" := IndentVendorEnquiry."Location Code";
                        PurchaseHeader."Programme Name" := IndentVendorEnquiry."Programme Name";//B2BSSD20MAR2023
                        PurchaseHeader.Purpose := IndentVendorEnquiry.Purpose; //B2BSSD21MAR2023
                        PurchaseHeader.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");//B2BPAV
                        PurchaseHeader.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");//B2BPAV
                        PurchaseHeader.Validate("Shortcut Dimension 9 Code", IndentVendorEnquiry."Shortcut Dimension 9 Code");//B2BSSD21FEB2023
                        PurchaseHeader.Validate("Shortcut Dimension 3 Code", IndentVendorEnquiry."Shortcut Dimension 3 Code");
                        //B2BVCOn30April2024 >>
                        CreateIndents2.Reset();
                        CreateIndents2.SetRange("Document No.", IndentVendorEnquiry."Indent Req No");
                        CreateIndents2.SetRange("Line No.", IndentVendorEnquiry."Indent Req Line No");
                        if CreateIndents2.FindFirst() then begin
                            if IndentReqHeader.Get(CreateIndents2."Document No.") then begin
                                PurchaseHeader."Responsibility Center" := IndentReqHeader."Resposibility Center";
                                PurchaseHeader.Note := IndentReqHeader.Note; //B2BVCOn03Oct2024
                                PurchaseHeader."RFQ No." := IndentReqHeader."RFQ No."; //B2BVCOn11April2025
                            end;
                        end;
                        //B2BVCOn30April2024 <<
                        PurchaseHeader.Modify(true);
                        LineNo := 10000;
                        REPEAT
                            PurchaseLine.INIT;
                            PurchaseLine."Document Type" := PurchaseLine."Document Type"::Enquiry;
                            PurchaseLine."Document No." := PurchaseHeader."No.";
                            PurchaseLine."Line No." := LineNo;
                            PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                            PurchaseLine.VALIDATE("Buy-from Vendor No.");
                            //ETVPO1.1 >>
                            if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Item then
                                PurchaseLine.Type := PurchaseLine.Type::Item
                            else
                                if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"Fixed Assets" then
                                    PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset"
                                else
                                    if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"G/L Account" then
                                        PurchaseLine.Type := PurchaseLine.Type::"G/L Account"
                                    else
                                        //B2BSSD09Feb2023<<
                                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Description then
                                            PurchaseLine.Type := PurchaseLine.Type::Description
                                        else
                                            if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Resource then
                                                PurchaseLine.Type := PurchaseLine.Type::Resource;
                            //B2BSSD09Feb2023>>
                            //ETVPO1.1 <<
                            PurchaseLine."No." := IndentVendorEnquiry."Item No.";
                            PurchaseLine.VALIDATE(PurchaseLine."No.");
                            PurchaseLine."Variant Code" := IndentVendorEnquiry."Variant Code";
                            PurchaseLine."Variant Description" := IndentVendorEnquiry."Variant Description"; //B2BSCM11JAN2024
                            IF Item2.GET(PurchaseLine."No.") THEN;
                            IF Item2."Purch. Unit of Measure" <> IndentVendorEnquiry."Unit Of Measure" THEN BEGIN
                                ItemUnitofMeasure.RESET;
                                IF ItemUnitofMeasure.GET(PurchaseLine."No.", Item2."Purch. Unit of Measure") THEN
                                    PurchUOMQtyMeasure := ItemUnitofMeasure."Qty. per Unit of Measure";
                                ItemUnitofMeasure.RESET;
                                IF ItemUnitofMeasure.GET(PurchaseLine."No.", IndentVendorEnquiry."Unit Of Measure") THEN
                                    BaseUOMQtyMeasure := ItemUnitofMeasure."Qty. per Unit of Measure";
                                if PurchUOMQtyMeasure <> 0 then
                                    IndentVendorEnquiry.Quantity := IndentVendorEnquiry.Quantity / PurchUOMQtyMeasure;
                            END;
                            PurchaseLine.VALIDATE(Quantity, IndentVendorEnquiry.Quantity);
                            PurchaseLine."Indent No." := IndentVendorEnquiry."Indent No.";
                            PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Line No.";
                            PurchaseLine."Indent Req No" := IndentVendorEnquiry."Indent Req No"; //B2BMSOn21Sep2022
                            PurchaseLine."Indent Req Line No" := IndentVendorEnquiry."Indent Req Line No"; //B2BMSOn21Sep2022
                            PurchaseLine."Location Code" := IndentVendorEnquiry."Location Code";
                            PurchaseLine."Sub Location Code" := IndentVendorEnquiry."Sub Location Code";
                            PurchaseLine."Spec Id" := IndentVendorEnquiry."Spec Id";
                            PurchaseLine."Unit of Measure Code" := IndentVendorEnquiry."Unit Of Measure";//B2BSSD20APR2023
                            PurchaseLine."Shortcut Dimension 3 Code" := IndentVendorEnquiry."Shortcut Dimension 3 Code";//B2BKM25APR2024


                            IndentLineRec.Reset();
                            IndentLineRec.SetRange("Document No.", PurchaseLine."Indent No.");
                            IndentLineRec.SetRange("Line No.", PurchaseLine."Indent Line No.");
                            if IndentLineRec.FindSet() then begin
                                repeat
                                    //    SetSelectionFilter(IndentLineRec);

                                    IndentLineRec.Status := IndentLineRec.Status::Enqiury;
                                    IndentLineRec.Modify();
                                until IndentLineRec.Next() = 0;
                            end;



                            LineNo += 10000;//B2BSSD13APR2023

                            //B2BSSD03Feb2023>>
                            CreateIndents2.Reset();
                            CreateIndents2.SetRange("Document No.", IndentVendorEnquiry."Indent Req No");
                            CreateIndents2.SetRange("Line No.", IndentVendorEnquiry."Indent Req Line No");
                            CreateIndents2.SetRange("Item No.", IndentVendorEnquiry."Item No.");
                            if CreateIndents2.FindFirst() then
                                PurchaseLine.Validate("Indentor Description", CreateIndents2."Indentor Description");
                            PurchaseLine.Description := CreateIndents2.Description;//B2BSSD20APR2023
                            //B2BSSD03Feb2023<<

                            PurchaseLine."Shortcut Dimension 1 Code" := IndentVendorEnquiry."Shortcut Dimension 1 Code";
                            PurchaseLine."Shortcut Dimension 2 Code" := IndentVendorEnquiry."Shortcut Dimension 2 Code";
                            PurchaseLine."Shortcut Dimension 9 Code" := IndentVendorEnquiry."Shortcut Dimension 9 Code";//B2BSSD21FEB2023
                            PurchaseLine."Shortcut Dimension 3 Code" := IndentVendorEnquiry."Shortcut Dimension 3 Code";
                            CreateIndents4.RESET;
                            CreateIndents4.COPYFILTERS(CreateIndentsEnquiry);
                            IF CreateIndents4.FINDFIRST THEN
                                REPEAT
                                    CreateIndents4."Document Type" := PurchaseLine."Document Type"::Enquiry.AsInteger();
                                    CreateIndents4."Order No" := PurchaseLine."Document No.";
                                    CreateIndents4.MODIFY;
                                UNTIL CreateIndents4.NEXT = 0;
                            //B2BVCOn15Mar2024 >>
                            if IndentReqLine.Get(PurchaseLine."Indent Req No", PurchaseLine."Indent Req Line No") then begin
                                IndentReqLine."Requisition Type" := IndentReqLine."Requisition Type"::Enquiry;
                                IndentReqLine.Modify();
                            end;
                            //B2BVCOn15Mar2024 <<
                            PurchaseLine.INSERT;
                            IndentVendorEnquiry.Check := TRUE;
                            IndentVendorEnquiry.MODIFY;
                        UNTIL IndentVendorEnquiry.NEXT = 0;
                        CopyTermsandConditionsofVendor(PurchaseHeader);
                        CopyTermsandSpecificationofVendors(PurchaseHeader);
                    END;
                end;
            UNTIL IndentVendorItems.NEXT = 0;
    end;

    //B2BDNRon17thJune>>
    Procedure CopyTermsandConditionsofVendor(PurchaseHeader: Record "Purchase Header")
    Var
        TermsandConditions: Record "PO Terms And Conditions";
        NewTermsandConditions: Record "PO Terms And Conditions";
        VendorRec: Record Vendor;
        LineNo: Integer;
    begin
        VendorRec.Reset();
        VendorRec.SetRange("No.", PurchaseHeader."Buy-from Vendor No.");
        if VendorRec.Findfirst() then begin
            TermsandConditions.reset();
            TermsandConditions.SetRange(DocumentNo, VendorRec."No.");
            TermsandConditions.SetRange(Type, TermsandConditions.Type::"Terms & Conditions"); //B2BVCOn23Sep2024
            if TermsandConditions.FindSet() then
                repeat
                    NewTermsandConditions.Init();
                    NewTermsandConditions.TransferFields(TermsandConditions);
                    NewTermsandConditions.DocumentNo := PurchaseHeader."No.";
                    NewTermsandConditions.DocumentType := PurchaseHeader."Document Type";
                    NewTermsandConditions.Insert(true);
                until TermsandConditions.Next() = 0;
        end;
    end;

    Procedure CopyTermsandConditionsofVendorDoc(OldPurchaseHeader: Record "Purchase Header"; NewPurchaseHeader: Record "Purchase Header")
    Var
        TermsandConditions: Record "PO Terms And Conditions";
        NewTermsandConditions: Record "PO Terms And Conditions";
        VendorRec: Record Vendor;
        LineNo: Integer;
    begin
        TermsandConditions.reset();
        TermsandConditions.SetRange(DocumentNo, OldPurchaseHeader."No.");
        TermsandConditions.SetRange(DocumentType, OldPurchaseHeader."Document Type");
        TermsandConditions.SetRange(Type, TermsandConditions.Type::"Terms & Conditions"); //B2BVCOn23Sep2024
        if TermsandConditions.FindSet() then
            repeat
                NewTermsandConditions.Init();
                NewTermsandConditions.TransferFields(TermsandConditions);
                NewTermsandConditions.DocumentNo := NewPurchaseHeader."No.";
                NewTermsandConditions.DocumentType := NewPurchaseHeader."Document Type";
                NewTermsandConditions.Insert(true);
            until TermsandConditions.Next() = 0;
    end;
    //B2BDNRon17thJune<<
    //B2BVCOn23Sep2024 >>
    procedure CopyTermsandSpecificationofVendors(PurchaseHeader: Record "Purchase Header")
    var
        //TermsandConditions: Record "PO Terms And Conditions";
        //NewTermsandConditions: Record "PO Terms And Conditions";
        POSpecifications: Record "PO Specifications";
        NewPOSpecifications: Record "PO Specifications";
        VendorRec: Record Vendor;
        LineNo: Integer;
    begin
        VendorRec.Reset();
        VendorRec.SetRange("No.", PurchaseHeader."Buy-from Vendor No.");
        if VendorRec.Findfirst() then begin
            POSpecifications.reset();
            POSpecifications.SetRange(DocumentNo, VendorRec."No.");
            POSpecifications.SetRange(Type, POSpecifications.Type::Specifications);
            if POSpecifications.FindSet() then
                repeat
                    NewPOSpecifications.Init();
                    NewPOSpecifications.TransferFields(POSpecifications);
                    NewPOSpecifications.DocumentNo := PurchaseHeader."No.";
                    NewPOSpecifications.DocumentType := PurchaseHeader."Document Type";
                    NewPOSpecifications.Insert(true);
                until POSpecifications.Next() = 0;
        end;
    end;

    procedure CopyTermsandSpecificationsDoc(OldPurchHeader: Record "Purchase Header"; NewPurchHeader: Record "Purchase Header")
    var
        //TermsandConditions: Record "PO Terms And Conditions";
        //NewTermsandConditions: Record "PO Terms And Conditions";
        POSpecifications: Record "PO Specifications";
        NewPOSpecifications: Record "PO Specifications";
        VendorRec: Record Vendor;
        LineNo: Integer;
    begin
        POSpecifications.reset();
        POSpecifications.SetRange(DocumentNo, OldPurchHeader."No.");
        POSpecifications.SetRange(DocumentType, OldPurchHeader."Document Type");
        POSpecifications.SetRange(Type, POSpecifications.Type::Specifications); //B2BVCOn23Sep2024
        if POSpecifications.FindSet() then
            repeat
                NewPOSpecifications.Init();
                NewPOSpecifications.TransferFields(POSpecifications);
                NewPOSpecifications.DocumentNo := NewPurchHeader."No.";
                NewPOSpecifications.DocumentType := NewPurchHeader."Document Type";
                NewPOSpecifications.Insert(true);
            until POSpecifications.Next() = 0;
    end;
    //B2BVCOn23Sep2024 <<

    procedure CreateQuotes(var CreateIndentsQuotes: Record "Indent Requisitions"; var Vendor: Record 23; var Noseries: Code[20]);
    var
        IndentVendorItems: Record "Indent Vendor Items";
        IndentVendorEnquiry: Record "Indent Vendor Items";
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PPSetup: Record 312;
        CreateIndents2: Record "Indent Requisitions";
        IndentLine: Record "Indent Line";
        IndentLineRec: Record "Indent Line";
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        BaseUOMQtyMeasure: Decimal;
        PurchUOMQtyMeasure: Decimal;
        IndentReqLine: Record "Indent Requisitions";
        IndentReqHeader: Record "Indent Req Header";
    begin
        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
        //InsertIndentItemvendor(CreateIndents4, Vendor);
        InsertIndentItemvendor(CreateIndentsQuotes, Vendor); //B2BVCOn15Mar2024
        IndentVendorItems.RESET;
        IndentVendorItems.SETRANGE(Check, FALSE);
        IF IndentVendorItems.FIND('-') THEN
            REPEAT
                IndentVendorEnquiry.SETRANGE("Vendor No.", IndentVendorItems."Vendor No.");
                IndentVendorEnquiry.SETRANGE("Location Code", IndentVendorItems."Location Code");
                IF IndentVendorEnquiry.FIND('-') THEN BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Quote;
                    PPSetup.GET;
                    PurchaseHeader."No." := NoSeriesMgt.GetNextNo(Noseries, WORKDATE, TRUE);
                    PurchaseHeader.INSERT(true);
                    //MESSAGE('Purchaser Quote No %1 ', PurchaseHeader."No.");
                    PurchaseHeader."Buy-from Vendor No." := IndentVendorEnquiry."Vendor No.";
                    PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                    PurchaseHeader."Order Date" := WORKDATE;
                    PurchaseHeader."Document Date" := WORKDATE;
                    PurchaseHeader.VALIDATE("Location Code");
                    PurchaseHeader."Due Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader."Expected Receipt Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader."Indent Requisition No" := IndentVendorEnquiry."Indent Req No";
                    PurchaseHeader.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code"); //B2BPAV
                    PurchaseHeader.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code"); //B2BPAV
                    PurchaseHeader.Validate("Shortcut Dimension 9 Code", IndentVendorEnquiry."Shortcut Dimension 9 Code");//B2BSSD21FEB2023
                    PurchaseHeader.Validate("Shortcut Dimension 3 Code", IndentVendorEnquiry."Shortcut Dimension 3 Code");
                    PurchaseHeader.VALIDATE("Expected Receipt Date");
                    PurchaseHeader.VALIDATE("Due Date");
                    PurchaseHeader."Programme Name" := IndentVendorEnquiry."Programme Name";//B2BSSD20MAR2023
                    PurchaseHeader.Purpose := IndentVendorEnquiry.Purpose; //B2BSSD21MAR2023
                    //B2BVCOn30April2024 >>
                    CreateIndents2.Reset();
                    CreateIndents2.SetRange("Document No.", IndentVendorEnquiry."Indent Req No");
                    CreateIndents2.SetRange("Line No.", IndentVendorEnquiry."Indent Req Line No");
                    if CreateIndents2.FindFirst() then begin
                        if IndentReqHeader.Get(CreateIndents2."Document No.") then begin
                            PurchaseHeader."Responsibility Center" := IndentReqHeader."Resposibility Center";
                            PurchaseHeader."RFQ No." := IndentReqHeader."RFQ No.";
                        end;
                    end;
                    //B2BVCOn30April2024 <<
                    PurchaseHeader.Modify(true);
                    REPEAT
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Quote;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseLine."Line No." + 10000;
                        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseLine.VALIDATE("Buy-from Vendor No.");

                        //ETVPO1.1 >>
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Item then
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"Fixed Assets" then
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"G/L Account" then
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        //ETVPO1.1 <<

                        //B2BSSD16FEB2023<<
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Resource then
                            PurchaseLine.Type := PurchaseLine.Type::Resource;
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Description then
                            PurchaseLine.Type := PurchaseLine.Type::Description;
                        //B2BSSD16FEB2023>>

                        PurchaseLine."No." := IndentVendorEnquiry."Item No.";
                        PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine.VALIDATE("Variant Code", IndentVendorEnquiry."Variant Code");
                        PurchaseLine."Variant Description" := IndentVendorEnquiry."Variant Description"; //B2BSCM11JAN2024
                        IF Item2.GET(PurchaseLine."No.") THEN;
                        IF Item2."Purch. Unit of Measure" <> IndentVendorEnquiry."Unit Of Measure" THEN BEGIN
                            ItemUnitofMeasure.RESET;
                            IF ItemUnitofMeasure.GET(PurchaseLine."No.", Item2."Purch. Unit of Measure") THEN
                                PurchUOMQtyMeasure := ItemUnitofMeasure."Qty. per Unit of Measure";
                            ItemUnitofMeasure.RESET;
                            IF ItemUnitofMeasure.GET(PurchaseLine."No.", IndentVendorEnquiry."Unit Of Measure") THEN
                                BaseUOMQtyMeasure := ItemUnitofMeasure."Qty. per Unit of Measure";
                            //IndentVendorEnquiry.Quantity := IndentVendorEnquiry.Quantity / PurchUOMQtyMeasure;
                            IndentVendorEnquiry.Quantity := IndentVendorEnquiry.Quantity

                        END;


                        //B2BSSD16FEB2023<<
                        CreateIndents2.Reset();
                        CreateIndents2.SetRange("Document No.", IndentVendorEnquiry."Indent Req No");
                        CreateIndents2.SetRange("Line No.", IndentVendorEnquiry."Indent Req Line No");
                        if CreateIndents2.FindFirst() then
                            PurchaseLine.Validate("Indentor Description", CreateIndents2."Indentor Description");
                        PurchaseLine.Description := CreateIndents2.Description;//B2BSSD20APR2023
                        //B2BSSD16FEB2023>>

                        PurchaseLine.VALIDATE(Quantity, IndentVendorEnquiry.Quantity);
                        PurchaseLine."Indent No." := IndentVendorEnquiry."Indent No.";
                        PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Line No.";
                        PurchaseLine."Indent Req No" := IndentVendorEnquiry."Indent Req No"; //B2BMSOn21Sep2022
                        PurchaseLine."Indent Req Line No" := IndentVendorEnquiry."Indent Req Line No"; //B2BMSOn21Sep2022
                        PurchaseLine."Location Code" := IndentVendorEnquiry."Location Code";
                        PurchaseLine."Sub Location Code" := IndentVendorEnquiry."Sub Location Code";
                        PurchaseLine."Unit of Measure Code" := IndentVendorEnquiry."Unit Of Measure";//B2BSSD20APR2023
                        IndentLineRec.Reset();
                        IndentLineRec.SetRange("Document No.", PurchaseLine."Indent No.");
                        IndentLineRec.SetRange("Line No.", PurchaseLine."Indent Line No.");
                        if IndentLineRec.FindSet() then begin
                            repeat
                                //    SetSelectionFilter(IndentLineRec);

                                IndentLineRec.Status := IndentLineRec.Status::Quote;
                                IndentLineRec.Modify();
                            until IndentLineRec.Next() = 0;
                        end;

                        PurchaseLine.VALIDATE("Location Code");
                        CreateIndents4.RESET;
                        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
                        IF CreateIndents4.FIND('-') THEN
                            REPEAT
                                CreateIndents4."Document Type" := PurchaseLine."Document Type"::Quote.AsInteger();
                                CreateIndents4."Order No" := PurchaseLine."Document No.";
                                CreateIndents4.MODIFY;
                            UNTIL CreateIndents4.NEXT = 0;
                        //B2BVCOn15Mar2024 >>
                        if IndentReqLine.Get(PurchaseLine."Indent Req No", PurchaseLine."Indent Req Line No") then begin
                            IndentReqLine."Requisition Type" := IndentReqLine."Requisition Type"::Quote;
                            IndentReqLine.Modify();
                        end;
                        //B2BVCOn15Mar2024 <<
                        PurchaseLine.INSERT;
                        // Message('Indent Line %1', IndentVendorEnquiry."Shortcut Dimension 1 Code");
                        PurchaseLine.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");//B2BPAV
                        PurchaseLine.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");//B2BPAV
                        PurchaseLine.Validate("Shortcut Dimension 9 Code", IndentVendorEnquiry."Shortcut Dimension 9 Code");//B2BSSD21FEB2023
                        PurchaseLine.Validate("Shortcut Dimension 3 Code", IndentVendorEnquiry."Shortcut Dimension 3 Code");
                        PurchaseLine."Spec Id" := IndentVendorEnquiry."Spec Id";
                        PurchaseLine.Modify();
                        IndentVendorEnquiry.Check := TRUE;
                        IndentVendorEnquiry.MODIFY;
                    UNTIL IndentVendorEnquiry.NEXT = 0;
                    CopyTermsandConditionsofVendor(PurchaseHeader);
                    CopyTermsandSpecificationofVendors(PurchaseHeader);
                END;
            UNTIL IndentVendorItems.NEXT = 0;
    end;

    procedure CreateOrder(var CreateIndentsQuotes: Record "Indent Requisitions"; var Vendor: Record 23; var Noseries: Code[20]);
    var
        IndentVendorItems: Record "Indent Vendor Items";
        IndentVendorEnquiry: Record "Indent Vendor Items";
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PPSetup: Record 312;
        CreateIndents2: Record "Indent Requisitions";
        IndentLine: Record "Indent Line";
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        BaseUOMQtyMeasure: Decimal;
        PurchUOMQtyMeasure: Decimal;
        IndentReqLine: Record "Indent Requisitions";
    begin
        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
        //InsertIndentItemvendor(CreateIndents4, Vendor);
        InsertIndentItemvendor(CreateIndentsQuotes, Vendor); //B2BVCOn15Mar2024
        IndentVendorItems.RESET;
        IndentVendorItems.SETRANGE(Check, FALSE);
        IF IndentVendorItems.FIND('-') THEN
            REPEAT
                IndentVendorEnquiry.SETRANGE("Vendor No.", IndentVendorItems."Vendor No.");
                IndentVendorEnquiry.SETRANGE("Location Code", IndentVendorItems."Location Code");
                IF IndentVendorEnquiry.FIND('-') THEN BEGIN
                    PurchaseHeader.INIT;
                    PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                    PPSetup.GET;
                    PurchaseHeader."No." := NoSeriesMgt.GetNextNo(Noseries, WORKDATE, TRUE);
                    MESSAGE('Purchaser Order No %1 ', PurchaseHeader."No.");
                    PurchaseHeader."Buy-from Vendor No." := IndentVendorEnquiry."Vendor No.";
                    PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                    PurchaseHeader."Order Date" := WORKDATE;
                    PurchaseHeader."Document Date" := WORKDATE;
                    PurchaseHeader.VALIDATE("Location Code");
                    PurchaseHeader."Due Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader."Expected Receipt Date" := IndentVendorEnquiry."Due Date";
                    PurchaseHeader.VALIDATE("Expected Receipt Date");
                    PurchaseHeader.VALIDATE("Due Date");
                    PurchaseHeader."Indent Requisition No" := IndentVendorEnquiry."Indent Req No";
                    PurchaseHeader.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");
                    PurchaseHeader.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");
                    PurchaseHeader.Validate("Shortcut Dimension 9 Code", IndentVendorEnquiry."Shortcut Dimension 9 Code");//B2BSSD14MAR2023
                    PurchaseHeader.Validate("Shortcut Dimension 3 Code", IndentVendorItems."Shortcut Dimension 3 Code"); //N2NKM25APR2024
                    PurchaseHeader.INSERT;
                    REPEAT
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseLine."Line No." + 10000;
                        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseLine.VALIDATE("Buy-from Vendor No.");
                        //ETVPO1.1 >>
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Item then
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"Fixed Assets" then
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"G/L Account" then
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        //ETVPO1.1 <<

                        //B2BSSD14MAR2023<<
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Resource then
                            PurchaseLine.Type := PurchaseLine.Type::Resource;
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Description then
                            PurchaseLine.Type := PurchaseLine.Type::Description;
                        //B2BSSD14MAR2023>>
                        PurchaseLine."No." := IndentVendorEnquiry."Item No.";
                        PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine.VALIDATE("Variant Code", IndentVendorEnquiry."Variant Code");
                        PurchaseLine."Variant Description" := IndentVendorEnquiry."Variant Description"; //B2BSCM11JAN2024
                        IF Item2.GET(PurchaseLine."No.") THEN;
                        /*
                        IF Item2."Purch. Unit of Measure"<>IndentVendorEnquiry."Unit of Measure" THEN BEGIN
                          ItemUnitofMeasure.RESET;
                          IF ItemUnitofMeasure.GET(PurchaseLine."No.",Item2."Purch. Unit of Measure") THEN
                            PurchUOMQtyMeasure:=ItemUnitofMeasure."Qty. per Unit of Measure";
                          ItemUnitofMeasure.RESET;
                          IF ItemUnitofMeasure.GET(PurchaseLine."No.",IndentVendorEnquiry."Unit of Measure") THEN
                            BaseUOMQtyMeasure:=ItemUnitofMeasure."Qty. per Unit of Measure";
                            IndentVendorEnquiry.Quantity:=IndentVendorEnquiry.Quantity/PurchUOMQtyMeasure;
                        END;
                        */
                        //PurchaseLine.VALIDATE("Order Quantity",IndentVendorEnquiry.Quantity);
                        PurchaseLine.VALIDATE(Quantity, IndentVendorEnquiry.Quantity);
                        PurchaseLine."Indent No." := IndentVendorEnquiry."Indent No.";
                        PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Line No.";
                        PurchaseLine."Indent Req No" := IndentVendorEnquiry."Indent Req No"; //B2BMSOn21Sep2022
                        PurchaseLine."Indent Req Line No" := IndentVendorEnquiry."Indent Req Line No"; //B2BMSOn21Sep2022
                        PurchaseHeader.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");
                        PurchaseHeader.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");
                        PurchaseHeader.Validate("Shortcut Dimension 9 Code", IndentVendorEnquiry."Shortcut Dimension 9 Code");//B2BSSD14MAR2023
                        PurchaseLine.Validate("Shortcut Dimension 3 Code", IndentVendorEnquiry."Shortcut Dimension 3 Code");//B2BKM25APR2024
                        PurchaseLine."Location Code" := IndentVendorEnquiry."Location Code";
                        PurchaseLine.VALIDATE("Location Code");


                        CreateIndents4.RESET;
                        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
                        IF CreateIndents4.FIND('-') THEN
                            REPEAT
                                CreateIndents4."Document Type" := PurchaseLine."Document Type"::Order.AsInteger();
                                CreateIndents4."Order No" := PurchaseLine."Document No.";
                                CreateIndents4.MODIFY;
                            UNTIL CreateIndents4.NEXT = 0;
                        PurchaseLine.INSERT;
                        IndentVendorEnquiry.Check := TRUE;
                        IndentVendorEnquiry.MODIFY;
                    UNTIL IndentVendorEnquiry.NEXT = 0;
                    CopyTermsandConditionsofVendor(PurchaseHeader);
                    CopyTermsandSpecificationofVendors(PurchaseHeader);
                END;
            UNTIL IndentVendorItems.NEXT = 0;

    end;

    procedure InsertQuotationLines(var RFQNumber: Code[20]);
    var
        PurchaseHeader: Record 38;
        QuoteCompare: Record "Quotation Comparison";
        PurchaseLine: Record 39;
        Amount: Decimal;
        QuoteCompareAmount: Record "Quotation Comparison";
        PreviousItem: Code[20];
        LeastLineAmount: Decimal;
        QuoteCompare1: Record "Quotation Comparison";
        PurchaseSetup: Record 312;
        TotalWeightage: Decimal;
        PaymentTerms: Record 3;
        QuoteCompare2: Record "Quotation Comparison";
        MaxPayment: Decimal;
        Text0010: Label 'Item Price should  not be blank in Quotation No. %1';
        ColourCode: Code[20];
        Text0011: Label 'Quantity should  not be Zero in Quotation No. %1';
        PreviousItemSize: Code[20];
        Q: Record "QuotCompHdr";
    begin
        QuoteCompare.DELETEALL;
        PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
        PurchaseHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchaseHeader.FIND('-') THEN
            REPEAT
                QuoteCompare.INIT;
                QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                QuoteCompare."Quote No." := PurchaseHeader."No.";
                QuoteCompare."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                QuoteCompare."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                QuoteCompare."Item No." := '';
                QuoteCompare.Description := PurchaseHeader."Buy-from Vendor Name";
                QuoteCompare.Quantity := 0;
                QuoteCompare.Rate := 0;
                QuoteCompare.Amount := 0;
                QuoteCompare."Payment Term Code" := '';
                QuoteCompare."Parent Quote No." := '';
                QuoteCompare."Line Amount" := 0;
                QuoteCompare."Delivery Date" := 0D;
                QuoteCompare.Level := 0;
                QuoteCompare."Approval Status" := PurchaseHeader."Approval Status";
                QuoteCompare."Line No." := QuoteCompare."Line No." + 10000;
                QuoteCompare."Location Code" := PurchaseHeader."Location Code";


                QuoteCompare.INSERT;
                Amount := 0;
                PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                IF PurchaseLine.FIND('-') THEN
                    REPEAT
                        QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                        QuoteCompare."Quote No." := '';
                        QuoteCompare."Vendor No." := '';
                        QuoteCompare."Vendor Name" := '';

                        QuoteCompare."Item No." := PurchaseLine."No.";
                        QuoteCompare.Description := PurchaseLine.Description;

                        IF PurchaseLine.Quantity = 0 THEN
                            ERROR(Text0011, PurchaseLine."Document No.");
                        QuoteCompare.Quantity := PurchaseLine.Quantity;
                        QuoteCompare.Rate := PurchaseLine."Direct Unit Cost";
                        IF PurchaseLine."Direct Unit Cost" = 0 THEN
                            ERROR(Text0010, PurchaseLine."Document No.");
                        QuoteCompare.Amount := PurchaseLine."Direct Unit Cost" * PurchaseLine.Quantity;
                        QuoteCompare."Payment Term Code" := PurchaseHeader."Payment Terms Code";
                        QuoteCompare."Delivery Date" := PurchaseHeader."Due Date";
                        QuoteCompare."Indent No." := PurchaseLine."Indent No.";
                        QuoteCompare."Indent Line No." := PurchaseLine."Indent Line No.";
                        QuoteCompare."Indent Req No" := PurchaseLine."Indent Req No";
                        QuoteCompare."Indent Req Line No" := PurchaseLine."Indent Req Line No";
                        QuoteCompare."Location Code" := PurchaseHeader."Location Code";
                        QuoteCompare."Line No." := QuoteCompare."Line No." + 10000;
                        QuoteCompare."Document Date" := PurchaseHeader."Document Date";
                        QuoteCompare."Due Date" := PurchaseHeader."Due Date";
                        QuoteCompare."Requested Receipt Date" := PurchaseHeader."Requested Receipt Date";
                        QuoteCompare."Parent Vendor" := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseSetup.GET;

                        IF PurchaseSetup."Delivery Required" = TRUE THEN
                            QuoteCompare.Delivery
                             := CalculateDelivery(PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseHeader."RFQ No.");
                        IF PurchaseSetup."Quality Required" = TRUE THEN
                            QuoteCompare.Quality := CalculateQuality(PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseHeader."RFQ No.");

                        QuoteCompare.Structure := '';
                        QuoteCompare."Line Amount" := 0;
                        QuoteCompare.Level := 1;
                        QuoteCompare."Parent Quote No." := PurchaseLine."Document No.";

                        IF PurchaseSetup."Payment Terms Required" = TRUE THEN BEGIN
                            IF QuoteCompare."Payment Term Code" = '' THEN
                                ERROR(Text006, QuoteCompare."Parent Quote No.");
                            IF PaymentTerms.GET(QuoteCompare."Payment Term Code") THEN BEGIN
                                PurchaseSetup.GET;
                                QuoteCompare.Rating := PaymentTerms.Rating;
                                IF QuoteCompare.Rating = 0 THEN
                                    ERROR(Text005, QuoteCompare."Payment Term Code");
                            END;
                        END;

                        QuoteCompare."Variant Code" := PurchaseLine."Variant Code";
                        QuoteCompare."Variant Description" := PurchaseLine."Variant Description"; //B2BSCM11JAN2024
                        Item.GET(PurchaseLine."No.");
                        /*IF Item."Excise Accounting Type" = Item."Excise Accounting Type"::"With CENVAT" THEN
                            QuoteCompare."Excise Duty" := 0
                        ELSE
                            QuoteCompare."Excise Duty" := PurchaseLine."Excise Amount";*///Balu
                        IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                            QuoteCompare."Standard Price" := Item."Standard Cost";
                        QuoteCompare."Last Direct Cost" := Item."Last Direct Cost";
                        QuoteCompare.Discount := (PurchaseLine."Line Discount Amount" + PurchaseLine."Inv. Discount Amount");
                        //QuoteCompare.Amount := (PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost") + QuoteCompare."P & F" +
                        //PurchaseLine."Tax Amount" - QuoteCompare.Discount;//Balu
                        Amount := Amount + QuoteCompare.Amount;
                        QuoteCompareAmount.SETRANGE("RFQ No.", QuoteCompare."RFQ No.");
                        QuoteCompareAmount.SETRANGE("Quote No.", PurchaseLine."Document No.");
                        QuoteCompareAmount.SETRANGE(QuoteCompareAmount.Level, 0);
                        IF QuoteCompareAmount.FIND('-') THEN BEGIN
                            QuoteCompareAmount."Total Amount" := Amount;
                            QuoteCompareAmount.MODIFY;
                        END;
                        QuoteCompare.Department := PurchaseLine."Shortcut Dimension 2 Code";
                        QuoteCompare.INSERT;
                    UNTIL PurchaseLine.NEXT = 0;
            UNTIL PurchaseHeader.NEXT = 0;

        PurchaseSetup.GET;
        QuoteCompare.RESET;
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        QuoteCompare.SETCURRENTKEY("Item No.");
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                IF PreviousItem <> QuoteCompare."Item No." THEN BEGIN
                    LeastLineAmount := 0;
                    QuoteCompare1.RESET;
                    QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare1.SETFILTER("Item No.", '<>%1', '');
                    QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare1.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    IF QuoteCompare1.FIND('-') THEN BEGIN
                        LeastLineAmount := QuoteCompare1.Amount;
                        REPEAT
                            IF LeastLineAmount > QuoteCompare1.Amount THEN
                                LeastLineAmount := QuoteCompare1.Amount;
                        UNTIL QuoteCompare1.NEXT = 0;
                        IF QuoteCompare1.FIND('-') THEN
                            REPEAT
                                QuoteCompare1.Price := (LeastLineAmount / QuoteCompare1.Amount * 100) * PurchaseSetup."Price Weightage" / 100;
                                QuoteCompare1.MODIFY;
                            UNTIL QuoteCompare1.NEXT = 0;
                    END;
                END ELSE
                    PreviousItem := QuoteCompare."Item No.";
            UNTIL QuoteCompare.NEXT = 0;


        PurchaseSetup.GET;
        IF PurchaseSetup."Payment Terms Required" = TRUE THEN BEGIN
            QuoteCompare.RESET;
            QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
            QuoteCompare.SETFILTER("Item No.", '<>%1', '');
            QuoteCompare.SETCURRENTKEY("Item No.");
            IF QuoteCompare.FIND('-') THEN
                REPEAT
                    IF PreviousItem <> QuoteCompare."Item No." THEN BEGIN
                        LeastLineAmount := 0;
                        QuoteCompare1.RESET;
                        QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                        QuoteCompare1.SETFILTER("Item No.", '<>%1', '');
                        QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                        IF QuoteCompare1.FIND('-') THEN BEGIN
                            MaxPayment := QuoteCompare1.Rating;
                            REPEAT
                                IF MaxPayment < QuoteCompare1.Rating THEN
                                    MaxPayment := QuoteCompare1.Rating;
                            UNTIL QuoteCompare1.NEXT = 0;
                            IF QuoteCompare1.FIND('-') THEN
                                REPEAT

                                    QuoteCompare1."Payment Terms"
                                    := (QuoteCompare1.Rating / MaxPayment * 100) * PurchaseSetup."Payment Terms Weightage" / 100;
                                    QuoteCompare1.MODIFY;
                                UNTIL QuoteCompare1.NEXT = 0;
                        END;
                    END ELSE
                        PreviousItem := QuoteCompare."Item No.";
                UNTIL QuoteCompare.NEXT = 0;
        END;
        QuoteCompare.RESET;
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        QuoteCompare.SETCURRENTKEY("Item No.");
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                QuoteCompare."Total Weightage" := QuoteCompare.Price + QuoteCompare.Delivery + QuoteCompare.Quality +
                                                   QuoteCompare."Payment Terms";
                QuoteCompare.MODIFY;
            UNTIL QuoteCompare.NEXT = 0;


        //For Selecting the best vendor
        PreviousItem := '';
        QuoteCompare.RESET;
        QuoteCompare.SETCURRENTKEY("RFQ No.", "Item No.", "Variant Code");
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                IF (PreviousItem <> QuoteCompare."Item No.") OR (ColourCode <> QuoteCompare."Variant Code")
               THEN BEGIN
                    PreviousItem := QuoteCompare."Item No.";
                    ColourCode := QuoteCompare."Variant Code";
                    QuoteCompare1.RESET;
                    QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare1.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    IF QuoteCompare1.FIND('-') THEN BEGIN
                        TotalWeightage := QuoteCompare1."Total Weightage";
                        REPEAT
                            IF TotalWeightage < QuoteCompare1."Total Weightage" THEN
                                TotalWeightage := QuoteCompare1."Total Weightage";
                        UNTIL QuoteCompare1.NEXT = 0;
                    END;
                    QuoteCompare2.RESET;
                    QuoteCompare2.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare2.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare2.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    QuoteCompare2.SETRANGE("Total Weightage", TotalWeightage);
                    IF QuoteCompare2.FIND('-') THEN BEGIN
                        QuoteCompare2."Carry Out Action" := TRUE;
                        QuoteCompare2.MODIFY;
                    END;
                END;
            UNTIL QuoteCompare.NEXT = 0;
    end;

    procedure InsertQuotationLinesNew(var RFQNumber: Code[20]; QuotComp: record QuotCompHdr);
    var
        QuoteCompare: Record "Quotation Comparison Test";
        PurchaseLine: Record "Purchase Line";
        PurchaseQuote: Record "Purchase Header";//B2BSSD21FEB2023
        QuotCompHead: Record QuotCompHdr;//B2BSSD21FEB2023
        QuoteCompare1: Record "Quotation Comparison Test";
        PurchaseSetup: Record 312;
        QuoteCompareAmount: Record "Quotation Comparison Test";
        PaymentTerms: Record 3;
        QuoteCompare2: Record "Quotation Comparison Test";
        PreviousItem: Code[20];
        LeastLineAmount: Decimal;
        TotalWeightage: Decimal;
        Amount: Decimal;
        MaxPayment: Decimal;
        Text0010Lbl: Label 'Item Price should  not be blank in Quotation No. %1';
        ColourCode: Code[20];
        Text0011Lbl: Label 'Quantity should  not be Zero in Quotation No. %1';

        Text005Lbl: Label '"Rating of payment term code  ''%1'' Should not be zero "';
        Text006Lbl: Label 'Payment Term Code  should not be blank in Quotation No: %1';
        Line: Integer;
        QuoComparsn: Record "Quotation Comparison Test";
        Lnum: integer;
        Linum: integer;
        Quocom: Record "Quotation Comparison Test";
        Vend: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
        QuoCompHdr: Record QuotCompHdr;
        IndentLineRec: Record "Indent Line";
        TermsandConditions: Record "PO Terms And Conditions";
        POSpecifications: Record "PO Specifications";
    begin
        clear(TotalWeightage);
        PurchaseHeader.RESET();
        PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
        PurchaseHeader.SETRANGE("RFQ No.", RFQNumber);
        IF PurchaseHeader.FIND('-') THEN
            REPEAT
                //PKONJU14 Below Condition Added
                IF Vend.GET(PurchaseHeader."Buy-from Vendor No.") AND (Vend.Blocked = Vend.Blocked::" ") THEN BEGIN
                    QuoteCompare.Reset();
                    QuoteCompare.SetRange("RFQ No.", RFQNumber);
                    IF QuoteCompare.FINDLAST() then
                        Line := QuoteCompare."Line No."
                    else
                        Line := 10000;
                    QuoteCompare.INIT();
                    QuoteCompare."Quot Comp No." := QuotComp."No.";
                    QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                    QuoteCompare."Quote No." := PurchaseHeader."No.";
                    QuoteCompare."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                    QuoteCompare."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                    QuoteCompare."Item No." := '';
                    QuoteCompare.Description := PurchaseHeader."Buy-from Vendor Name";
                    QuoteCompare.Quantity := 0;
                    QuoteCompare.Rate := 0;
                    QuoteCompare.Amount := 0;
                    QuoteCompare."Payment Term Code" := '';
                    QuoteCompare."Parent Quote No." := '';
                    QuoteCompare."Line Amount" := 0;
                    QuoteCompare."Delivery Date" := 0D;
                    QuoteCompare.Level := 0;
                    QuoteCompare."RFQ No." := RFQNumber;
                    QuoteCompare."Line No." := Line + 10000;
                    QuoteCompare."Location Code" := PurchaseHeader."Location Code";
                    QuoteCompare."Parent Quote No." := PurchaseHeader."No.";
                    QuoteCompare."Vendor Quotation No." := PurchaseHeader."Vendor Quotation No."; //B2BVCOn11Mar2024
                    QuoteCompare."Vendor Quotation Date" := PurchaseHeader."Vendor Quotation Date"; //B2BVCOn18Mar2024
                    QuoteCompare."Shortcut Dimension 3 Code" := PurchaseHeader."Shortcut Dimension 3 Code";
                    QuoteCompare.Status := QuoteCompare.Status::Open;
                    QuoteCompare.INSERT();

                    //Inserting PO Terms and Conditions>>
                    TermsandConditions.Reset();
                    TermsandConditions.SetRange(DocumentType, PurchaseHeader."Document Type");
                    TermsandConditions.SetRange(DocumentNo, PurchaseHeader."No.");
                    If TermsandConditions.FindSet() then
                        repeat
                            QuoteCompare.INIT();
                            QuoteCompare.Type := QuoteCompare.Type::Description;
                            QuoteCompare."Quot Comp No." := QuotComp."No.";
                            QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                            QuoteCompare."Quote No." := PurchaseHeader."No.";
                            QuoteCompare."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                            QuoteCompare."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                            QuoteCompare."Item No." := '';
                            QuoteCompare.Description := TermsandConditions.Description;
                            QuoteCompare.Quantity := 0;
                            QuoteCompare.Rate := 0;
                            QuoteCompare.Amount := 0;
                            QuoteCompare."Payment Term Code" := '';
                            QuoteCompare."Parent Quote No." := '';
                            QuoteCompare."Line Amount" := 0;
                            QuoteCompare."Delivery Date" := 0D;
                            QuoteCompare.Level := 0;
                            QuoteCompare."RFQ No." := RFQNumber;
                            QuoteCompare."Line No." := QuoteCompare."Line No." + 10000;
                            QuoteCompare."Location Code" := PurchaseHeader."Location Code";
                            QuoteCompare."Parent Quote No." := PurchaseHeader."No.";
                            QuoteCompare."Vendor Quotation No." := PurchaseHeader."Vendor Quotation No."; //B2BVCOn11Mar2024
                            QuoteCompare."Vendor Quotation Date" := PurchaseHeader."Vendor Quotation Date"; //B2BVCOn18Mar2024
                            QuoteCompare."Shortcut Dimension 3 Code" := PurchaseHeader."Shortcut Dimension 3 Code";
                            QuoteCompare.Status := QuoteCompare.Status::Open;
                            QuoteCompare.INSERT();
                        until TermsandConditions.Next() = 0;
                    //Inserting PO Terms and Conditions<<
                    //Inserting PO Specifications >>
                    POSpecifications.Reset();
                    POSpecifications.SetRange(DocumentType, PurchaseHeader."Document Type");
                    POSpecifications.SetRange(DocumentNo, PurchaseHeader."No.");
                    if POSpecifications.FindSet() then
                        repeat
                            QuoteCompare.INIT();
                            QuoteCompare.Type := QuoteCompare.Type::Description;
                            QuoteCompare."Quot Comp No." := QuotComp."No.";
                            QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                            QuoteCompare."Quote No." := PurchaseHeader."No.";
                            QuoteCompare."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                            QuoteCompare."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                            QuoteCompare."Item No." := '';
                            QuoteCompare.Description := POSpecifications.Description;
                            QuoteCompare.Quantity := 0;
                            QuoteCompare.Rate := 0;
                            QuoteCompare.Amount := 0;
                            QuoteCompare."Payment Term Code" := '';
                            QuoteCompare."Parent Quote No." := '';
                            QuoteCompare."Line Amount" := 0;
                            QuoteCompare."Delivery Date" := 0D;
                            QuoteCompare.Level := 0;
                            QuoteCompare."RFQ No." := RFQNumber;
                            QuoteCompare."Line No." := QuoteCompare."Line No." + 10000;
                            QuoteCompare."Location Code" := PurchaseHeader."Location Code";
                            QuoteCompare."Parent Quote No." := PurchaseHeader."No.";
                            QuoteCompare."Vendor Quotation No." := PurchaseHeader."Vendor Quotation No."; //B2BVCOn11Mar2024
                            QuoteCompare."Vendor Quotation Date" := PurchaseHeader."Vendor Quotation Date"; //B2BVCOn18Mar2024
                            QuoteCompare."Shortcut Dimension 3 Code" := PurchaseHeader."Shortcut Dimension 3 Code";
                            QuoteCompare.Status := QuoteCompare.Status::Open;
                            QuoteCompare.INSERT();
                        until POSpecifications.Next = 0;

                    Amount := 0;
                    PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                    //PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);//TEST
                    IF PurchaseLine.FIND('-') THEN
                        REPEAT
                            QuoteCompare."RFQ No." := PurchaseHeader."RFQ No.";
                            QuoteCompare."Quot Comp No." := QuotComp."No.";
                            QuoteCompare."Quote No." := '';
                            QuoteCompare."Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                            QuoteCompare."Vendor Name" := PurchaseHeader."Buy-from Vendor Name";
                            IF PurchaseLine.Type = PurchaseLine.Type::Item then
                                QuoteCompare.Type := QuoteCompare.Type::Item;
                            If PurchaseLine.Type = PurchaseLine.Type::"Fixed Asset" then
                                QuoteCompare.Type := QuoteCompare.Type::"Fixed Assets";
                            If PurchaseLine.Type = PurchaseLine.Type::"G/L Account" then
                                QuoteCompare.Type := QuoteCompare.Type::"G/L Account";
                            //B2BSSD09Feb2023<<
                            if PurchaseLine.Type = PurchaseLine.Type::Resource then
                                QuoteCompare.Type := QuoteCompare.Type::Resource;
                            //B2BSSD09Feb2023>>
                            //B2BSSD21FEB2023<<
                            if PurchaseLine.Type = PurchaseLine.Type::Description then
                                QuoteCompare.Type := QuoteCompare.Type::Description;
                            //B2BSSD21FEB2023>>
                            QuoteCompare."Item No." := PurchaseLine."No.";
                            QuoteCompare.Description := PurchaseLine.Description;
                            QuoteCompare.Description2 := PurchaseLine."Description 2";
                            IF PurchaseLine.Quantity = 0 THEN
                                ERROR(Text0011Lbl, PurchaseLine."Document No.");
                            QuoteCompare.Quantity := PurchaseLine.Quantity;
                            QuoteCompare.Rate := PurchaseLine."Direct Unit Cost";
                            IF PurchaseLine."Direct Unit Cost" = 0 THEN
                                ERROR(Text0010Lbl, PurchaseLine."Document No.");
                            QuoteCompare."Payment Term Code" := PurchaseHeader."Payment Terms Code";

                            //B2BSSD16FEB2023<<
                            QuoteCompare."Transaction Specification" := PurchaseHeader."Transaction Specification";
                            QuoteCompare."Transactio Type" := PurchaseHeader."Transaction Type";
                            QuoteCompare."Shipment Method Code" := PurchaseHeader."Shipment Method Code";
                            QuoteCompare."Payment Method Code" := PurchaseHeader."Payment Method Code";
                            QuoteCompare."Transport Method" := PurchaseHeader."Transport Method";
                            QuoteCompare.Purpose := PurchaseHeader.Purpose;
                            QuoteCompare."Programme Name" := PurchaseHeader."Programme Name";
                            //B2BSSD16FEB2023>>

                            //B2BSSD13APR2023>>
                            QuoCompHdr.Reset();
                            QuoCompHdr.SetRange(RFQNumber, PurchaseHeader."RFQ No.");
                            if QuoCompHdr.FindFirst() then
                                QuoCompHdr.Purpose := PurchaseHeader.Purpose;
                            QuoCompHdr."Programme Name" := PurchaseHeader."Programme Name";
                            QuoCompHdr."Shortcut Dimension 1 Code" := PurchaseHeader."Shortcut Dimension 1 Code";
                            QuoCompHdr."Shortcut Dimension 2 Code" := PurchaseHeader."Shortcut Dimension 2 Code";
                            QuoCompHdr."Shortcut Dimension 9 Code" := PurchaseHeader."Shortcut Dimension 9 Code";
                            QuoCompHdr."Shortcut Dimension 3 Code" := PurchaseHeader."Shortcut Dimension 3 Code";
                            QuoCompHdr.Modify();
                            //B2BSSD13APR2023<<

                            QuoteCompare."Location Code" := PurchaseHeader."Location Code";
                            QuoteCompare."Sub Location Code" := PurchaseLine."Sub Location Code";
                            QuoteCompare."Spec Id" := PurchaseLine."Spec Id";
                            QuoteCompare."Shortcut Dimension 1 Code" := PurchaseLine."Shortcut Dimension 1 Code";
                            QuoteCompare."Shortcut Dimension 2 Code" := PurchaseLine."Shortcut Dimension 2 Code";
                            QuoteCompare."Shortcut Dimension 9 Code" := PurchaseLine."Shortcut Dimension 9 Code";//B2BSSD21FEB2023
                            QuoteCompare."Shortcut Dimension 3 Code" := PurchaseLine."Shortcut Dimension 3 Code";
                            //QuoteCompare."Line Discount %" := PurchaseLine."Line Discount %";//B2BSSD15MAR2023
                            QuoteCompare.Validate("Line Discount %", PurchaseLine."Line Discount %");
                            QuoteCompare."Variant Code" := PurchaseLine."Variant Code";
                            QuoteCompare."Variant Description" := PurchaseLine."Variant Description"; //B2BSCM11JAN2024
                            QuoteCompare."Dimension Set ID" := PurchaseLine."Dimension Set ID";
                            QuoteCompare."Line No." := QuoteCompare."Line No." + 10000;
                            QuoteCompare."Document Date" := PurchaseHeader."Document Date";
                            QuoteCompare."Due Date" := PurchaseHeader."Due Date";
                            QuoteCompare."Requested Receipt Date" := PurchaseHeader."Requested Receipt Date";
                            QuoteCompare."Parent Vendor" := PurchaseHeader."Buy-from Vendor No.";
                            QuoteCompare."RFQ No." := RFQNumber;
                            QuoteCompare."Indent No." := PurchaseLine."Indent No.";
                            QuoteCompare."Indent Line No." := PurchaseLine."Indent Line No.";
                            QuoteCompare."Indent Req. No." := PurchaseLine."Indent Req No";
                            QuoteCompare."Indent Req. Line No." := PurchaseLine."Indent Req Line No";
                            QuoteCompare."Indentor Description" := PurchaseLine."Indentor Description";//B2BSSD07Feb2023
                                                                                                       //PhaniFeb102021 >>
                            QuoteCompare.warranty := PurchaseLine.warranty;//B2BSSD10Feb2023
                            //QuoteCompare.Discount := PurchaseLine."Line Discount %";//B2BSSD14FEB2023
                            QuoteCompare."VAT Bus. Posting Group" := PurchaseLine."VAT Bus. Posting Group";
                            QuoteCompare."VAT Prod. Posting Group" := PurchaseLine."VAT Prod. Posting Group";
                            //PhaniFeb102021 <<
                            //B2BMSOn06Oct21>>
                            QuoteCompare."Currency Code" := PurchaseLine."Currency Code";
                            QuoteCompare.Amount := PurchaseLine."Line Amount";
                            //B2BMSOn06Oct21<<
                            PurchaseSetup.GET();

                            IF PurchaseSetup."Delivery Required" = TRUE THEN
                                QuoteCompare.Delivery
                                 := CalculateDelivery(PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseHeader."RFQ No.");
                            IF PurchaseSetup."Quality Required" = TRUE THEN
                                QuoteCompare.Quality := CalculateQuality(PurchaseLine."Buy-from Vendor No.", PurchaseLine."No.", PurchaseHeader."RFQ No.");

                            QuoteCompare.Structure := '';
                            QuoteCompare."Line Amount" := 0;
                            QuoteCompare.Level := 1;
                            QuoteCompare."Parent Quote No." := PurchaseLine."Document No.";
                            QuoteCompare."Parent Quote Line No" := PurchaseLine."Line No.";

                            IF PurchaseSetup."Payment Terms Required" = TRUE THEN BEGIN
                                IF QuoteCompare."Payment Term Code" = '' THEN
                                    ERROR(Text006Lbl, QuoteCompare."Parent Quote No.");
                                IF PaymentTerms.GET(QuoteCompare."Payment Term Code") THEN BEGIN
                                    QuoteCompare.Rating := PaymentTerms.Rating;
                                    IF QuoteCompare.Rating = 0 THEN
                                        ERROR(Text005Lbl, QuoteCompare."Payment Term Code");
                                END;
                            END;

                            QuoteCompare."Variant Code" := PurchaseLine."Variant Code";
                            QuoteCompare."Variant Description" := PurchaseLine."Variant Description"; //B2BSCM11JAN2024
                            //QuoteCompare.Amount := (PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost") - QuoteCompare.Discount;
                            Amount := Amount + QuoteCompare.Amount;

                            QuoteCompareAmount.SETRANGE("RFQ No.", QuoteCompare."RFQ No.");
                            QuoteCompareAmount.SETRANGE("Quote No.", PurchaseLine."Document No.");
                            QuoteCompareAmount.SETRANGE(QuoteCompareAmount.Level, 0);
                            IF QuoteCompareAmount.FIND('-') THEN BEGIN
                                QuoteCompareAmount."Total Amount" := Amount;
                                QuoteCompareAmount.MODIFY();
                            END;
                            QuoteCompare.Department := PurchaseLine."Shortcut Dimension 2 Code";

                            QuoteCompare.INSERT();

                            IndentLineRec.Reset();
                            IndentLineRec.SetRange("Document No.", PurchaseLine."Indent No.");
                            IndentLineRec.SetRange("Line No.", PurchaseLine."Indent Line No.");
                            if IndentLineRec.FindSet() then begin
                                repeat
                                    //    SetSelectionFilter(IndentLineRec);
                                    IndentLineRec.Status := IndentLineRec.Status::"Quotation Comparsion";
                                    IndentLineRec.Modify();
                                until IndentLineRec.Next() = 0;
                            end;
                        UNTIL PurchaseLine.NEXT() = 0;


                END;
            UNTIL PurchaseHeader.NEXT() = 0;

        PurchaseSetup.GET();
        QuoteCompare.RESET();
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        QuoteCompare.SETCURRENTKEY("Item No.");
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                IF PreviousItem <> QuoteCompare."Item No." THEN BEGIN
                    LeastLineAmount := 0;
                    QuoteCompare1.RESET();
                    QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare1.SETFILTER("Item No.", '<>%1', '');
                    QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare1.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    IF QuoteCompare1.FIND('-') THEN BEGIN
                        LeastLineAmount := QuoteCompare1.Amount;
                        REPEAT
                            IF LeastLineAmount > QuoteCompare1.Amount THEN
                                LeastLineAmount := QuoteCompare1.Amount;
                        UNTIL QuoteCompare1.NEXT() = 0;
                        IF QuoteCompare1.FIND('-') THEN
                            REPEAT
                                if QuoteCompare1.Amount <> 0 then begin //B2BMS
                                    QuoteCompare1.Price := (LeastLineAmount / QuoteCompare1.Amount * 100) * PurchaseSetup."Price Weightage" / 100;
                                    QuoteCompare1.MODIFY();
                                end; //B2BMS
                            UNTIL QuoteCompare1.NEXT() = 0;
                    END;
                END ELSE
                    PreviousItem := QuoteCompare."Item No.";
            UNTIL QuoteCompare.NEXT() = 0;


        PurchaseSetup.GET();
        IF PurchaseSetup."Payment Terms Required" = TRUE THEN BEGIN
            QuoteCompare.RESET();
            QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
            QuoteCompare.SETFILTER("Item No.", '<>%1', '');
            QuoteCompare.SETCURRENTKEY("Item No.");
            IF QuoteCompare.FIND('-') THEN
                REPEAT
                    IF PreviousItem <> QuoteCompare."Item No." THEN BEGIN
                        LeastLineAmount := 0;
                        QuoteCompare1.RESET();
                        QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                        QuoteCompare1.SETFILTER("Item No.", '<>%1', '');
                        QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                        IF QuoteCompare1.FIND('-') THEN BEGIN
                            MaxPayment := QuoteCompare1.Rating;
                            REPEAT
                                IF MaxPayment < QuoteCompare1.Rating THEN
                                    MaxPayment := QuoteCompare1.Rating;
                            UNTIL QuoteCompare1.NEXT() = 0;
                            IF QuoteCompare1.FIND('-') THEN
                                REPEAT
                                    if MaxPayment <> 0 then begin  //B2BMS
                                        QuoteCompare1."Payment Terms"
                                        := (QuoteCompare1.Rating / MaxPayment * 100) * PurchaseSetup."Payment Terms Weightage" / 100;
                                        QuoteCompare1.MODIFY();
                                    end; //B2BMS
                                UNTIL QuoteCompare1.NEXT() = 0;
                        END;
                    END ELSE
                        PreviousItem := QuoteCompare."Item No.";
                UNTIL QuoteCompare.NEXT() = 0;
        END;
        QuoteCompare.RESET();
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        QuoteCompare.SETCURRENTKEY("Item No.");
        IF QuoteCompare.FIND('-') THEN
            REPEAT
                QuoteCompare."Total Weightage" := QuoteCompare.Price + QuoteCompare.Delivery + QuoteCompare.Quality +
                                                   QuoteCompare."Payment Terms";
                QuoteCompare.MODIFY();
            UNTIL QuoteCompare.NEXT() = 0;

        //For Selecting the best vendor
        PreviousItem := '';
        QuoteCompare.RESET();
        QuoteCompare.SETCURRENTKEY("RFQ No.", "Item No.", "Variant Code");
        QuoteCompare.SETRANGE("RFQ No.", RFQNumber);
        QuoteCompare.SETFILTER("Item No.", '<>%1', '');
        IF QuoteCompare.FindSet() THEN
            REPEAT
                IF (PreviousItem <> QuoteCompare."Item No.") OR (ColourCode <> QuoteCompare."Variant Code")
               THEN BEGIN
                    PreviousItem := QuoteCompare."Item No.";
                    ColourCode := QuoteCompare."Variant Code";
                    QuoteCompare1.RESET();
                    QuoteCompare1.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare1.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare1.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    IF QuoteCompare1.FindFirst() THEN begin
                        TotalWeightage := QuoteCompare1."Total Weightage";
                        repeat
                            IF TotalWeightage < QuoteCompare1."Total Weightage" THEN
                                TotalWeightage := QuoteCompare1."Total Weightage";
                        until QuoteCompare1.Next() = 0;
                    END;

                    QuoteCompare2.RESET();
                    QuoteCompare2.SETRANGE("RFQ No.", RFQNumber);
                    QuoteCompare2.SETRANGE("Item No.", QuoteCompare."Item No.");
                    QuoteCompare2.SETRANGE("Variant Code", QuoteCompare."Variant Code");
                    QuoteCompare2.SETRANGE("Total Weightage", TotalWeightage);
                    IF QuoteCompare2.FindSet() THEN
                        //repeat
                        QuoteCompare2."Carry Out Action" := TRUE;
                    QuoteCompare2.MODIFY();
                    //until QuoteCompare2.next = 0;

                END;
            UNTIL QuoteCompare.NEXT() = 0;

        clear(Lnum);

        QuoComparsn.RESET;
        //QuoComparsn.SetCurrentKey("Purch. Req Line No");
        QuoComparsn.SetRange("RFQ No.", RFQNumber);
        QuoComparsn.SetFilter("Item No.", '<>%1', '');
        IF QuoComparsn.FindSet() then
            repeat
                IF (Lnum = 0) THEN BEGIN
                    clear(TotalWeightage);
                    clear(Linum);
                    QuoteCompare2.RESET();
                    QuoteCompare2.SETRANGE("RFQ No.", RFQNumber);
                    // QuoteCompare2.SETRANGE("Purch. Req Line No", QuoComparsn."Purch. Req Line No");
                    IF QuoteCompare2.FindSet() THEN
                        repeat
                            IF (TotalWeightage < QuoteCompare2."Total Weightage") then begin
                                TotalWeightage := QuoteCompare2."Total Weightage";
                                Linum := QuoteCompare2."Line No.";
                            end
                            else begin
                                TotalWeightage := TotalWeightage;
                                Linum := Linum;
                            end;
                        until QuoteCompare2.next = 0;

                    Quocom.RESET;
                    Quocom.SetRange("RFQ No.", RFQNumber);
                    Quocom.SetRange("Line No.", Linum);
                    IF Quocom.FindFirst() THEN begin
                        Quocom."Carry Out Action" := true;
                        Quocom.Modify();
                    end;
                end;
            // Lnum := QuoComparsn."Purch. Req Line No";
            until QuoComparsn.next = 0;
    end;


    procedure CalculateDelivery("VendorNo.": Code[20]; "ItemNo.": Code[20]; RFQNo: Code[20]) Delvery: Decimal;
    var
        PPSetup: Record 312;
        ItemVendor: Record 99;
        ItemVendor2: Record 99;
        MaxDeliveryPoints: Decimal;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        DeliverVal: Decimal; //B2BMSOn20Sep2022
    begin
        MaxDeliveryPoints := 0;
        ItemVendor2.RESET;
        PPSetup.GET;
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE(PurchaseHeader."RFQ No.", RFQNo);
        IF PurchaseHeader.FIND('-') THEN
            REPEAT
                PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                PurchaseLine.SETRANGE("No.", "ItemNo.");
                IF PurchaseLine.FIND('-') THEN
                    REPEAT
                        ItemVendor2.SETRANGE("Vendor No.", PurchaseLine."Buy-from Vendor No.");
                        ItemVendor2.SETRANGE("Item No.", "ItemNo.");
                        IF ItemVendor2.FIND('-') THEN BEGIN
                            REPEAT
                                ItemVendor2.CALCFIELDS("Total Qty. Supplied");
                                IF (ItemVendor2."Total Qty. Supplied" <> 0) AND (ItemVendor2."Qty. Supplied With in DueDate" <> 0) THEN BEGIN
                                    ItemVendor2."Avg. Delivery Rating" := ItemVendor2."Qty. Supplied With in DueDate" / ItemVendor2."Total Qty. Supplied";
                                    ItemVendor2.MODIFY;
                                    IF MaxDeliveryPoints < ItemVendor2."Avg. Delivery Rating" THEN
                                        MaxDeliveryPoints := ItemVendor2."Avg. Delivery Rating";
                                END ELSE BEGIN
                                    PPSetup.GET;
                                    IF PPSetup."Default Delivery Rating" > MaxDeliveryPoints THEN
                                        MaxDeliveryPoints := PPSetup."Default Delivery Rating";
                                END;
                            UNTIL ItemVendor2.NEXT = 0
                        END ELSE BEGIN
                            PPSetup.GET;
                            IF PPSetup."Default Delivery Rating" > MaxDeliveryPoints THEN
                                MaxDeliveryPoints := PPSetup."Default Delivery Rating";
                        END;
                    UNTIL PurchaseLine.NEXT = 0;
            UNTIL PurchaseHeader.NEXT = 0;


        ItemVendor.SETRANGE("Vendor No.", "VendorNo.");
        ItemVendor.SETRANGE("Item No.", "ItemNo.");
        IF ItemVendor.FIND('-') THEN BEGIN
            ItemVendor.CALCFIELDS("Total Qty. Supplied");
            IF ItemVendor."Qty. Supplied With in DueDate" = 0 THEN BEGIN
                if MaxDeliveryPoints <> 0 then
                    EXIT(((PPSetup."Default Delivery Rating" / MaxDeliveryPoints)) * PPSetup."Delivery Weightage")
            END ELSE
                IF (ItemVendor."Total Qty. Supplied" <> 0) AND (ItemVendor."Qty. Supplied With in DueDate" <> 0) THEN BEGIN
                    EXIT(((ItemVendor."Avg. Delivery Rating" / MaxDeliveryPoints)) * PPSetup."Delivery Weightage");
                END;
        END ELSE begin
            //EXIT((PPSetup."Default Delivery Rating" / MaxDeliveryPoints) * PPSetup."Delivery Weightage");
            if MaxDeliveryPoints <> 0 then
                DeliverVal := (PPSetup."Default Delivery Rating" / MaxDeliveryPoints) * PPSetup."Delivery Weightage";
            exit(DeliverVal);
        end;
    end;

    procedure CalculateQuality("VendorNo.": Code[20]; "ItemNo.": Code[20]; RFQNo: Code[20]) Quality: Decimal;
    var
        PPSetup: Record 312;
        ItemVendor: Record 99;
        ItemVendor2: Record 99;
        MaxQualityPoints: Decimal;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
    begin
        /*
        MaxQualityPoints := 0;
        ItemVendor2.RESET;
        PPSetup.GET;
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE(PurchaseHeader."RFQ No.",RFQNo);
        IF PurchaseHeader.FIND('-') THEN
           REPEAT
              PurchaseLine.SETRANGE("Document No.",PurchaseHeader."No.");
              PurchaseLine.SETRANGE("No.","ItemNo.");
              IF PurchaseLine.FIND('-') THEN
                REPEAT
                 ItemVendor2.SETRANGE("Vendor No.",PurchaseLine."Buy-from Vendor No.");
                 ItemVendor2.SETRANGE("Item No.","ItemNo.");
                  IF ItemVendor2.FIND('-') THEN BEGIN
                    REPEAT
                      ItemVendor2.CALCFIELDS("Quality Rating","Total Qty. Supplied");
                      IF (ItemVendor2."Total Qty. Supplied" <> 0) AND (ItemVendor2."Quality Rating" <> 0)THEN BEGIN
                         ItemVendor2."Avg. Quality Rating" := (ItemVendor2."Quality Rating")/ItemVendor2."Total Qty. Supplied";
                         ItemVendor2.MODIFY;
                       IF MaxQualityPoints <  ItemVendor2."Avg. Quality Rating"  THEN
                        MaxQualityPoints :=  ItemVendor2."Avg. Quality Rating";
                      END ELSE BEGIN
                       PPSetup.GET;
                       IF PPSetup."Default Quality Rating" > MaxQualityPoints THEN
                        MaxQualityPoints := PPSetup."Default Quality Rating";
                      END;
                    UNTIL ItemVendor2.NEXT=0;
                  END ELSE BEGIN
                   PPSetup.GET;
                   IF PPSetup."Default Quality Rating" > MaxQualityPoints THEN
                     MaxQualityPoints := PPSetup."Default Quality Rating";
                 END;
                UNTIL PurchaseLine.NEXT=0;
           UNTIL PurchaseHeader.NEXT=0;
        
        
        ItemVendor.SETRANGE("Vendor No.","VendorNo.");
        ItemVendor.SETRANGE("Item No.","ItemNo.");
        IF ItemVendor.FIND('-') THEN BEGIN
          ItemVendor.CALCFIELDS("Total Qty. Supplied","Quality Rating");
          IF ItemVendor."Quality Rating" = 0 THEN
             EXIT(((PPSetup."Default Quality Rating" /MaxQualityPoints)) * PPSetup."Quality Weightage")
          ELSE
           IF (ItemVendor."Total Qty. Supplied" <> 0) AND (ItemVendor."Quality Rating" <> 0) THEN
             EXIT(((ItemVendor."Avg. Quality Rating" /MaxQualityPoints) * PPSetup."Quality Weightage"));
        END ELSE
           EXIT((PPSetup."Default Quality Rating"/MaxQualityPoints)*PPSetup."Quality Weightage");
        */

    end;

    procedure ConvertEnquirytoQuote(var Rec: Record 38);
    var
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchaseSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchaseLineQuote: Record 39;
        Text001: Label 'Enquiry %1 has been changed to Quote %2';
        IndentLine: Record "Indent Line";
        DimentionSetEntry: Record "Dimension Set Entry";//B2BSSD20Feb2023
        IndentLineRec: Record "Indent Line";
        IndentReqLine: Record "Indent Requisitions";
        IndentReqHead: Record "Indent Req Header";
    begin
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Quote;
        PurchaseSetup.GET;
        PurchaseHeader."Buy-from Vendor No." := Rec."Buy-from Vendor No.";
        PurchaseHeader."Requested Receipt Date" := Rec."Requested Receipt Date";
        PurchaseHeader.VALIDATE("Buy-from Vendor No.");
        PurchaseHeader."No." := NoSeriesMgt.GetNextNo(PurchaseSetup."Quote Nos.", WORKDATE, TRUE);
        PurchaseHeader."Order Date" := WORKDATE;
        PurchaseHeader."Due Date" := Rec."Due Date";
        PurchaseHeader."Document Date" := WORKDATE;
        PurchaseHeader."Requested Receipt Date" := Rec."Requested Receipt Date";
        PurchaseHeader."Location Code" := Rec."Location Code";
        PurchaseHeader.VALIDATE("Location Code");
        PurchaseHeader."Indent Requisition No" := Rec."Indent Requisition No";
        PurchaseHeader.INSERT;
        //B2BMSOn14Sep2022>>
        PurchaseHeader.Validate("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        PurchaseHeader.Validate("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        //B2BMSOn14Sep2022<<
        PurchaseHeader.Validate("Shortcut Dimension 9 Code", Rec."Shortcut Dimension 9 Code");//B2BSSD21FEB2023
        PurchaseHeader.Validate("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
        PurchaseHeader."Programme Name" := Rec."Programme Name";//B2BSSD20MAR2023
        PurchaseHeader.Purpose := Rec.Purpose;//B2BSSD21MAR2023
        PurchaseHeader."Responsibility Center" := Rec."Responsibility Center"; //B2BVCOn30April2024
        PurchaseHeader."Enquiry No." := Rec."No.";
        PurchaseHeader.Modify(true);//B2BSSD21FEB2023


        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Enquiry);
        PurchaseLine.SETRANGE("Document No.", Rec."No.");
        IF PurchaseLine.FIND('-') THEN
            REPEAT
                PurchaseLineQuote.INIT;
                PurchaseLineQuote."Document Type" := PurchaseLineQuote."Document Type"::Quote;
                PurchaseLineQuote."Document No." := PurchaseHeader."No.";
                PurchaseLineQuote."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                PurchaseLineQuote.VALIDATE("Buy-from Vendor No.");
                PurchaseLineQuote."Line No." := PurchaseLineQuote."Line No." + 10000;
                PurchaseLineQuote.INSERT(true);
                PurchaseLineQuote.Type := PurchaseLine.Type;
                PurchaseLineQuote."No." := PurchaseLine."No.";
                PurchaseLineQuote.VALIDATE("No.");
                PurchaseLineQuote.Quantity := PurchaseLine.Quantity;
                PurchaseLineQuote.VALIDATE(Quantity);
                PurchaseLineQuote."Indent No." := PurchaseLine."Indent No.";
                PurchaseLineQuote."Indent Line No." := PurchaseLine."Indent Line No.";
                //B2BMSOn14Sep2022>>
                PurchaseLineQuote."Indent Req No" := PurchaseLine."Indent Req No";
                PurchaseLineQuote."Indent Req Line No" := PurchaseLine."Indent Req Line No";
                PurchaseLineQuote.validate("Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 1 Code");
                PurchaseLineQuote.validate("Shortcut Dimension 2 Code", PurchaseLine."Shortcut Dimension 2 Code");
                PurchaseLineQuote.Validate("Shortcut Dimension 9 Code", PurchaseLine."Shortcut Dimension 9 Code");//B2BSSD21FEB2023
                //B2BMSOn14Sep2022<<
                PurchaseLineQuote.Validate("Shortcut Dimension 3 Code", PurchaseLine."Shortcut Dimension 3 Code");
                PurchaseLineQuote."Sub Location Code" := PurchaseLine."Sub Location Code";//B2BSSD07Feb2023
                PurchaseLineQuote."Spec Id" := PurchaseLine."Spec Id";
                PurchaseLineQuote.Validate("Indentor Description", PurchaseLine."Indentor Description");
                PurchaseLineQuote.VALIDATE("Unit of Measure Code", PurchaseLine."Unit of Measure Code");
                //B2BSSD22FEB2023<<
                PurchaseLineQuote.Validate("Line Discount %", PurchaseLine."Line Discount %");
                PurchaseLineQuote.Validate("Direct Unit Cost", PurchaseLine."Direct Unit Cost");
                PurchaseLineQuote.Description := PurchaseLine.Description;//B2BSSD20APR2023
                PurchaseLineQuote."Line Amount" := PurchaseLine."Line Amount";
                PurchaseLineQuote.Validate("Unit of Measure", PurchaseLine."Unit of Measure");
                PurchaseLineQuote.Validate("Unit Cost", PurchaseLine."Unit Cost");
                //B2BSSD22FEB2023>>
                PurchaseLineQuote."Location Code" := PurchaseLine."Location Code";
                PurchaseLineQuote.VALIDATE("Location Code");
                PurchaseLineQuote."Variant Code" := PurchaseLine."Variant Code";
                PurchaseLineQuote."Variant Description" := PurchaseLine."Variant Description"; //B2BSCM11JAN2024
                PurchaseLineQuote."Enquiry No." := PurchaseHeader."Enquiry No.";
                PurchaseLineQuote.modify(true);

                IndentLine.RESET;
                IndentLine.SETRANGE("No.", PurchaseLine."No.");
                IndentLine.SETRANGE("Variant Code", PurchaseLine."Variant Code");
                IndentLine.SETRANGE("Document No.", PurchaseLine."Indent No.");
                IndentLine.SETRANGE(IndentLine."Line No.", PurchaseLine."Indent Line No.");
                IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Enquiry);
                IndentLine.SETRANGE("Release Status", IndentLine."Release Status"::Released);
                IF IndentLine.FIND('-') THEN BEGIN
                    IndentLine."Indent Status" := IndentLine."Indent Status"::Offer;
                    IndentLine.MODIFY;
                END;
                IndentLineRec.Reset();
                IndentLineRec.SetRange("Document No.", PurchaseLine."Indent No.");
                IndentLineRec.SetRange("Line No.", PurchaseLine."Indent Line No.");
                if IndentLineRec.FindSet() then begin
                    repeat
                        //    SetSelectionFilter(IndentLineRec);
                        IndentLineRec.Status := IndentLineRec.Status::Quote;
                        IndentLineRec.Modify();
                    until IndentLineRec.Next() = 0;
                end;
                //B2BVCOn15Mar2024 >>
                if IndentReqLine.Get(PurchaseLineQuote."Indent Req No", PurchaseLineQuote."Indent Req Line No") then begin
                    IndentReqLine."Requisition Type" := IndentReqLine."Requisition Type"::Quote;
                    IndentReqLine.Modify();
                    if IndentReqHead.Get(IndentReqLine."Document No.") then begin
                        PurchaseHeader."RFQ No." := IndentReqHead."RFQ No.";
                        PurchaseHeader.Modify();
                    end;
                end;
            //B2BVCOn15Mar2024 <<

            UNTIL PurchaseLine.NEXT = 0;
        CopyTermsandConditionsofVendorDoc(Rec, PurchaseHeader);
        CopyTermsandSpecificationsDoc(Rec, PurchaseHeader);
        /*IndentLineRec.Reset();
             IndentLineRec.SetRange("Document No.", PurchaseLine."Indent No.");
             IndentLineRec.SetRange("Line No.", PurchaseLine."Indent Line No.");
             if IndentLineRec.FindSet() then begin
                 repeat
                     //    SetSelectionFilter(IndentLineRec);
                     IndentLineRec.Status := IndentLineRec.Status::Quote;
                     IndentLineRec.Modify();
                 until IndentLineRec.Next() = 0;
             end;*/
        MESSAGE(Text001, Rec."No.", PurchaseLineQuote."Document No.");
        Rec.DELETE;
    end;

    procedure GetReqLines(var IndreqHeader: Record "Indent Req Header");
    var
        CreateIndents: Record "Indent Requisitions";
        IndentLine: Record "Indent Line";
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        PPsetup: Record 312;
        Lineno: Integer;
    begin
        CreateIndents.RESET;
        CreateIndents.DELETEALL;
        IndentLine.RESET;
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
        IndentLine.SETRANGE("Release Status", IndentLine."Release Status"::Released);
        IF IndentLine.FIND('-') THEN
            REPEAT
                PPsetup.GET;
                IF PPsetup."Cumulation of Indents" THEN BEGIN
                    CreateIndents.RESET;
                    CreateIndents.SETRANGE("Item No.", IndentLine."No.");
                    CreateIndents.SETRANGE("Location Code", IndentLine."Delivery Location");
                    CreateIndents.SETRANGE("Variant Code", IndentLine."Variant Code");
                    CreateIndents.SETRANGE("Due Date", IndentLine."Due Date");
                END ELSE BEGIN
                    CreateIndents.RESET;
                    CreateIndents.SETRANGE("Indent No.", IndentLine."Document No.");
                    CreateIndents.SETRANGE("Item No.", IndentLine."No.");
                    CreateIndents.SETRANGE("Location Code", IndentLine."Delivery Location");
                    CreateIndents.SETRANGE("Variant Code", IndentLine."Variant Code");
                    CreateIndents.SETRANGE("Due Date", IndentLine."Due Date");
                    CreateIndents.SETRANGE(Department, IndentLine.Department);
                END;
                IF CreateIndents.FIND('+') THEN BEGIN
                    Item2.RESET;
                    ItemUnitofMeasure.RESET;
                    Item2.GET(IndentLine."No.");
                    ItemUnitofMeasure.GET(IndentLine."No.", IndentLine."Unit of Measure");
                    IF Item2."Base Unit of Measure" <> IndentLine."Unit of Measure" THEN BEGIN
                        IF ItemUnitofMeasure."Qty. per Unit of Measure" <> 0 THEN
                            CreateIndents.Quantity += IndentLine."Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure";
                    END ELSE
                        CreateIndents.Quantity += IndentLine."Req.Quantity";
                    CreateIndents.MODIFY;
                END ELSE BEGIN
                    CreateIndents.INIT;
                    CreateIndents."Document No." := IndreqHeader."No.";
                    CreateIndents."Line No." := Lineno;
                    CreateIndents."Item No." := IndentLine."No.";
                    CreateIndents."Indent No." := IndentLine."Document No.";
                    CreateIndents."Indent Line No." := IndentLine."Line No.";
                    CreateIndents.Description := IndentLine.Description;
                    CreateIndents."Variant Code" := IndentLine."Variant Code";
                    CreateIndents."Variant Description" := IndentLine."Variant Description"; //B2BSCM11JAN2024
                    CreateIndents."Indent Status" := IndentLine."Indent Status";
                    CreateIndents."Release Status" := IndentLine."Release Status";
                    CreateIndents."Due Date" := IndentLine."Due Date";
                    CreateIndents."Location Code" := IndentLine."Delivery Location";
                    CreateIndents.Department := IndentLine.Department;
                    Item2.RESET;
                    ItemUnitofMeasure.RESET;
                    Item2.GET(CreateIndents."Item No.");
                    CreateIndents."Vendor No." := IndentLine."Vendor No.";
                    ItemUnitofMeasure.GET(IndentLine."No.", IndentLine."Unit of Measure");
                    IF Item2."Base Unit of Measure" = IndentLine."Unit of Measure" THEN BEGIN
                        CreateIndents."Unit of Measure" := IndentLine."Unit of Measure";
                        CreateIndents.Quantity := IndentLine."Req.Quantity";
                    END ELSE BEGIN
                        CreateIndents."Unit of Measure" := Item2."Base Unit of Measure";
                        IF ItemUnitofMeasure."Qty. per Unit of Measure" <> 0 THEN
                            CreateIndents.Quantity := (IndentLine."Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure");
                    END;
                    CreateIndents.INSERT;
                    Lineno += 10000;
                END;
            UNTIL IndentLine.NEXT = 0;
        CreateIndents.RESET;
    end;

    procedure "---B2B1.1---"();
    begin
    end;

    procedure CreateOrder2(var CreateIndentsQuotes: Record "Indent Requisitions"; var Vendor: Record 23; var Noseries: Code[20]);
    var
        IndentVendorItems: Record "Indent Vendor Items";
        IndentVendorEnquiry: Record "Indent Vendor Items";
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PPSetup: Record 312;
        CreateIndents2: Record "Indent Requisitions";
        IndentLineRec: Record "Indent Line";
        IndentLine: Record "Indent Line";
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
        BaseUOMQtyMeasure: Decimal;
        PurchUOMQtyMeasure: Decimal;
        VendorNo: Code[20];
        indentRequisitions: Record "Indent Requisitions";
        IndentReqLine: Record "Indent Requisitions";
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        IndentReqHeader: Record "Indent Req Header";
    begin
        CreateIndents4.COPYFILTERS(CreateIndentsQuotes);
        //InsertIndentItemvendor2(CreateIndents4, Vendor);
        InsertIndentItemvendor2(CreateIndentsQuotes, Vendor); //B2BVCOn15Mar2024
        IndentVendorItems.RESET;
        IndentVendorItems.SETRANGE(Check, FALSE);
        IF IndentVendorItems.FIND('-') THEN
            REPEAT
                IndentVendorEnquiry.Reset(); //B2BMSOn16Nov2022
                IndentVendorEnquiry.SetCurrentKey("Vendor No."); //B2BMSOn16Nov2022
                IndentVendorEnquiry.SETRANGE("Location Code", IndentVendorItems."Location Code");
                IndentVendorEnquiry.SetRange("Line Type", IndentVendorItems."Line Type");//B2BSSD14APR2023
                IF IndentVendorEnquiry.FIND('-') THEN
                    REPEAT
                        //B2BMSOn16Nov2022>>
                        if VendorNo <> IndentVendorEnquiry."Vendor No." then begin
                            VendorNo := IndentVendorEnquiry."Vendor No.";
                            //B2BMSOn16Nov2022<<
                            PurchaseHeader.INIT;
                            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                            PPSetup.GET;
                            PurchaseHeader."No." := NoSeriesMgt.GetNextNo(Noseries, WORKDATE, TRUE);
                            PurchaseHeader.Insert(true);
                            PurchaseHeader."Buy-from Vendor No." := IndentVendorEnquiry."Vendor No.";
                            PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                            PurchaseHeader."Order Date" := WORKDATE;
                            PurchaseHeader."Document Date" := WORKDATE;
                            PurchaseHeader.VALIDATE("Location Code", IndentVendorEnquiry."Location Code");
                            PurchaseHeader."Due Date" := IndentVendorEnquiry."Due Date";
                            PurchaseHeader."Expected Receipt Date" := IndentVendorEnquiry."Due Date";
                            PurchaseHeader.VALIDATE("Expected Receipt Date");
                            PurchaseHeader.VALIDATE("Due Date");
                            PurchaseHeader."Indent Requisition No" := IndentVendorEnquiry."Indent Req No";
                            PurchaseHeader.Validate("Location Code", IndentVendorEnquiry."Location Code");
                            PurchaseHeader.validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");//B2BPAV
                            PurchaseHeader.validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");//B2BPAV
                            PurchaseHeader.Validate("Shortcut Dimension 9 Code", IndentVendorEnquiry."Shortcut Dimension 9 Code");//B2BSSD21FEB2023
                            PurchaseHeader.Validate("Shortcut Dimension 3 Code", IndentVendorEnquiry."Shortcut Dimension 3 Code"); //B2BVCOn30April2024
                            PurchaseHeader."Programme Name" := IndentVendorEnquiry."Programme Name";//B2BSSD20MAR2023
                            PurchaseHeader.Purpose := IndentVendorEnquiry.Purpose; //B2BSSD21MAR2023
                            //B2                                                   BVCOn30April2024 >>
                            CreateIndents2.Reset();
                            CreateIndents2.SetRange("Document No.", IndentVendorEnquiry."Indent Req No");
                            CreateIndents2.SetRange("Line No.", IndentVendorEnquiry."Indent Req Line No");
                            if CreateIndents2.FindFirst() then begin
                                if IndentReqHeader.Get(CreateIndents2."Document No.") then begin
                                    PurchaseHeader."Responsibility Center" := IndentReqHeader."Resposibility Center";
                                    PurchaseHeader."RFQ No." := IndentReqHeader."RFQ No.";
                                end;

                            end;
                            //B2BVCOn30April2024 <<
                            PurchaseHeader.Modify(true);
                            CopyTermsandConditionsofVendor(PurchaseHeader);
                            CopyTermsandSpecificationofVendors(PurchaseHeader);
                        end;
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseLine."Line No." + 10000;
                        PurchaseLine.Insert(true);
                        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                        PurchaseLine.VALIDATE("Buy-from Vendor No.");
                        PurchaseLine."Pay-to Vendor No." := PurchaseHeader."Pay-to Vendor No.";//B2BSSD27FEB2023

                        //B2BSSD16FEB2023<<
                        if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Item then begin
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                            if PurchaseLine."No." <> '' then
                                Error('No.Must Have a Value');
                            PurchaseLine.Validate("No.", IndentVendorEnquiry."Item No.");
                        end
                        //B2BSSD16JUN2023>>
                        else
                            if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::"Fixed Assets" then begin
                                PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                                PurchaseLine.Validate("No.", IndentVendorEnquiry."Item No.");
                            end
                            //B2BSSD16JUN2023<<
                            else
                                if IndentVendorEnquiry."Line Type" = IndentVendorEnquiry."Line Type"::Description then begin
                                    PurchaseLine.Type := PurchaseLine.Type::Description;
                                    if PurchaseLine."No." = '' then
                                        PurchaseLine.Validate("No.", IndentVendorEnquiry."Item No.");//B2BSSD29MAY2023
                                end;
                        //B2BSSD16FEB2023>>

                        //B2BSSD21APR2023>>
                        CreateIndents2.Reset();
                        CreateIndents2.SetRange("Document No.", IndentVendorEnquiry."Indent Req No");
                        CreateIndents2.SetRange("Line No.", IndentVendorEnquiry."Indent Req Line No");
                        CreateIndents2.SetRange("Item No.", IndentVendorEnquiry."Item No.");
                        if CreateIndents2.FindFirst() then
                            PurchaseLine.Validate("Indentor Description", CreateIndents2."Indentor Description");
                        PurchaseLine.Description := CreateIndents2.Description;
                        //B2BSSD21APR2023<<

                        PurchaseLine."Variant Code" := IndentVendorEnquiry."Variant Code";
                        PurchaseLine."Variant Description" := IndentVendorEnquiry."Variant Description"; //B2BSCM11JAN2024
                        PurchaseLine.Quantity := IndentVendorEnquiry.Quantity;
                        PurchaseLine."Outstanding Quantity" := PurchaseLine.Quantity;
                        PurchaseLine."Outstanding Qty. (Base)" := PurchaseLine.Quantity;
                        PurchaseLine."Indent No." := IndentVendorEnquiry."Indent No.";
                        PurchaseLine."Indent Line No." := IndentVendorEnquiry."Indent Line No.";
                        PurchaseLine."Indent Req No" := IndentVendorEnquiry."Indent Req No";
                        PurchaseLine."Indent Req Line No" := IndentVendorEnquiry."Indent Req Line No";
                        PurchaseLine."Unit of Measure Code" := IndentVendorEnquiry."Unit Of Measure";//B2BSSD20APR2023
                        PurchaseLine."Location Code" := PurchaseHeader."Location Code";
                        PurchaseLine.Validate("Shortcut Dimension 1 Code", IndentVendorEnquiry."Shortcut Dimension 1 Code");//B2BPAV
                        PurchaseLine.Validate("Shortcut Dimension 2 Code", IndentVendorEnquiry."Shortcut Dimension 2 Code");//B2BPAV
                        PurchaseLine.Validate("Shortcut Dimension 9 Code", IndentVendorEnquiry."Shortcut Dimension 9 Code");//B2BSSD21FEB2023
                        PurchaseLine.Validate("Shortcut Dimension 3 Code", IndentVendorEnquiry."Shortcut Dimension 3 Code");
                        PurchaseLine."Sub Location Code" := IndentVendorEnquiry."Sub Location Code";
                        PurchaseLine."Spec Id" := IndentVendorEnquiry."Spec Id";
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

                        CreateIndents5.RESET;
                        CreateIndents5.SETRANGE(CreateIndents5."Document No.", IndentVendorEnquiry."Indent Req No");
                        CreateIndents5.SETRANGE(CreateIndents5."Line No.", IndentVendorEnquiry."Indent Req Line No");
                        IF CreateIndents5.FINDFIRST THEN BEGIN
                            CreateIndents5."Document Type" := PurchaseLine."Document Type"::Order.AsInteger();
                            CreateIndents5."Order No" := PurchaseLine."Document No.";
                            PurchaseLine.VALIDATE("Direct Unit Cost", CreateIndents5."Unit Cost");
                            //B2BSSD11Jan2023<<
                            PurchaseLine.Validate("Spec Id", CreateIndents5."Spec Id");
                            PurchaseLine.Validate(Quantity, IndentVendorEnquiry.Quantity);//B2BSCM12SEP2023
                            PurchaseLine.Validate("Sub Location Code", CreateIndents5."Sub Location Code");
                            PurchaseLine.Validate("Variant Code", CreateIndents5."Variant Code");
                            PurchaseLine."Variant Description" := CreateIndents5."Variant Description";//B2BSCM11JAN2024
                            //B2BSSD11Jan2023>>
                            PurchaseLine.Validate("Indentor Description", CreateIndents5."Indentor Description");//B2BSSD02Feb2023
                            CreateIndents5.MODIFY;
                        END;
                        //B2BVCOn15Mar2024 >>
                        if IndentReqLine.Get(PurchaseLine."Indent Req No", PurchaseLine."Indent Req Line No") then begin
                            IndentReqLine."Requisition Type" := IndentReqLine."Requisition Type"::"Purch Order";
                            IndentReqLine."Purch Order No." := PurchaseLine."Document No.";
                            IndentReqLine.Modify();
                        end;
                        //B2BVCOn15Mar2024 <<
                        PurchaseLine.Modify(true);
                        IndentVendorEnquiry.Check := TRUE;
                        IndentVendorEnquiry.MODIFY;
                        //B2BKM26APR2024 <<
                        GLSetup.Get();
                        DimValue.Reset();
                        DimValue.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                        if DimValue.FindSet() then
                            repeat
                                CreateIndents2.Reset();
                                CreateIndents2.SetRange("Shortcut Dimension 3 Code", DimValue.Code);
                                CreateIndents2.SetRange("Document No.", IndentVendorEnquiry."Indent Req No");
                                CreateIndents2.SetRange("Line No.", IndentVendorEnquiry."Indent Req Line No");
                                CreateIndents2.SetRange("Item No.", IndentVendorEnquiry."Item No.");
                                if CreateIndents2.FindFirst() then
                                    PurchaseLine."Shortcut Dimension 3 Code" := CreateIndents2."Shortcut Dimension 3 Code";
                            until DimValue.Next() = 0;
                    //B2BKM26APR2024 >>
                    UNTIL IndentVendorEnquiry.NEXT = 0;

            UNTIL IndentVendorItems.NEXT = 0;
    end;

    procedure InsertIndentItemvendor2(var CreateIndentsLocal: Record "Indent Requisitions"; var
                                                                                                Vendor: Record 23);
    var
        IndentVendorItems: Record "Indent Vendor Items";
        ItemVendor: Record 99;
        CreateIndents: Record "Indent Requisitions";
        Text000: Label 'Default Vendor is not Mentioned In the Vendor Item Catalog For  Item No ''%1''';
        Text001: Label 'First Select Vendor';
        VendorGrec: Record 23;
        IndentReqHed: Record "Indent Req Header";
    begin
        //B2B.1.3 s
        IndentVendorItems.DELETEALL;
        CreateIndents.COPYFILTERS(CreateIndentsLocal);
        IF CreateIndentsLocal.FIND('-') THEN
            REPEAT
                IF CreateIndentsLocal."Remaining Quantity" <> 0 THEN BEGIN
                    IF CreateIndentsLocal."Manufacturer Code" = '' THEN
                        ERROR(TEXT50050);
                    IndentVendorItems.INIT;
                    IndentVendorItems."Line Type" := CreateIndentsLocal."Line Type";//B2BSSD14APR2023
                    IndentVendorItems."Item No." := CreateIndentsLocal."Item No.";
                    IF CreateIndentsLocal."Qty. To Order" >= CreateIndentsLocal."Vendor Min.Ord.Qty" THEN BEGIN
                        IndentVendorItems.Quantity := CreateIndentsLocal."Qty. To Order";
                        CreateIndentsLocal."Remaining Quantity" -= CreateIndentsLocal."Qty. To Order";
                        CreateIndentsLocal.VALIDATE(CreateIndentsLocal."Remaining Quantity");
                        CreateIndentsLocal."Qty. Ordered" += IndentVendorItems.Quantity;
                        CreateIndentsLocal.MODIFY;
                    END ELSE BEGIN
                        IndentVendorItems.Quantity := CreateIndentsLocal."Vendor Min.Ord.Qty";
                        CreateIndentsLocal."Remaining Quantity" -= CreateIndentsLocal."Vendor Min.Ord.Qty";
                        IF CreateIndentsLocal."Remaining Quantity" < 0 THEN
                            CreateIndentsLocal."Remaining Quantity" := 0;
                        CreateIndentsLocal.VALIDATE(CreateIndentsLocal."Remaining Quantity");
                        CreateIndentsLocal."Qty. Ordered" += IndentVendorItems.Quantity;
                        CreateIndentsLocal.MODIFY;
                    END;
                    IndentVendorItems."Variant Code" := CreateIndentsLocal."Variant Code";
                    IndentVendorItems."Variant Description" := CreateIndentsLocal."Variant Description"; //B2BSCM11JAN2024
                    IndentVendorItems."Indent No." := CreateIndentsLocal."Indent No.";
                    IndentVendorItems."Indent Line No." := CreateIndentsLocal."Indent Line No.";
                    IndentVendorItems."Due Date" := CreateIndentsLocal."Due Date";
                    IndentVendorItems."Indent Line No." := CreateIndentsLocal."Indent Line No.";
                    IndentVendorItems."Location Code" := CreateIndentsLocal."Location Code";
                    IndentVendorItems."Unit Of Measure" := CreateIndentsLocal."Unit of Measure";//B2BSSD14APR2023
                    IndentVendorItems."Shortcut Dimension 1 Code" := CreateIndentsLocal."Shortcut Dimension 1 Code";//B2BPAV
                    IndentVendorItems."Shortcut Dimension 2 Code" := CreateIndentsLocal."Shortcut Dimension 2 Code";//B2BPAV
                    IndentVendorItems."Shortcut Dimension 9 Code" := CreateIndentsLocal."Shortcut Dimension 9 Code";//B2BSSD20Feb2023
                    IndentVendorItems."Shortcut Dimension 3 Code" := CreateIndentsLocal."Shortcut Dimension 3 Code"; //B2BVCOn02April2024
                    //B2BSSD29MAR2023<<
                    IndentReqHed.Reset();
                    IndentReqHed.SetRange("No.", CreateIndentsLocal."Document No.");
                    if IndentReqHed.FindFirst() then begin
                        IndentVendorItems."Programme Name" := IndentReqHed."programme Name";
                        IndentVendorItems.Purpose := IndentReqHed.Purpose;
                    end;
                    //B2BSSD29MAR2023>>
                    IndentVendorItems.Check := FALSE;
                    //VendorGrec.RESET;
                    IF VendorGrec.GET(CreateIndentsLocal."Manufacturer Code") THEN;
                    // IndentVendorItems."Location Code" := VendorGrec."Location Code";
                    IndentVendorItems."Sub Location Code" := CreateIndentsLocal."Sub Location Code";
                    IndentVendorItems."Unit Of Measure" := CreateIndentsLocal."Unit of Measure";
                    IndentVendorItems.Department := CreateIndentsLocal.Department;
                    IndentVendorItems."Indent Req No" := CreateIndentsLocal."Document No.";
                    IndentVendorItems."Vendor No." := CreateIndentsLocal."Vendor No.";
                    IndentVendorItems."Indent Req Line No" := CreateIndentsLocal."Line No.";
                    IndentVendorItems."Vendor No." := CreateIndentsLocal."Manufacturer Code";
                    IndentVendorItems."Item No." := CreateIndentsLocal."Item No.";
                    IndentVendorItems.INSERT;
                END;
            UNTIL CreateIndentsLocal.NEXT = 0;
        //B2B.1.3 E
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeUpdateLocationCode', '', false, false)]
    local procedure OnBeforeUpdateLocationCode(var PurchaseHeader: Record "Purchase Header"; LocationCode: Code[10]; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Enquiry then
            IsHandled := true;
    end;

    //B2BMSOn02Nov2022>>
    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnInitFromPurchHeader', '', false, false)]
    local procedure OnInitFromPurchHeader(var PurchaseHeader: Record "Purchase Header"; SourcePurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."Payment Terms Code" := SourcePurchaseHeader."Payment Terms Code";
        PurchaseHeader."Indent Requisition No" := SourcePurchaseHeader."Indent Requisition No";
    end;
    //B2BMSOn02Nov2022<<

    //B2BMSOn03Nov2022>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostUpdateOrderLineOnPurchHeaderReceive', '', false, false)]
    local procedure OnPostUpdateOrderLineOnPurchHeaderReceive(var TempPurchLine: Record "Purchase Line"; PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        ItemLRec: Record Item;
        IndentLRec: Record "Indent Line";
    begin
        if (ItemLRec.Get(TempPurchLine."No.")) and (ItemLRec."QC Enabled B2B") then begin
            TempPurchLine."Quantity Accepted B2B" += TempPurchLine."Qty. to Accept B2B";
            if (TempPurchLine."Quantity Accepted B2B" + TempPurchLine."Quantity Rejected B2B") > TempPurchLine.Quantity then
                TempPurchLine."Quantity Rejected B2B" -= TempPurchLine."Qty. to Accept B2B"
            else
                TempPurchLine."Quantity Rejected B2B" += TempPurchLine."Qty. to Reject B2B";
            TempPurchLine."Qty. to Accept B2B" := 0;
            TempPurchLine."Qty. to Reject B2B" := 0;
        end;

        if IndentLRec.Get(TempPurchLine."Indent No.", TempPurchLine."Indent Line No.") then begin
            IndentLRec.Validate("Avail.Qty");
            IndentLRec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnBeforePostPurchLine', '', false, false)]
    local procedure OnRunOnBeforePostPurchLine(var PurchLine: Record "Purchase Line")
    var
        ItemLRec: Record Item;
        //Err0001: Label 'Either Qty. to Accept or Qty. to Reject must have a value as QC was enabled.';//B2BSSD13JUN2023
        Err0001: TextConst ENN = 'Either Qty. Accepted or Qty. Rejected must have a value as QC was enabled.';//B2BSSD13JUN2023
        PurchHdr: Record "Purchase Header";
        FixedAssets: Record "Fixed Asset";
        FADepBook: Record "FA Depreciation Book";
        FASetup: Record "FA Setup";
    begin
        if (ItemLRec.Get(PurchLine."No.")) and (ItemLRec."QC Enabled B2B") then begin
            // if (PurchLine."Qty. to Receive" <> 0)
            //     and ((PurchLine."Qty. to Accept B2B" = 0) and (PurchLine."Qty. to Reject B2B" = 0)) then//B2BSSD13JUN2023
            if (PurchLine."Qty. to Receive" <> 0) and (PurchLine."Quantity Accepted B2B" = 0)
            and (PurchLine."Quantity Rejected B2B" = 0) then //B2BSSD13JUN2023
                Error(Err0001);
            if PurchLine."Qty. to Reject B2B" <> 0 then
                PurchLine.TestField("Rejection Comments B2B");
        end;
        if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
            PurchLine.TestField(Make_B2B);
            PurchLine.TestField("Model No.");
            PurchLine.TestField("Serial No.");
        end;
        //B2BSSD28FEB2023<<
        FixedAssets.Reset();
        FixedAssets.SetRange("No.", PurchLine."No.");
        FixedAssets.SetFilter(Acquired, '%1', true);
        if FixedAssets.FindSet() then begin
            FADepBook.Reset();
            FADepBook.SetRange("FA No.", FixedAssets."No.");
            FADepBook.SetRange("Depreciation Book Code", FASetup."Default Depr. Book");
            FADepBook.SetFilter("FA Posting Group", '<>%1&<>%2&<>%3', 'CWIP', 'WIP', 'WIP INTANG');
            if FADepBook.FindFirst() then
                Error('Fixed Asset Already Acquired %1 Use Another One', FixedAssets."No.");
        end;

        //B2BSSD28FEB2023>>
    end;
    //B2BMSOn03Nov2022<<    

    //B2BSSD30MAY2023>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', true, true)]
    local procedure "Purch.-Post_OnAfterPurchRcptLineInsert"
    (
        PurchaseLine: Record "Purchase Line";
        var PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemLedgShptEntryNo: Integer;
        WhseShip: Boolean;
        WhseReceive: Boolean;
        CommitIsSupressed: Boolean;
        PurchInvHeader: Record "Purch. Inv. Header";
        var TempTrackingSpecification: Record "Tracking Specification";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        TempWhseRcptHeader: Record "Warehouse Receipt Header";
        xPurchLine: Record "Purchase Line";
        var TempPurchLineGlobal: Record "Purchase Line"
    )
    var
        FixedAssets: Record "Fixed Asset";

        QRGenerator: Codeunit "QR Generator";
        TempBlob: Codeunit "Temp Blob";
        FixedAsset: Record "Fixed Asset";
        IndentLine: Record "Indent Line";
        FieldRef: FieldRef;
        RecRef: RecordRef;
        CF: Char;
        LF: Char;
        QRText: Text;
        QRDescription: Text;

    begin
        if PurchaseLine.Type = PurchaseLine.Type::"Fixed Asset" then begin
            if FixedAssets.Get(PurchaseLine."No.") then begin
                FixedAssets.Make_B2B := PurchaseLine.Make_B2B;
                FixedAssets."Serial No." := PurchaseLine."Serial No.";
                FixedAssets."Model No." := PurchaseLine."Model No.";
                FixedAssets."FA Location Code" := PurchaseLine."Location Code";//B2BSSD09MAY2023
                FixedAssets.Modify();
                //B2BSSD14JUN2023>>
                if FixedAssets.Get(PurchaseLine."No.") then
                    RecRef.GetTable(FixedAssets);
                CF := 150;
                LF := 200;
                QRText := FixedAssets."No." + ',' + 'Description : ' + FixedAssets.Description + ',' + 'Model No. : ' + FixedAsset."Model No." + ',' + 'Serial No. : ' + FixedAsset."Serial No." + ',' + 'Make. :' + FixedAsset.Make_B2B;//B2BSSD13JUN2023
                QRGenerator.GenerateQRCodeImage(QRText, TempBlob);
                FieldRef := RecRef.Field(FixedAssets.FieldNo("QR Code"));
                TempBlob.ToRecordRef(RecRef, FixedAssets.FieldNo("QR Code"));
                RecRef.Modify();
                //B2BSSD14JUN2023<<
            end;
        end;
    end;
    //B2BSSD30MAY2023<<
}

