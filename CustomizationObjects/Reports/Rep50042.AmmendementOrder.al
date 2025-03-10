report 50042 "Ammendement Order"
{
    Caption = 'Ammendement Order';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './AmmendementOrder.rdl';


    dataset
    {
        dataitem("Purchase Header Archive"; "Purchase Header Archive")
        {
            RequestFilterFields = "No.";

            column(INR; INR)
            {

            }
            column(Version_No_; "Version No.")
            {

            }
            column(Date_Archived; "Date Archived")
            {

            }
            column(CurrencyCode; CurrencyCode)
            {

            }
            column(PaymentDescription; PaymentDescription)
            {

            }
            column(W; W)
            {

            }
            column(Currency_Code; "Currency Code")//B2BAJ01102024
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
            column(Buy_from_Post_Code; "Buy-from Post Code")
            { }
            column(Buy_from_Email; VendorGRec."E-Mail")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Dear_CaptionLbl; Dear_CaptionLbl)
            { }
            column(Quote_No_; "Purchase Quote No.")
            { }
            column(Subject; SubjectGVar)
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
            column(shipmethod; shipmethod)
            { }
            column(Ammendent_Comments; "Ammendent Comments")
            { }
            column(ContactName; ContactName)
            { }
            column(ContactEmail; ContactEmail)
            { }
            column(ContactPhNo; ContactPhNo)
            { }
            column(GSTRegNo; GSTRegNo)
            { }
            column(Purpose; PurchaseHeader.Purpose)
            { }
            column(EmailId; EmailId)
            { }
            column(PhoneNo; PhoneNo)
            { }
            column(PurchName; PurchName)
            { }
            column(AmendmentText; AmendmentText)
            { }


            dataitem("Purchase Line Archive"; "Purchase Line Archive")
            {
                DataItemLink = "Document No." = field("No."), "Version No." = field("Version No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(SpecID; SpecID)
                {

                }
                column(Description1; Description1)
                {

                }
                column(Variant_Description; "Variant Description")
                {

                }
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
                column(warranty1; warranty)
                { }


                /*  trigger OnPreDataItem()
                 begin
                     SetFilter("No.", '<>%1', '');
                 end;
                 */
                trigger OnAfterGetRecord()
                var


                begin
                    SNo += 1;
                    Clear(CGSTAmt);
                    Clear(SGSTAmt);
                    Clear(IGSSTAmt);
                    GetGSTAmounts("Purchase Line Archive");//Balu
                    Clear(GstTotal);
                    GstTotal := CGSTAmt + SGSTAmt + IGSSTAmt;
                    GstTotalSum := GstTotalSum + GstTotal;
                    Clear(AmountVendor1);
                    Clear(AmountText);
                    AmountVendor += "Line Amount";
                    AmountVendor1 := AmountVendor + GstTotalSum;

                    if "Purchase Header Archive"."Currency Code" = '' then begin
                        CheckRec.InitTextVariable;
                        CheckRec.FormatNoTextWithoutCurrency(AmountText, AmountVendor1, '');
                    end else begin
                        CheckRec.InitTextVariable();
                        CheckRec.FormatNoText(AmountText, AmountVendor1, "Currency Code");
                    end;

                    //B2BAJ18012024
                    if ("Purchase Line Archive".Type = "Purchase Line Archive".Type::Item)
                    or ("Purchase Line Archive".Type = "Purchase Line Archive".Type::"Fixed Asset")
                    or ("Purchase Line Archive".Type = "Purchase Line Archive".Type::"Charge (Item)") or
                    ("Purchase Line Archive".Type = "Purchase Line Archive".Type::"G/L Account") then begin
                        Description1 := "Purchase Line Archive".Description;
                        SpecID := "Purchase Line Archive"."Variant Description";

                    end
                    Else
                        if "Purchase Line Archive".Type = "Purchase Line Archive".Type::Description then begin
                            Description1 := "Purchase Line Archive"."Indentor Description";
                            SpecID := "Purchase Line Archive"."Spec Id";
                        End;

                end;

                trigger OnPostDataItem()
                begin

                    // TotalOrderAmount := TotalLineAmount + TotalGSTAmount;
                    // Clear(AmountText);
                    // GateEntryPostYesNo.InitTextVariable;
                    // GateEntryPostYesNo.FormatNoText(AmountText, Round(TotalOrderAmount, 1, '='), "Currency Code");
                end;
            }
            dataitem("PO Specifications"; "PO Terms And Conditions")
            {
                DataItemLink = DocumentNo = field("No.");
                DataItemTableView = where(Type = filter(Specifications));
                column(PO_LineType; LineType)
                { }
                column(PO_Description11; Description)
                {

                }
                column(PO_Line_Type; Line_Type)
                {

                }
                column(PO_LineNo; LineNo)
                { }
                column(S_No; SNo)
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
            dataitem("PO Terms And Conditions"; "PO Terms And Conditions")
            {
                DataItemLink = DocumentNo = field("No.");
                DataItemTableView = where(Type = filter("Terms & Conditions"));
                column(LineType; LineType)
                {
                }
                column(Description11; Description)
                {

                }
                column(Line_Type; Line_Type)
                {

                }
                column(LineNo; LineNo)
                { }
                column(SNo_; "SNo.") { }
                trigger OnAfterGetRecord()
                var
                    i: Integer;
                    MidString: array[100] of Text[1024];
                begin
                    Clear(i);
                    Clear(Line_Type);
                    Clear(ListTypeNew);
                    ListTypeNew := "PO Terms And Conditions".LineType;
                    WHILE STRLEN(ListTypeNew) > 0 DO BEGIN
                        i := i + 1;
                        MidString[i] := SplitStrings(ListTypeNew, ' ');
                        Line_Type := Line_Type + ' ' + UPPERCASE(COPYSTR(MidString[i], 1, 1)) + LOWERCASE(COPYSTR(MidString[i], 2));
                    END;
                end;
            }


            dataitem(GSTLoop; Integer)
            {
                DataItemTableView = sorting(Number);
                DataItemLinkReference = "Purchase Header Archive";

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
                    PurchLineGST.SetRange("Document No.", "Purchase Header Archive"."No.");
                    PurchLineGST.SetRange("Version No.", "Purchase Header Archive"."Version No.");
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
                        PurchLineArch.Reset();
                        PurchLineArch.SetCurrentKey("GST Group Code");
                        PurchLineArch.SetRange("Document No.", PurchLineGST."Document No.");
                        PurchLineArch.SetRange("Version No.", PurchLineGST."Version No.");
                        PurchLineArch.SetFilter("GST Group Code", PurchLineGST."GST Group Code");
                        if PurchLineArch.FindSet() then begin
                            GetGSTPercents(PurchLineArch);
                            if GSTPercent <> 0 then begin
                                I += 1;
                                GSTPerText := StrSubstNo(GSTText, GSTPercent);
                                repeat
                                    //Balu
                                    Clear(SGSTAmt);
                                    Clear(IGSSTAmt);
                                    Clear(CGSTAmt);//Balu
                                    GetGSTAmounts(PurchLineArch);
                                    GSTAmountLine[I] += SGSTAmt + IGSSTAmt + CGSTAmt;
                                    LineSNo := DelChr(Format(PurchLineArch."Line No."), '>', '0');
                                    GSTPerText += LineSNo + ' & ';
                                until PurchLineArch.Next() = 0;
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

                if PurchaseHdr.Get(PurchaseHdr."Document Type"::Quote, "Purchase Quote No.") then;

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

                PurchLineArch.Reset();
                PurchLineArch.SetRange("Document No.", "No.");
                PurchLineArch.SetRange("Version No.", "Version No.");
                PurchLineArch.SetFilter("No.", '<>%1', '');
                if PurchLineArch.FindFirst() then
                    if IndentHdr.Get(PurchLineArch."Indent No.") then;
                SubjectGVar := StrSubstNo(Subject1, "Purchase Quote No.", "Purchase Header Archive"."Document Date");
                SubjectGVar := SubjectGVar + StrSubstNo(Subject2, IndentHdr."No.", IndentHdr."Document Date");
                PurchLineArch.Reset();
                PurchLineArch.SetCurrentKey("GST Group Code");
                PurchLineArch.SetRange("Document No.", "No.");
                PurchLineArch.SetRange("Version No.", "Version No.");
                PurchLineArch.SetFilter("GST Group Code", '<>%1', '');
                if PurchLineArch.FindSet() then begin
                    GSTGroupCode := PurchLineArch."GST Group Code";
                    repeat
                        if GSTGroupCode <> PurchLineArch."GST Group Code" then
                            NextLoop := true;
                    until PurchLineArch.Next() = 0;
                end;
                if "Purchase Header Archive"."Payment Terms Code" <> ' ' then begin //B2BAJ18012024
                    PaymentTermsRec.Get("Purchase Header Archive"."Payment Terms Code");
                    PaymentDescription := PaymentTermsRec.Description;
                end;

                IF "Purchase Header Archive"."Currency Code" = '' then
                    CurrencyCode := 'INR'
                ELSE
                    CurrencyCode := "Purchase Header Archive"."Currency Code";

                Clear(PurchName);
                Clear(EmailId);
                Clear(PhoneNo);
                PurchaseCode.Reset();
                PurchaseCode.setrange(Code, "Purchase Header Archive"."Purchaser Code");
                if PurchaseCode.FindFirst() then begin
                    PurchName := PurchaseCode.Name;
                    EmailId := PurchaseCode."E-Mail";
                    PhoneNo := PurchaseCode."Phone No.";
                end;

                if "Purchase Header Archive"."Order Address Code" = '' then begin
                    OrderAddress.Reset();
                    OrderAddress.SetRange("Vendor No.", "Purchase Header Archive"."Buy-from Vendor No.");
                    if OrderAddress.FindSet() then begin
                        repeat
                            if OrderAddress.Name <> '' then
                                ContactName := ContactName + OrderAddress."Contact Name" + '/';
                            if OrderAddress."E-Mail" <> '' then
                                ContactEmail := ContactEmail + OrderAddress."E-Mail" + '/';
                            if OrderAddress."Phone No." <> '' then
                                ContactPhNo := ContactPhNo + OrderAddress."Phone No." + '/';
                        until OrderAddress.Next = 0;
                        ContactName := DelChr(ContactName, '<>', '/');
                        ContactEmail := DelChr(ContactEmail, '<>', '/');
                        ContactPhNo := DelChr(ContactPhNo, '<>', '/');
                    end;
                    if VendorRec.Get("Purchase Header Archive"."Buy-from Vendor No.") then
                        GSTRegNo := VendorRec."GST Registration No.";
                end else begin
                    if OrderAddress.Get("Purchase Header Archive"."Buy-from Vendor No.", "Purchase Header Archive"."Order Address Code") then begin
                        GSTRegNo := OrderAddress."GST Registration No.";
                        ContactName := OrderAddress."Contact Name";
                        ContactPhNo := OrderAddress."Phone No.";
                        ContactEmail := OrderAddress."E-Mail";
                    end;
                end;

                if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, "Purchase Header Archive"."No.") then;
                if "Purchase Header Archive".Regularization then begin
                    if "Purchase Header Archive".Amendment then
                        AmendmentText := 'Amendment Cum Regularization  Order'
                    else
                        AmendmentText := 'Regularization Order';
                end else begin
                    if "Purchase Header Archive".Amendment then
                        AmendmentText := 'Amendment Order'
                    else
                        AmendmentText := 'Purchase Order';
                end;
            END;

        }

    }

    var
        INR: Label 'INR';
        Currency: Record Currency;
        CurrencyCode: Code[10];
        SpecID: Text[250];
        Description1: Text[100];
        PaymentDescription: Text[100];
        PaymentTermsRec: Record "Payment Terms";
        W: Label 'Warranty';
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
        PurchaseHdr: Record "Purchase Header Archive";
        PurchLineArch: Record "Purchase Line Archive";
        PurchLineGST: Record "Purchase Line Archive";
        IndentHdr: Record "Indent Header";
        Dear_CaptionLbl: Label 'Dear Sir,';
        AmountVendor: Decimal;
        SubjectGVar: Text;
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
        GSTText: Label 'GST @%1% on Line.No. ';
        GSTPerText: Text;
        LineSNo, Line_Type, ListTypeNew : Text;
        AmountText: array[2] of Text;
        // GateEntryPostYesNo: Codeunit "Global Functions B2B";
        AckLbl: Label 'Please acknowledge the receipt of the order and arrange the material at the earliest.';
        ThankYouLbl: Label 'Thanking you,';
        ETVLbl: Label 'For EENADU TELEVISION PVT. LIMITED';
        GSTAmountLine: array[10] of Decimal;
        I: Integer;
        PONumber: Code[50];//B2BSSD28MAR2023
        PurchaseHeader: Record "Purchase Header";
        OrderAddress: Record "Order Address";
        ContactName: Text;
        ContactEmail: Text;
        ContactPhNo: Text;
        GSTRegNo: Code[20];
        VendorRec: Record Vendor;
        PurchaseCode: Record "Salesperson/Purchaser";
        PurchName: Text;
        EmailId: Text;
        PhoneNo: Text;
        AmendmentText: Text;

    //GST Starts>>
    local procedure GetGSTAmounts(PurchaseLineArch: Record "Purchase Line Archive")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        ComponentName := GetComponentName("Purchase Line Archive", GSTSetup);

        if (PurchaseLineArch.Type <> PurchaseLineArch.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLineArch.RecordId);
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

    local procedure GetComponentName(PurchaseLineArch: Record "Purchase Line Archive";
        GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLineArch."GST Jurisdiction Type" = PurchaseLineArch."GST Jurisdiction Type"::Interstate then
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

    local procedure GetGSTPercents(PurchaseLineArch: Record "Purchase Line Archive")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        ComponentName := GetComponentName("Purchase Line Archive", GSTSetup);

        if (PurchaseLineArch.Type <> PurchaseLineArch.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLineArch.RecordId);
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
    procedure SplitStrings(VAR String: Text[1024]; Separator: Text[1]) SplitedString: Text[1024]
    var
        Pos: Integer;
    begin
        Clear(Pos);
        Pos := STRPOS(String, Separator);
        if Pos > 0 then begin //Whether there is a separator
            SplitedString := COPYSTR(String, 1, Pos - 1);//Copy the string before the separator
            if Pos + 1 <= STRLEN(String) then //Is it all
                String := COPYSTR(String, Pos + 1)//Copy the string after the separator
            else
                Clear(String);
        end else begin
            SplitedString := String;
            Clear(String);
        end;
    end;


}
