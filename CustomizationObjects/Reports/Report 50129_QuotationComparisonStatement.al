report 50129 "Quot Comparision Statement"
{

    DefaultLayout = RDLC;
    RDLCLayout = './QuotComparisonStatement.rdl';
    Caption = 'Quotation Comparison Statement';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number);
            PrintOnlyIfDetail = false;
            column(Number_Integer; Number)
            {
            }
            column(SNoCapLbl; SNoCapLbl)
            { }
            column(DescriptionCapLbl; DescriptionCapLbl)
            { }
            column(HSNCodeCapLbl; HSNCodeCapLbl)
            { }
            column(QtyCapLbl; QtyCapLbl)
            { }
            Column(UnitsCapLbl; UnitsCapLbl)
            { }
            column(ModelCapLbl; ModelCapLbl)
            { }
            /*  column(MRPCapLbl; MRPCapLbl)
             { } */
            column(GSTCapLbl; GSTCapLbl)
            { }
            column(RatesCapLbl; RatesCapLbl)
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
            column(QtnNoCapLbl; QtnNoCapLbl)
            { }
            column(RateCaption; RateCaption)
            { }
            column(TransMethod; TransMethod)
            { }
            column(SerialNo; SerialNo)
            { }
            column(OtherChargesCaptionLbl; OtherCharge)
            { }
            column(DutiesLbl; DutiesLbl)
            { }
            column(FreightLbl; FreightLbl)
            { }



            dataitem(DataItem1102152028; "Quotation Comparison Test")
            {
                DataItemTableView = SORTING("RFQ No.", "Item No.", "Variant Code")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = false;
                column(ComparitiveCapLbl; ComparitiveCapLbl)
                {

                }
                column(CompanyInfoName; CompanyInfo.Name)
                {
                }
                column(QuotationComparisonStatementCaptionLbl; QuotationComparisonStatementCaptionLbl)
                {
                }
                column(REQNoCaptionLbl; REQNoCaptionLbl)
                {
                }
                column(VendorNoCaptionLbl; VendorNoCaptionLbl)
                {
                }
                column(VendorNameCaptionLbl; VendorNameCaptionLbl)
                {
                }
                column(QuoteNoCaptionLbl; QuoteNoCaptionLbl)
                {
                }
                column(ItemNoCaptionLbl; ItemNoCaptionLbl)
                {
                }
                column(DescriptionCaptionLbl; DescriptionCaptionLbl)
                {
                }
                column(UOMCaptionLbl; UOMCaptionLbl)
                {
                }
                column(QuantityCaptionLbl; QuantityCaptionLbl)
                {
                }
                column(RateCaptionLbl; RateCaptionLbl)
                {
                }
                column(AmountCaptionLbl; AmountCaptionLbl)
                {
                }
                column(TotalBasicValueCaptionLbl; TotalBasicValueCaptionLbl)
                {
                }
                column(ExiseDutyCaptionLbl; ExiseDutyCaptionLbl)
                {
                }
                column(SalesTaxCaptionLbl; SalesTaxCaptionLbl)
                {
                }
                column(VATCaptionLbl; VATCaptionLbl)
                {
                }
                /* column(OtherChargesCaptionLbl; OtherChargesCaptionLbl)
                {
                } */
                column(TotalAmountCaptionLbl; TotalAmountCaptionLbl)
                {
                }
                column(PaymentTermCodeCaptionLbl; PaymentTermCodeCaptionLbl)
                {
                }
                column(RFQNo_QuotationComparison; "RFQ No.")
                {
                }
                column(ItemNo_QuotationComparison; "Item No.")
                {
                }
                column(VariantCode_QuotationComparison; "Variant Code")
                {
                }
                column(Description_QuotationComparison; Description)
                {
                }
                column(UOM; UOM)
                {
                }
                column(BCD; BCD)
                { }
                column(SWCBCD; SWCBCD)
                { }
                column(Vendor1; Vendor[Integer.Number])
                {
                }
                column(VendorName1; VendorName[Integer.Number])
                {
                }
                column(QuoteNo1; QuoteNo[Integer.Number])
                {
                }
                column(Qty1; Qty[Integer.Number])
                {
                }
                column(CurrencyCode1; CurrencyCode[Integer.Number])
                { }

                column(VendorAmount1; VendorAmount[Integer.Number])
                {
                }
                column(ExciseDuty1; ExciseDuty[Integer.Number])
                {
                }
                column(SalesTax1; SalesTax[Integer.Number])
                {
                }
                column(VAT11; VAT1[Integer.Number])
                {
                }
                column(Frieght1; Frieght[Integer.Number])
                { }
                column(Pf1; Pf[Integer.Number])
                {
                }
                column(TotalAmount1_1; "Total Amount1"[Integer.Number])
                {
                }
                column(PaymentTermCode1; PaymentTermCode[Integer.Number])
                {
                }
                column(IndentNoCapLbl; IndentNoCapLbl)
                { }
                column(PurposeCapLbl; PurposeCapLbl)
                { }
                column(NameoftheIndentorCapLbl; NameoftheIndentorCapLbl)
                { }

                column(UnitRateCapLbl; UnitRateCapLbl)
                { }

                column(TermsConditionsCapLbl; TermsConditionsCapLbl)
                { }

                column(RsCapLbl; RsCapLbl)
                { }
                column(IndentNo; IndentNo)
                { }
                column(Document_Date; "Document Date")
                { }
                column(Indentor; Indentor)
                { }
                column(HSNCode; HSNCode)
                { }
                column(Indent_No_; "Indent No.")
                { }
                column(LineNo_Quot; "Line No.")
                { }
                column(Quot_Comp_No_; "Quot Comp No.")
                { }
                column(GST; GST)
                { }
                column(GSTPerText; GSTPerText)
                { }
                column(CollectedCapLbl; CollectedCapLbl)
                { }
                column(Payment; Payment)
                { }
                column(warranty; warranty)
                { }
                column(Delivery; Delivery)
                { }
                column(Rate; Rate)
                { }
                column(Parent_Quote_No_; "Parent Quote No.")
                { }
                column(ContactPerson; ContactPerson)
                { }
                Column(PhoneNo; PhoneNo)
                { }
                column(Variant_Code; "Variant Code")
                { }
                column(Variant_Description; "Variant Description")
                { }
                column(OtherCharges; OtherCharges)
                { }
                column(Model; PurchLine.Model)
                { }
                column(Desc; DescriptionVar)
                { }
                column(ExchRate; ExRate)
                { }
                column(Totalamt1; TotalAmt[Integer.Number])
                { }
                column(BCDAmt1; BCDAmt[Integer.Number])
                { }
                column(SWCAmt1; SWCAmt[Integer.Number])
                { }
                column(TotalBCDAmt; TotalBCDAmt[Integer.Number])
                { }
                column(TotalSWCBCDAmt; TotalSWCBCDAmt[Integer.Number])
                { }
                column(IGST; PurchHdr.IGST)
                { }
                column(SWC; PurchHdr.SWC)
                { }
                column(GSTPerc; GSTPerc)
                { }
                column(Gstamt; Gstamt[i])
                { }
                column(TotalConAmt1; TotalConversionAmt[Integer.Number])
                { }
                column(TotalAmount1; TotalAmount)
                { }
                column(TotalAmt2; TotalAmt2[Integer.Number])
                { }
                column(IGSTAmount; IGSTAmount[Integer.Number])
                { }
                column(Landingcost; Landingcost[Integer.Number])
                { }
                column(Vendor_Name; "Vendor Name")
                { }
                column(PriceBasic; TransactionSpec.Text)
                { }
                column(QRate1; QRate[Integer.Number])
                {
                }
                column(QAmount1; QAmount[Integer.Number])
                {
                }
                column(QuotCompDescription; QuotCompDescription)
                { }

                dataitem(QuoteSpecifications; QuoteSpecifications)
                {
                    DataItemLink = "Document No." = field("Parent Quote No."), "Doc Line No." = field("Parent Quote Line No"), "Item No." = field("Item No.");
                    column(Description; Description)
                    { }
                    column(Line_No_; "Line No.")
                    { }
                }
                trigger OnAfterGetRecord();
                var
                    PurchHeaderRec: Record "Purchase Header";
                    VendorRec: Record Vendor;
                    OrderAddressRec: Record "Order Address";
                begin
                    Clear(QRate);
                    Clear(QAmount);
                    Qty[Integer.Number] := Quantity;
                    QRate[Integer.Number] := Rate;
                    QAmount[Integer.Number] := Quantity * Rate;
                    PaymentTermCode[Integer.Number] := "Payment Term Code";
                    VendorAmount[Integer.Number] += Quantity * Rate;
                    Pf[Integer.Number] += "P & F";
                    ExciseDuty[Integer.Number] += "Excise Duty";
                    VAT1[Integer.Number] += VAT;
                    Frieght[Integer.Number] += Freight;
                    Insurance1[Integer.Number] += Insurance;
                    //"Total Amount1"[Integer.Number] += "Amt. including Tax";

                    QuoCompHdr.Reset();
                    IF QuoCompHdr.FINDLAST THEN
                        SerialNo := SerialNo + 1
                    ELSE
                        SerialNo := 1;


                    Clear(HSNCode);
                    Clear(UOM);
                    Clear(BCD);
                    Clear(SWCBCD);

                    if DescriptionVar = '' then
                        DescriptionVar := Description;
                    PurchHdr.Reset();
                    PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Quote);
                    PurchHdr.SetRange("No.", "Parent Quote No.");
                    if PurchHdr.FindFirst() then begin
                        Payment := PurchHdr."Payment Terms Code";
                        warranty := PurchHdr.Warranty;
                        if SalesPersonPurch.Get(PurchHdr."Purchaser Code") then begin
                            ContactPerson := SalesPersonPurch.Name;
                            PhoneNo := SalesPersonPurch."Phone No.";
                        end;
                        if TransactionSpec.Get(PurchHdr."Transaction Specification") then;
                    end;

                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Quote);
                    PurchLine.SetRange("Document No.", "Parent Quote No.");
                    PurchLine.SetRange("Line No.", "Parent Quote Line No");
                    if PurchLine.FindFirst() then begin
                        OtherCharges := PurchLine."Other Charges";
                        HSNCode := PurchLine."HSN/SAC Code";
                        UOM := PurchLine."Unit of Measure Code";
                        GST := PurchLine."GST Group Code";
                        BCD := PurchLine.BCD;
                        SWCBCD := PurchLine."SWC on BCD";
                        "Total Amount1"[Integer.Number] := (Quantity * Rate) + PurchLine."Other Charges";
                        if (PurchHdr."Currency Code" <> 'IND') AND (PurchHdr."Currency Code" <> '') then begin
                            ExRate := Round((1 / PurchHdr."Currency Factor"), 0.1);
                            TotalAmt[Integer.Number] := "Total Amount1"[Integer.Number] * (1 / PurchHdr."Currency Factor");
                        end;
                    end;

                    if PurchHdr.Get(PurchHdr."Document Type"::Quote, "Parent Quote No.") then begin
                        if (PurchHdr."Currency Code" <> 'IND') AND (PurchHdr."Currency Code" <> '') then begin
                            BCDAmt[Integer.Number] := Round((TotalAmt[Integer.Number] / 100) * BCD, 0.1);
                            TotalBCDAmt[Integer.Number] += BCDAmt[Integer.Number];
                            SWCAmt[Integer.Number] := Round((BCDAmt[Integer.Number] / 100) * SWCBCD, 0.1);
                            TotalSWCBCDAmt[Integer.Number] += SWCAmt[Integer.Number];
                            TotalConversionAmt[Integer.Number] += TotalAmt[Integer.Number];
                            //TotalConversionAmt[Integer.Number] := TotalAmt[Integer.Number] + BCDAmt[Integer.Number] + SWCAmt[Integer.Number];
                        end;
                    end;
                    if (PurchHdr."Currency Code" <> 'IND') AND (PurchHdr."Currency Code" <> '') then
                        TotalAmt2[Integer.Number] := TotalConversionAmt[Integer.Number] + TotalBCDAmt[Integer.Number] + TotalSWCBCDAmt[Integer.Number]
                    else
                        TotalAmt2[Integer.Number] += "Total Amount1"[Integer.Number];

                    if PurchHdr.IGST <> 0 then
                        IGSTAmount[Integer.Number] := (TotalAmt2[Integer.Number] / 100) * PurchHdr.IGST;

                    Landingcost[Integer.Number] := TotalAmt2[Integer.Number] + IGSTAmount[Integer.Number];



                    GSTSetup.get();
                    Clear(GSTPerText);
                    Clear(GSTPercent);
                    PurchLine.Reset();
                    PurchLine.SetCurrentKey("GST Group Code");
                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Quote);
                    PurchLine.SetRange("Document No.", "Parent Quote No.");
                    if PurchLine.FindSet() then begin
                        GetGSTPercents(PurchLine);
                        if GSTPercent <> 0 then begin
                            i += 1;
                            GSTPerText := StrSubstNo(GSTText, GSTPercent);
                            repeat
                                Clear(SGSTAmt);
                                Clear(IGSTAmt);
                                Clear(CGSTAmt);
                                GetGSTAmounts(TaxTransactionValue, PurchLine, GSTSetup);
                                Gstamt[i] += CGSTAmt + SGSTAmt + IGSTAmt;
                            until PurchLine.Next = 0;
                        end;
                    end;

                    if (PurchHdr."Currency Code" <> 'IND') AND (PurchHdr."Currency Code" <> '') then
                        TotalAmount := TotalAmt2[Integer.Number] + Gstamt[i]
                    else
                        TotalAmount := TotalAmt2[Integer.Number] + Gstamt[i];
                    QuoComp.Reset();
                    QuoComp.SetRange("Quot Comp No.", "Quot Comp No.");
                    If QuoComp.Findset() then
                        UnitPrice := QuoComp.Rate;
                    DeliveryDays := QuoComp."Delivery Date";
                    Indentor := QuoCompHdr."Created By";

                    Clear(QuotCompDescription);
                    if QuotCompHead.Get("Quot Comp No.") then
                        QuotCompDescription := QuotCompHead."Quot Comparitive";


                end;

                trigger OnPreDataItem();
                begin
                    SETRANGE("RFQ No.", RFQNOG);
                    SETRANGE("Parent Quote No.", QuoteNo[Integer.Number]);
                    SETRANGE("Parent Vendor", Vendor[Integer.Number]);

                    Clear(QRate);
                    Clear(QAmount);
                end;
            }

            trigger OnPreDataItem();
            begin
                SETRANGE(Number, 1, NoofVendors);
                Clear(QRate);
                Clear(QAmount);
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(QRate);
                Clear(QAmount);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Control")
                {
                    field("RFQ No."; RFQNOG)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        i := 1;
        //RFQNOG := '125';
        PurchHeader.RESET;
        PurchHeader.SETRANGE("Document Type", PurchHeader."Document Type"::Quote);
        PurchHeader.SETRANGE("RFQ No.", RFQNOG);
        IF PurchHeader.FINDSET THEN
            REPEAT
                Vendor[i] := PurchHeader."Buy-from Vendor No.";
                VendorName[i] := PurchHeader."Buy-from Vendor Name";
                QuoteNo[i] := PurchHeader."No.";
                if PurchHeader."Currency Code" <> '' then
                    CurrencyCode[i] := PurchHeader."Currency Code"
                else
                    CurrencyCode[i] := 'Rs.';
                i += 1;
            UNTIL PurchHeader.NEXT = 0;
        NoofVendors := i;
        CompanyInfo.GET;
    end;

    local procedure GetGSTAmounts(TaxTransactionValue: Record "Tax Transaction Value";
    PurchaseLine: Record "Purchase Line";
    GSTSetup: Record "GST Setup")
    var
        ComponentName: Code[50];
    begin
        Clear(SGSTPer);
        Clear(CGSTPer);
        Clear(IGSTPer);
        Clear(GSTPerc);

        ComponentName := GetComponentName(PurchaseLine, GSTSetup);

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
                                IGSTPer := TaxTransactionValue.Percent;
                            end;
                    end;
                    GSTPerc := CGSTPer + SGSTPer + IGSTPer;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
       GSTSetup: Record "GST Setup"): Code[50]
    var
        ComponentName: Code[50];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl
        else
            if GSTSetup."Cess Tax Type" = GSTCESSLbl then
                ComponentName := CESSLbl;
        exit(ComponentName)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[50]): Decimal
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
        ComponentName := GetComponentName(PurchaseLine, GSTSetup);

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

    var
        TransportMethod: Record "Transport Method";
        TransactionSpecification: Record "Transaction Specification";
        PurchaseQuote: Record "Purchase Header";
        ComparitiveCapLbl: Label 'Comparitive Statement';
        PurchLine: Record "Purchase Line";
        PurchHdr: Record "Purchase Header";
        HSNCode: Code[50];
        QuoComp: Record "Quotation Comparison Test";
        QuoCompHdr: Record QuotCompHdr;
        UnitPrice: Decimal;
        GSTPercent: Decimal;
        GSTPerText: Text;
        GSTText: Label 'GST @%1%';
        TotalAmt2: array[10] of Decimal;
        TransactionSpec: Record "Transaction Specification";
        OtherCharges: Decimal;

        IndentHdr: Record "Indent Header";
        Qty: array[10] of Decimal;
        QRate: array[10] of Decimal;
        QAmount: array[10] of Decimal;
        Vendor: array[10] of Code[50];
        VendorName: array[10] of Text[50];
        QuoteNo: array[10] of Code[50];
        CurrencyCode: array[10] of Code[10];
        SpecDesc: array[10] of Code[250];

        VendorAmount: array[15] of Decimal;
        VendorDup: Code[20];
        Pf: array[10] of Decimal;
        ExciseDuty: array[10] of Decimal;
        SalesTax: array[10] of Decimal;
        VAT1: array[10] of Decimal;
        Frieght: array[10] of Decimal;
        Insurance1: array[10] of Decimal;
        "Total Amount1": array[10] of Decimal;
        Charges: array[10] of Decimal;
        ExRate: Decimal;
        TotalAmt: array[10] of Decimal;
        BCDAmt: array[10] of Decimal;
        SWCAmt: array[10] of Decimal;
        TotalBCDAmt: array[10] of Decimal;
        TotalSWCBCDAmt: array[10] of Decimal;
        TotalConversionAmt: array[10] of Decimal;
        IGSTAmount: array[10] of Decimal;
        Landingcost: array[10] of Decimal;
        TotalAmount: Decimal;

        i: Integer;
        j: Integer;
        k: Integer;
        l: Integer;
        ItemRec: Record 27;
        UOM: Code[20];
        BCD: Decimal;
        SWCBCD: Decimal;

        PaymentTermCode: array[10] of Code[50];
        QuotationComparisonStatementCaptionLbl: Label 'Quotation Comparison Statement';
        REQNoCaptionLbl: Label 'REQ No.';
        VendorNoCaptionLbl: Label 'Supplier No.';
        VendorNameCaptionLbl: Label 'Supplier Name';
        QuoteNoCaptionLbl: Label 'Quote No.';
        ItemNoCaptionLbl: Label 'Item No.';
        DescriptionCaptionLbl: Label 'Description';
        UOMCaptionLbl: Label 'UOM';
        QuantityCaptionLbl: Label 'Quantity';
        RateCaptionLbl: Label 'Rate';

        AmountCaptionLbl: Label 'Amount';
        TotalBasicValueCaptionLbl: Label 'Total Basic Value';
        ExiseDutyCaptionLbl: Label 'Exise Duty';
        SalesTaxCaptionLbl: Label 'Sales Tax';
        VATCaptionLbl: Label 'VAT';
        //OtherChargesCaptionLbl: Label 'Other Charges';
        TotalAmountCaptionLbl: Label 'Total Amount';
        PaymentTermCodeCaptionLbl: Label 'Payment Term Code';
        CompanyInfo: Record 79;
        PurchHeader: Record 38;
        NoofVendors: Integer;
        RFQNOG: Code[50];
        IndentNo: Code[50];
        IndentNoCapLbl: Label 'Indent No.';
        PurposeCapLbl: Label 'Purpose';
        NameoftheIndentorCapLbl: Label 'Name of the Indentor';
        SNoCapLbl: Label 'SNo.';
        DescriptionCapLbl: Label 'Description';
        HSNCodeCapLbl: Label 'HSN Code';
        QtyCapLbl: Label 'Qty.';
        UnitsCapLbl: Label 'Units';
        ModelCapLbl: Label ' Model No.:';
        MRPCapLbl: Label ' MRP';
        TermsConditionsCapLbl: Label ' Terms & Conditions';
        QtnNoCapLbl: Label ' Qtn No. & Dt.:';
        RatesCapLbl: Label ' Price Basis:';
        GSTCapLbl: Label ' GST:';
        DutiesLbl: Label ' Duties & Levies:';
        FreightLbl: Label ' Freight:';
        TransitCapLbl: Label ' Transit Insurance:';
        DeliveryCapLbl: Label ' Delivery:';
        PaymentCapLbl: Label ' Payment:';
        WarrantyCapLbl: Label ' Warranty:';
        ContactPersonCapLbl: Label ' Contact Person:';
        PhoneNoCapLbl: Label ' Phone No.:';
        UnitRateCapLbl: Label 'Unit Rate';
        RsCapLbl: Label '(Rs.)';
        RsCapLbl1: Label '(Rs.)';
        Indentor: Text[50];
        Units: Integer;
        GST: Code[50];
        CollectedCapLbl: Label 'Collected by RFC';
        OtherCharge: Label 'Freight, Insurance, Bank Charges, Local Transportation etc.,';

        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CessAmt: Decimal;
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        SGSTPer: Decimal;
        DescriptionVar: Text;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        GSTSetup: Record "GST Setup";
        TaxTransactionValue: Record "Tax Transaction Value";
        Payment: code[50];
        warranty: Code[50];
        DeliveryDays: Date;
        Vend: Record Vendor;
        GSTPerc: Decimal;
        Gstamt: array[10] of Decimal;
        ContactPerson: Text[100];
        PhoneNo: Text[30];
        Indentor1: Record "Indent Header";
        RateCaption: Code[50];
        SalesPersonPurch: Record "Salesperson/Purchaser";

        TransMethod: Code[50];

        SerialNo: Integer;

        VendorRec: Record Vendor;
        CurrencyRec: Record "Currency Exchange Rate";
        QuotCompDescription: Text;
        QuotCompHead: Record QuotCompHdr;


    procedure SETRFQ(RFQNoL: Code[20]);
    begin
        RFQNOG := RFQNoL;
    end;
}

