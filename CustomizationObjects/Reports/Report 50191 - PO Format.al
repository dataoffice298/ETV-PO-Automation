report 50191 "PO FORMAT"
{
    Caption = 'PO Format';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './PoFormat.rdl';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(W; W)
            {

            }
            column(No_; "No.")
            { }
            column(Picture_CompanyInfo; CompanyInfo.Picture)
            { }
            column(Name_CompanyInfo; CompanyInfo.Name)
            { }
            column(GSTNo_CompanyInfo; CompanyInfo."GST Registration No.")
            { }
            column(StateName_CompanyInfo; StateGRec.Description)
            { }
            column(StateCodeGST_CompanyInfo; StateGRec."State Code (GST Reg. No.)")
            { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(Buy_from_Address; "Buy-from Address")
            { }
            column(Buy_from_Address_2; "Buy-from Address 2")
            { }
            column(Buy_from_City; "Buy-from City")
            { }
            column(Buy_from_Contact_No_; "Buy-from Contact No.")
            { }
            column(Buy_from_Email; VendorGRec."E-Mail")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Dear_CaptionLbl; Dear_CaptionLbl)
            { }
            column(Quote_No_; "Quote No.")
            { }
            column(Subject; Subject)
            { }
            column(AmountText; AmountText[1] + ' ' + AmountText[2])
            { }
            //balu
            column(AmountVendor1; AmountVendor1)
            {

            }
            //Balu
            column(TotalOrderAmount; TotalOrderAmount)
            { }
            column(AckLbl; AckLbl)
            { }
            column(ThankYouLbl; ThankYouLbl)
            { }
            column(ETVLbl; ETVLbl)
            { }
            //B2BSSD24APR2023>>
            column(Transaction_Specification; "Transaction Specification")
            { }
            column(Transaction_Type; "Transaction Type")
            { }
            column(Shipment_Method_Code; "Shipment Method Code")
            { }
            column(Transport_Method; "Transport Method")
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(TransportMethodDes; TransportMethodDes)//B2BSSD25APR2023
            { }
            column(TransactionTypeDES; TransactionTypeDES)//B2BSSD25APR2023
            { }
            column(PaymentTermsText; PaymentTermsText)//B2BSSD25APR2023
            { }
            column(transactionspecificTxt; transactionspecificTxt)//B2BSSD25APR2023
            { }
            column(shipmethod; shipmethod)//B2BSSD25APR2023
            { }
            //B2BSSD24APR2023<<

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(Document_No_; "Document No.")
                { }
                column(Line_No_; "Line No.")
                { }
                column(SNo; SNo)
                { }
                column(No_PurchLine; "No.")
                { }
                column(Description; Description)
                { }
                column(HSN_SAC_Code; "HSN/SAC Code")
                { }
                column(Quantity; Quantity)
                { }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                { }
                column(Unit_Cost; "Unit Cost")
                { }
                column(Line_Amount; "Line Amount")
                { }
                column(CGSTAmt; CGSTAmt)
                { }
                column(SGSTAmt; SGSTAmt)
                { }
                column(IGSSTAmt; IGSSTAmt)
                { }
                column(TotalGSTAmount; TotalGSTAmount)
                { }
                column(TotalLineAmount; TotalLineAmount)
                { }
                column(warranty1; warranty)//B2BSSD24APR2023
                { }


                trigger OnPreDataItem()
                begin
                    SetFilter("No.", '<>%1', '');
                end;

                trigger OnAfterGetRecord()
                var


                begin
                    SNo += 1;
                    Clear(CGSTAmt);
                    Clear(SGSTAmt);
                    Clear(IGSSTAmt);


                    // TotalLineAmount += "Purchase Line"."Line Amount";

                    // GetGSTAmounts("Purchase Line");
                    // TotalGSTAmount += CGSTAmt + SGSTAmt + IGSSTAmt;
                    GetGSTAmounts("Purchase Line");//Balu
                    Clear(GstTotal);
                    GstTotal := CGSTAmt + SGSTAmt + IGSSTAmt;
                    GstTotalSum := GstTotalSum + GstTotal;
                    //GSTPerQTY := GstTotal / Quantity;
                    //GSTPertotal := CGSTPer + SGSTPer + IGSTPer;
                    //Message('%1', GstTotal);
                    Clear(AmountVendor1);
                    Clear(AmountText);
                    AmountVendor += "Line Amount";
                    AmountVendor1 := AmountVendor + GstTotalSum;
                    //   GateEntryPostYesNo.InitTextVariable;
                    //  GateEntryPostYesNo.FormatNoTextInvoice(AmountText, Round(AmountVendor1, 1, '='), "Currency Code");
                    // GateEntryPostYesNo.FormatNoText(AmountText, AmountVendor1, "Currency Code");
                    CheckRec.InitTextVariable;

                    CheckRec.FormatNoText(AmountText, AmountVendor1, "Currency Code");


                end;

                trigger OnPostDataItem()
                begin

                    // TotalOrderAmount := TotalLineAmount + TotalGSTAmount;
                    // Clear(AmountText);
                    // GateEntryPostYesNo.InitTextVariable;
                    // GateEntryPostYesNo.FormatNoText(AmountText, Round(TotalOrderAmount, 1, '='), "Currency Code");
                end;
            }
            dataitem("PO Terms And Conditions"; "PO Terms And Conditions") //B2BAJ02012024
            {
                DataItemLink = DocumentNo = field("No.");
                column(LineType; LineType)
                {
                }
                column(Description11; Description)
                {

                }
            }

            dataitem(GSTLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                DataItemLinkReference = "Purchase Header";

                column(Number_GSTLoop; Number)
                { }
                column(GSTGroupCode_PurchLineGST; PurchLineGST."GST Group Code")
                { }
                column(GSTPerText; GSTPerText)
                { }
                column(GSTAmountLine; GSTAmountLine[I])
                { }

                trigger OnPreDataItem()
                begin
                    Clear(GSTGroupCode);
                    I := 1;
                    PurchLineGST.Reset();
                    PurchLineGST.SetCurrentKey("Line No.", "GST Group Code");
                    PurchLineGST.SetRange("Document No.", "Purchase Header"."No.");
                    PurchLineGST.SetFilter("GST Group Code", '<>%1', '');
                    PurchLineGST.SetFilter("No.", '<>%1', '');
                    if PurchLineGST.FindSet() then;

                    SetRange(Number, 1, PurchLineGST.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    Clear(GSTPerText);
                    Clear(GSTPercent);
                    if GSTGroupCode <> PurchLineGST."GST Group Code" then begin
                        GSTGroupCode := PurchLineGST."GST Group Code";
                        PurchLine.Reset();
                        PurchLine.SetCurrentKey("GST Group Code");
                        PurchLine.SetRange("Document No.", PurchLineGST."Document No.");
                        PurchLine.SetFilter("GST Group Code", PurchLineGST."GST Group Code");
                        if PurchLine.FindSet() then begin
                            GetGSTPercents(PurchLine);
                            if GSTPercent <> 0 then begin
                                I += 1;
                                GSTPerText := StrSubstNo(GSTText, GSTPercent);
                                repeat
                                    //Balu
                                    Clear(SGSTAmt);
                                    Clear(IGSSTAmt);
                                    Clear(CGSTAmt);//Balu
                                    GetGSTAmounts(PurchLine);
                                    GSTAmountLine[I] += SGSTAmt + IGSSTAmt + CGSTAmt;
                                    LineSNo := DelChr(Format(PurchLine."Line No."), '>', '0');
                                    GSTPerText += LineSNo + ' & ';
                                until PurchLine.Next() = 0;
                                GSTPerText := DelChr(GSTPerText, '>', ' &');
                            end;
                        end;
                    end;
                    //    AmountVendor += "Line Amount";
                    //  AmountVendor1 := AmountVendor + GstTotalSum;

                    if PurchLineGST.Next() = 0 then;
                    //CurrReport.Break();//Balu
                end;
            }

            trigger OnAfterGetRecord()
            var

            begin
                Clear(SNo);
                Clear(TotalGSTAmount);
                Clear(TotalLineAmount);
                NextLoop := false;
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);

                if StateGRec.Get(CompanyInfo."State Code") then;

                if VendorGRec.Get("Buy-from Vendor No.") then;

                if PurchaseHdr.Get(PurchaseHdr."Document Type"::Quote, "Quote No.") then;

                //B2BSSD25APR2023>>
                if TransportMethod.Get("Transport Method") then
                    TransportMethodDes := TransportMethod.Description;
                if TransactionTypeRec.Get("Transaction Type") then
                    TransactionTypeDES := TransactionTypeRec.Description;
                if Shipments.get("Shipment Method Code") then
                    shipmethod := Shipments.Description;
                if Shipments.get("Payment Terms Code") then
                    shipmethod := Shipments.Description;
                if Transactionspecifcation.get("Transaction Specification") then
                    transactionspecificTxt := Transactionspecifcation.Text;
                //B2bssd25apr2023<<

                PurchLine.Reset();
                PurchLine.SetRange("Document No.", "No.");
                PurchLine.SetFilter("No.", '<>%1', '');
                if PurchLine.FindFirst() then
                    if IndentHdr.Get(PurchLine."Indent No.") then;
                Subject := StrSubstNo(Subject1, "Quote No.", "Purchase Header"."Document Date");
                Subject := Subject + StrSubstNo(Subject2, IndentHdr."No.", IndentHdr."Document Date");
                PurchLine.Reset();
                PurchLine.SetCurrentKey("GST Group Code");
                PurchLine.SetRange("Document No.", "No.");
                PurchLine.SetFilter("GST Group Code", '<>%1', '');
                if PurchLine.FindSet() then begin
                    GSTGroupCode := PurchLine."GST Group Code";
                    repeat
                        if GSTGroupCode <> PurchLine."GST Group Code" then
                            NextLoop := true;
                    until PurchLine.Next() = 0;
                end;
            end;
        }

    }

    var
        W: Label 'Warranty :';
        CheckRec: Codeunit "Check Codeunit";
        transactionspecificTxt: Text[100];
        Transactionspecifcation: Record "Transaction Specification";
        PaymentTerms: Record "Payment Terms";
        PaymentTermsText: Text[100];
        Shipments: Record "Shipment Method";
        shipmethod: Text[50];
        TransactionTypeDES: Text[50];
        TransportMethodDes: Text[100];
        TransportMethod: Record "Transport Method";
        TransactionTypeRec: Record "Transaction Type";

        CompanyInfo: Record "Company Information";
        StateGRec: Record State;
        VendorGRec: Record Vendor;
        GstTotal: Decimal;
        PurchaseHdr: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLineGST: Record "Purchase Line";
        IndentHdr: Record "Indent Header";
        Dear_CaptionLbl: Label 'Dear Sir,';
        AmountVendor: Decimal;
        Subject: Text;
        Subject1: Label 'With reference to your Quotation No. %1/dt. %2 and subsequent discussion we had with you, ';
        Subject2: Label 'We would like to place order on you for the following lines against the Indent No. %1/dt. %2';
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        AmountVendor1: Decimal;
        CGSTLbl: Label 'CGST';
        GSTLbl: Label 'GST';
        GstTotalSum: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSSTAmt: Decimal;
        SNo: Integer;
        TotalLineAmount: Decimal;
        TotalGSTAmount: Decimal;
        TotalOrderAmount: Decimal;
        GSTPercent: Decimal;
        GSTGroupCode: Code[50];//B2BSSD28MAR2023 (Length Incre)
        NextLoop: Boolean;
        GSTText: Label 'GST @%1% on S.No. ';
        GSTPerText: Text;
        LineSNo: Text;
        AmountText: array[2] of Text;
        // GateEntryPostYesNo: Codeunit "Global Functions B2B";
        AckLbl: Label 'Please acknowledge the receipt of the order and arrange the material at the earliest.';
        ThankYouLbl: Label 'Thanking you,';
        ETVLbl: Label 'For EENADU TELEVISION PVT. LIMITED';
        GSTAmountLine: array[10] of Decimal;
        I: Integer;
        PONumber: Code[50];//B2BSSD28MAR2023
        PurchaseHeader: Record "Purchase Header";

    //GST Starts>>
    local procedure GetGSTAmounts(PurchaseLine: Record "Purchase Line")
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
                    case TaxTransactionValue."Value ID" of
                        6:
                            SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                        2:
                            CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                        3:
                            IGSSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                    end;
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
    //GST Ends<<

}