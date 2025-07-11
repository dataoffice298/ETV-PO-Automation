report 50133 "Rate Comparative Statement"
{
    Caption = 'Rate Comparitive Statement';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './RateComparitiveStatement.rdl';

    dataset
    {
        dataitem(QuotCompHdr; QuotCompHdr)
        {
            RequestFilterFields = "No.";
            column(SNo; SNoCapLbl)
            { }
            column(Desc; DescriptionCapLbl)
            { }
            column(Qty; QtyCapLbl)
            { }
            column(Units; UnitsCapLbl)
            { }
            column(Unitrate; UnitRateCapLbl)
            { }
            column(TotalAmountCaptionLbl; TotalAmountCaptionLbl)
            { }
            column(HSNCapLbl; HSNCapLbl)
            { }
            column(GSTCapLbl; GSTCapLbl)
            { }
            column(TermsConditions; TermsConditionsCapLbl)
            { }
            column(QtnNoCapLbl; QtnNoCapLbl)
            { }
            column(RatesCapLbl; RatesCapLbl)
            { }
            column(DutiesLbl; DutiesLbl)
            { }
            column(FreightLbl; FreightLbl)
            { }
            column(IndentNoCapLbl; IndentNoCapLbl)
            { }
            column(TransportationCapLbl; TransitCapLbl)
            { }
            column(DeliveryCapLbl; DeliveryCapLbl)
            { }
            column(PaymentCapLbl; PaymentCapLbl)
            { }
            column(WarrantyCapLbl; WarrantyCapLbl)
            { }
            column(ContactPersonCapLbl; ContactPersonCapLbl)
            { }
            column(PhoneNoCapLbl; PhoneNoCapLbl)
            { }

            column(Purpose; Purpose)
            { }
            column(Indenter; "Created By")
            { }
            column(ComparitiveCapLbl; ComparitiveCapLbl)
            { }
            column(Quot_Comparitive; "Quot Comparitive")
            { }
            column(NoteLbl; NoteLbl) { }
            column(Note; Note) { }
            column(ApprovalDate; ApprovalDate)
            { }
            column(ApprovalComment; Comment)
            { }
            dataitem(QuotcompTest; "Quotation Comparison Test")
            {
                DataItemLink = "Quot Comp No." = field("No.");
                DataItemTableView = SORTING("Vendor No.", "RFQ No.", "Item No.", "Variant Code")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = false;
                column(Quote_No_; "Quote No.") { }
                column(Item_No_; "Item No.")
                { }
                column(LineNo_Quote; "Line No.")
                { }
                column(Picture_Quote; Picture)
                { }
                column(Description_QuotComp; Description)
                { }
                column(Desc1; Desc)
                { }
                column(Variant_Code; "Variant Code")
                { }
                column(Variant_Description; "Variant Description")
                { }
                column(S_No; SNo)
                { }
                /* column(GSTPerText; GSTPerText)
                { } */
                column(Parent_Quote_No_; "Parent Quote No.")
                { }
                column(Quantity; Quantity)
                { }
                column(Indent_No_; "Indent No.")
                { }
                column(Vendor_No_; "Vendor No.")
                { }
                column(Vendor_Name; "Vendor Name")
                { }
                column(City; City)
                { }
                column(Rate; Rate)
                { }
                column(PriceBasic; TransactionSpec.Text)
                { }
                column(HSNCode; HSNCode)
                { }
                column(OtherCharge; OtherCharge)
                { }
                column(Document_Date; "Document Date")
                { }
                column(OtherCharges; OtherCharges)
                { }
                column(QAmount; Amount)
                { }
                column(Amounts; Amounts)
                { }
                column(TotalAmount; TotalAmount)
                { }
                column(TotalAmtSum; TotalAmtSum)
                { }
                column(UOM; UOM)
                { }
                column(CurrencyCode; CurrencyCode)
                { }
                column(ExRate; ExRate)
                { }
                /* column(GSTPerc; GSTPerc)
                { } */
                column(BCDAmt1; BCDAmt)
                { }
                column(SWCAmt1; SWCAmt)
                { }
                column(No_PurchHdr; PurchHdr."No.")
                { }
                column(BCD; PurchHdr.BCD)
                { }
                column(SWC; PurchHdr.SWC)
                { }
                column(TotalConAmt1; TotalConversionAmt)
                { }
                column(TotalAmt2; TotalAmt2)
                { }
                /* column(Gstamt; Gstamt)
                { } */
                column(TotalAmount1; TotalAmount2)
                { }
                column(Model; ModelRec)
                { }
                column(Model_No_; "Model No.")
                { }
                column(ExciseDuty1; "Excise Duty")
                { }
                column(GST; PurchLine."GST Group Code")
                { }
                column(Picture; PurchLine.Picture)
                { }

                column(Frieght1; Freight)
                { }
                column(Delivery; Delivery)
                { }
                column(Payment; Payment)
                { }
                column(warranty; warranty)
                { }
                column(ContactPerson; ContactPerson)
                { }
                Column(PhoneNo; PhoneNo)
                { }

                column(QuotNo; PurchHdr."No.")
                { }
                column(TotalLineAmt; TotalLineAmt)
                { }
                column(QAmount1; TotalLineAmt2)
                { }
                column(CurrencyCode1; PurchHdr."Currency Code")
                { }
                column(GstTotalSum; GstTotalSum)
                { }

                column(GSTPercent1; GSTPercent1)
                { }
                column(Indentor_Description; IndentDesc)
                { }
                column(Spec_Id; "Spec Id")
                { }
                column(Quot_No; QuotNo)
                { }
                column(QuotDate; QuotDate)
                { }

                dataitem(QuoteSpecifications; QuoteSpecifications)
                {
                    DataItemLink = "Document No." = field("Parent Quote No."), "Doc Line No." = field("Parent Quote Line No"), "Item No." = field("Item No.");
                    column(Description; Description)
                    { }
                    column(Description2; Description2)
                    { }
                    column(Description3; Description3)
                    { }
                    column(Line_No_; "Line No.")
                    { }
                    column(Unit_Price; "Unit Price")
                    { }
                    column(Total_Amount; ("Total Amount" + GstTotal))
                    { }
                    column(Document_No_; "Document No.")
                    { }
                    column(Doc_Line_No_; "Doc Line No.")
                    { }
                    column(Item_No; "Item No.")
                    { }

                }
                dataitem(PurchCommentLine; "Purch. Comment Line")
                {
                    DataItemLink = "No." = field("Parent Quote No."), "Document Line No." = field("Parent Quote Line No");
                    column(Comment; PurchCommentLine.Comment)
                    { }
                    column(LineNo_PurchCommentLine; PurchCommentLine."Line No.")
                    { }
                    column(No_PurchCommentLine; PurchCommentLine."No.")
                    { }
                }
                dataitem("PO Terms And Conditions"; "PO Terms And Conditions")
                {
                    DataItemLink = DocumentNo = field("Parent Quote No.");
                    DataItemTableView = where(Type = filter("Terms & Conditions"));
                    column(LineType; LineType)
                    {
                    }
                    column(DocumentNo_Terms; DocumentNo)
                    { }
                    column(Description11; Description)
                    {
                    }
                    column(Line_Type; Line_Type)
                    {

                    }
                    column(LineNo; LineNo)
                    { }
                    column(Type_Terms; Type)
                    { }
                    column(SNo_; "SNo.")
                    { }
                    trigger OnAfterGetRecord()
                    var
                        i: Integer;
                        MidString: array[2000] of Text;
                    begin
                        Clear(i);
                        Clear(Line_Type);
                        Clear(ListTypeNew);
                        ListTypeNew := "PO Terms And Conditions".LineType;
                        i := i + 1;
                        MidString[i] := SplitStrings(ListTypeNew, ' ');
                        Line_Type := Line_Type + ' ' + UPPERCASE(COPYSTR(MidString[i], 1, 1)) + LOWERCASE(COPYSTR(MidString[i], 2));
                    end;
                }
                dataitem("PO Specifications"; "PO Specifications")
                {
                    DataItemLink = DocumentNo = field("Parent Quote No.");
                    DataItemTableView = where(Type = filter(Specifications));
                    column(PO_LineType; LineType)
                    { }
                    column(PO_DocumentNo; DocumentNo)
                    { }
                    column(PO_Description11; Description)
                    { }
                    column(PO_Line_Type; Line_Type)
                    { }
                    column(PO_LineNo; LineNo)
                    { }
                    column(PO_Type; Type)
                    { }
                    trigger OnAfterGetRecord()
                    var
                        i: Integer;
                        MidString: array[2000] of Text;
                    begin
                        Clear(i);
                        Clear(Line_Type);
                        Clear(ListTypeNew);
                        ListTypeNew := "PO Specifications".LineType;
                        i := i + 1;
                        MidString[i] := SplitStrings(ListTypeNew, ' ');
                        Line_Type := Line_Type + ' ' + UPPERCASE(COPYSTR(MidString[i], 1, 1)) + LOWERCASE(COPYSTR(MidString[i], 2));
                    end;
                }

                dataitem("Purchase Line"; "Purchase Line")
                {
                    DataItemLink = "Document No." = field("Parent Quote No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                    column(GSTPerc; GSTPerc)
                    { }

                }
                dataitem(GSTLoop; Integer)
                {
                    DataItemTableView = sorting(Number);
                    DataItemLinkReference = "Purchase Line";
                    column(Number_GSTLoop; Number)
                    { }
                    column(GSTGroupCode_PurchLineGST; PurchLineGST."GST Group Code")
                    { }
                    column(GSTPerText; GSTPerText)
                    { }
                    column(Gstamt; Gstamt)
                    { }
                    trigger OnPreDataItem()
                    begin
                        Clear(GSTGroupCode);
                        I := 1;
                        PurchLineGST.Reset();
                        PurchLineGST.SetCurrentKey("GST Group Code");
                        PurchLineGST.SetRange("Document No.", PurchHdr."No.");
                        PurchLineGST.SetFilter("GST Group Code", '<>%1', '');
                        PurchLineGST.SetFilter("No.", '<>%1', '');
                        if PurchLineGST.Findset() then;
                        PurchLineGST.SetAscending("GST Group Code", true);
                        SetRange(Number, 1, PurchLineGST.Count);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        Clear(GSTPerText);
                        Clear(GSTPercent);
                        Clear(Gstamt);
                        clear(GstTotalSum);
                        if GSTGroupCode <> "Purchase Line"."GST Group Code" then begin
                            GSTGroupCode := "Purchase Line"."GST Group Code";
                            PurchLine.Reset();
                            PurchLine.SetCurrentKey("GST Group Code");
                            PurchLine.SetRange("Document No.", "Purchase Line"."Document No.");
                            if PurchLine.FindSet() then begin
                                GetGSTPercents(PurchLine);
                                if GSTPercent <> 0 then begin
                                    I += 1;
                                    GSTPerText := StrSubstNo(GSTText, GSTPercent);
                                    repeat
                                        Clear(SGSTAmt);
                                        Clear(IGSTAmt);
                                        Clear(CGSTAmt);
                                        GetGSTAmounts(PurchLine);
                                        Gstamt += CGSTAmt + SGSTAmt + IGSTAmt;
                                    until PurchLine.Next() = 0;
                                end;
                            end;
                        end;

                        if PurchLineGST.Next() = 0 then;

                    end;
                }

                trigger OnAfterGetRecord()
                var
                    PurchHeaderRec: Record "Purchase Header";
                    VendorRec: Record Vendor;
                    OrderAddressRec: Record "Order Address";
                begin

                    Clear(HSNCode);
                    Clear(UOM);
                    Clear(ContactPerson);
                    Clear(PhoneNo);
                    Clear(TotalAmount);
                    Clear(GSTPercent1);
                    Clear(IndentDesc);
                    Clear(SpecId);
                    Clear(QuotNo);
                    Clear(QuotDate);
                    Clear(City);


                    if "Item No." <> '' then begin
                        if ItemNo <> "Item No." then begin
                            ItemNo := "Item No.";
                            Desc := Description;
                            SNo += 1;
                        end;
                    end;

                    //B2BAnusha19Feb2025>>
                    PurchHdr.Reset();
                    PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Quote);
                    PurchHdr.SetRange("No.", QuotcompTest."Parent Quote No.");
                    PurchHdr.setrange("Buy-from Vendor No.", QuotcompTest."Vendor No.");
                    if PurchHdr.FindFirst() then begin
                        QuotNo := PurchHdr."Vendor Quotation No.";
                        QuotDate := PurchHdr."Vendor Quotation Date";
                        City := PurchHdr."Buy-from City";
                        if VendorRec.Get(PurchHdr."Buy-from Vendor No.") then begin
                            OrderAddressRec.Reset();
                            OrderAddressRec.setrange("Vendor No.", VendorRec."No.");
                            OrderAddressRec.SetRange("Mail Alert", true);
                            Clear(ContactPerson);
                            clear(PhoneNo);
                            if OrderAddressRec.FindSet() then begin
                                repeat
                                    if OrderAddressRec."Contact Name" <> '' then
                                        ContactPerson := ContactPerson + OrderAddressRec."Contact Name" + ',';
                                    if OrderAddressRec."Phone No." <> '' then
                                        PhoneNo := PhoneNo + OrderAddressRec."Phone No." + ',';
                                until OrderAddressRec.next() = 0;
                            end;
                            ContactPerson := DelChr(ContactPerson, '<>', ',');
                            PhoneNo := DelChr(PhoneNo, '<>', ',');
                        end;
                        //B2BAnusha19Feb2025<<
                        if TransactionSpec.Get(PurchHdr."Transaction Specification") then;
                    end;


                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Quote);
                    PurchLine.SetRange("Document No.", "Parent Quote No.");
                    PurchLine.SetRange("Line No.", "Parent Quote Line No");
                    if PurchLine.FindFirst() then begin
                        HSNCode := PurchLine."HSN/SAC Code";
                        UOM := PurchLine."Unit of Measure Code";
                        IndentDesc := PurchLine."Indentor Description";
                        if PurchLine."Spec Id" <> '' then
                            SpecId := PurchLine."Spec Id";

                    end;

                    PurchLine1.Reset;
                    PurchLine1.Setrange("Document No.", QuotcompTest."Parent Quote No.");
                    PurchLine1.SetRange("Line No.", QuotcompTest."Parent Quote Line No");
                    PurchLine1.SetRange("No.", QuotcompTest."Item No.");
                    PurchLine1.SetRange("Buy-from Vendor No.", QuotcompTest."Vendor No.");
                    if PurchLine1.FindFirst() then begin
                        Clear(CGSTAmt);
                        clear(SGSTAmt);
                        clear(IGSTAmt);
                        GetGSTAmounts(PurchLine1);
                        GstTotal := CGSTAmt + SGSTAmt + IGSTAmt;
                        GSTPercent1 += SGSTPer + CGSTPer + IGSTPer;
                        TotalAmount := PurchLine1."Line Amount" + GstTotal;
                        if VendorNo = '' then begin
                            VendorNo := QuotcompTest."Vendor No.";
                            TotalAmtSum += TotalAmount;
                        end else begin
                            if VendorNo = QuotcompTest."Vendor No." then begin
                                TotalAmtSum += TotalAmount;
                            end else begin
                                if VendorNo <> QuotcompTest."Vendor No." then begin
                                    VendorNo := QuotcompTest."Vendor No.";
                                    Clear(TotalAmtSum);
                                    TotalAmtSum += TotalAmount;
                                end;
                            end;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    Clear(TotalLineAmt2);
                    Clear(TotalLineAmt);
                    Clear(SNo);
                    SetFilter("Item No.", '<>%1', '');
                    SetFilter(Quantity, '<>%1', 0);
                    SetFilter("Quote No.", '');
                    SetFilter("Parent Quote Line No", '<>%1', 0);
                end;

            }

            trigger OnAfterGetRecord()
            begin
                // CompanyInfo.get;
                // CompanyInfo.CalcFields(Picture);

                Clear(ApprovalDate);
                clear(Comment);
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", QuotCompHdr."No.");
                ApprovalEntry.SetRange(Comment, true);
                if ApprovalEntry.FindLast() then begin
                    if (ApprovalEntry.Status = ApprovalEntry.Status::Approved) OR (ApprovalEntry.Status = ApprovalEntry.Status::Rejected) then begin
                        ApprovalDate := DT2Date(ApprovalEntry."Last Date-Time Modified");

                        ApprovalCommentLine.Reset();
                        ApprovalCommentLine.SetCurrentKey("Entry No.");
                        ApprovalCommentLine.SetRange("Table ID", ApprovalEntry."Table ID");
                        ApprovalCommentLine.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
                        if ApprovalCommentLine.FindLast() then
                            Comment := ApprovalCommentLine.Comment;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Clear(TotalLineAmt2);
                Clear(TotalLineAmt);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    /* field("RFQ No."; RFQNOG)
                    {
                        ApplicationArea = All;

                    } */
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    local procedure GetGSTAmounts(PurchaseLine: Record "Purchase Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        Clear(SGSTPer);
        Clear(CGSTPer);
        Clear(IGSTPer);
        Clear(GSTPerc);
        GSTSetup.Get();

        ComponentName := GetComponentName("Purchase Line", GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                SGSTPer := TaxTransactionValue.Percent;
                            end;

                        2:
                            begin
                                CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;

                        3:
                            begin
                                IGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;

                    end;
                    GSTPerc := SGSTPer + CGSTPer + CGSTPer;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl;
        exit(ComponentName)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
        GSTSetup.TestField("GST Tax Type");

        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;

    local procedure GetGSTPercents(PurchaseLine: Record "Purchase Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        ComponentName := GetComponentName("Purchase Line", GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    GSTPercent += TaxTransactionValue.Percent;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    procedure SplitStrings(VAR String: Text[1024]; Separator: Text[1]) SplitedString: Text[1024]
    var
        Pos: Integer;
    begin
        Clear(Pos);
        Pos := STRPOS(String, Separator);
        if Pos > 0 then begin
            SplitedString := COPYSTR(String, 1, Pos - 1);
            if Pos + 1 <= STRLEN(String) then
                String := COPYSTR(String, Pos + 1)
            else
                Clear(String);
        end else begin
            SplitedString := String;
            Clear(String);
        end;
    end;



    var
        SNoCapLbl: Label 'SNo.';
        DescriptionCapLbl: Label 'Description';
        HSNCapLbl: Label 'HSN Code';

        QtyCapLbl: Label 'Qty.';
        UnitsCapLbl: Label 'UOM';
        UnitRateCapLbl: Label 'Unit Rate';
        TotalAmountCaptionLbl: Label 'Total Amount with GST';
        TermsConditionsCapLbl: Label ' Terms & Conditions :';
        QtnNoCapLbl: Label ' Qtn No. & Dt.:';
        ComparitiveCapLbl: Label 'RATE COMPARATIVE STATEMENT OF';
        RatesCapLbl: Label ' Price Basis:';
        GSTCapLbl: Label ' GST %';
        GSTPerText: Text;
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        BCDAmt: Decimal;
        QuoCompHdr: Record QuotCompHdr;
        SWCAmt: Decimal;
        TotalConversionAmt: Decimal;
        GSTGroupCode: Code[50];
        QuoComp: Record "Quotation Comparison Test";
        DeliveryDays: Date;
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        DutiesLbl: Label ' Duties & Levies:';
        FreightLbl: Label ' Freight:';
        GSTText: Label 'GST @%1%';
        TransitCapLbl: Label ' Transit Insurance:';
        DeliveryCapLbl: Label ' Delivery:';
        PaymentCapLbl: Label ' Payment:';
        WarrantyCapLbl: Label ' Warranty:';
        ContactPersonCapLbl: Label ' CONTACT PERSON';
        PhoneNoCapLbl: Label ' PHONE NO';
        UnitPrice: Decimal;
        TotalAmt2: Decimal;
        PurchLineGST: Record "Purchase Line";
        IndentNoCapLbl: Label 'Indent No.';
        PhoneNo: Text;
        TotalAmount2: Decimal;
        GSTPercent1: Decimal;
        SNo: Integer;
        I: Integer;
        CGSTAmt: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        Gstamt: Decimal;
        SGSTPer: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        GSTSetup: Record "GST Setup";
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        UnitRate: Decimal;
        GSTPercent: Decimal;
        GSTPerc: Decimal;
        Payment: code[50];
        SalesPersonPurch: Record "Salesperson/Purchaser";
        ContactPerson, Note : Text;
        TransactionSpec: Record "Transaction Specification";
        OtherCharge: Label 'Freight, Insurance, Bank Charges, Local Transportation etc.,';
        NoteLbl: Label 'Note:';
        PurchLine: Record "Purchase Line";
        PurchHdr: Record "Purchase Header";
        OtherCharges: Decimal;
        HSNCode: Code[10];
        UOM: Code[10];
        QAmount: Decimal;
        QAmount1: Decimal;
        Amounts: Decimal;
        Amounts1: Decimal;
        TotalAmount: Decimal;
        TotalAmount1: Decimal;
        ExRate: Decimal;
        ExRate1: Decimal;
        CurrencyCode: Text;
        TotalLineAmt: Decimal;
        TotalLineAmt1: Decimal;
        TotalLineAmt2: Decimal;
        GstTotal: Decimal;
        GstTotalSum: Decimal;
        //TotalGSTAmt: Decimal;
        TotalAmountRec: Decimal;
        QuotCompTestLine: Record "Quotation Comparison Test";
        PurchLine1: Record "Purchase Line";
        LineSNo, Line_Type, ListTypeNew : Text;
        ItemNo: Code[20];
        Desc: Text;
        ModelRec: Code[250];
        IndentDesc: Text;
        SpecId: Text;
        QuotNo: Code[20];
        QuotDate: Date;
        RFQNOG: Code[20];
        PurchaseLine: Record "Purchase Line";
        TotalAmtSum: Decimal;
        VendorNo: Code[20];
        City: Text;
        ApprovalEntry: Record "Approval Entry";
        ApprovalCommentLine: Record "Approval Comment Line";
        Comment: Text;
        ApprovalDate: Date;



}