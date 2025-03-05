report 50143 "Self Invoice"
{
    ApplicationArea = All;
    Caption = 'Self Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Self Invoice.rdl';
    dataset
    {
        dataitem(PurchInvHeader; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.";
            CalcFields = Amount;
            column(BuyfromVendorNo; "Buy-from Vendor No.")
            {
            }
            column(Posting_Date; "Posting Date") { }
            column(No; "No.")
            {
            }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {
            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_Address_3; "Buy-from Address 3") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
            column(Vendor_Invoice_No_; "Vendor Invoice No.") { }
            column(Location_GST_Reg__No_; "Location GST Reg. No.") { }
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(CompanyInfo_Add; CompanyInfo.Address) { }
            column(CompanyInfo_Add2; CompanyInfo."Address 2") { }
            column(CompanyInfo_City; CompanyInfo.City) { }
            column(CompanyInfo_Postcode; CompanyInfo."Post Code") { }
            column(RcmSelfInvoiceLbl000; RcmSelfInvoiceLbl000) { }
            column(DocumentNoLbl001; DocumentNoLbl001) { }
            column(DocumentDateLbl002; DocumentDateLbl002) { }
            column(InvoiceNoLbl003; InvoiceNoLbl003) { }
            column(InvoiceDateLbl004; InvoiceDateLbl004) { }
            column(RCM_StatusLbl009; RCM_StatusLbl009) { }
            column(GstNoLbl010; GstNoLbl010) { }
            column(SelfInvoiceNoLbl013; SelfInvoiceNoLbl013) { }
            column(Self_Invoice_No_; "Self Invoice No.") { }
            column(Vendor_Invoice_Date; "Vendor Invoice Date")
            { }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                {
                }
                column(Description; Description)
                {
                }
                column(HSN_SAC_Code; "HSN/SAC Code")
                {
                }
                column(Amount; Amount)
                {
                }
                column(GST_Credit; "GST Credit") { }
                column(Var_CGSTAmt; Var_CGSTAmt)
                {
                }
                column(Var_SGSTAmt; Var_SGSTAmt)
                {

                }
                column(Var_IGSTAmt; Var_IGSTAmt)
                {
                }
                column(Var_CGSTPer; Var_CGSTPer)
                {
                }
                column(Var_SGSTPer; Var_SGSTPer)
                {
                }
                column(Var_IGSTPer; Var_IGSTPer)
                {
                }
                column(CGST; CGST)
                { }
                column(SGST; SGST)
                { }
                column(IGST; IGST)
                { }
                column(Var_Amount; Var_Amount) { }
                column(CgstTXT; CgstTXT) { }
                column(SgstTxt; SgstTxt) { }
                column(IgstTxt; IgstTxt) { }
                column(SiNoLbl005; SiNoLbl005) { }
                column(Desc_ServiceLbl006; Desc_ServiceLbl006) { }
                column(HSNCodeLbl007; HSNCodeLbl007) { }
                column(TaxibleLbl008; TaxibleLbl008) { }
                column(TotalAmountLbl011; TotalAmountLbl011) { }
                column(AmtInWords; AmountW1)// AmtInWords[1] + ' ' + AmtInWords[2])
                {
                }
                column(RCM_StatusLbl012; RCM_StatusLbl012) { }
                trigger OnAfterGetRecord()
                begin
                    Clear(CGST);
                    Clear(SGST);
                    Clear(IGST);
                    DetailedGstLedgerEntries.Reset();
                    DetailedGstLedgerEntries.SetCurrentKey("Document No.", "Document Line No.");
                    DetailedGstLedgerEntries.SetRange("Document No.", "Purch. Inv. Line"."Document No.");
                    DetailedGstLedgerEntries.SetRange("Posting Date", "Posting Date");
                    DetailedGstLedgerEntries.SetRange("Reverse Charge", true);
                    // DetailedGstLedgerEntries.SetRange("No.", "Purch. Inv. Line"."No.");
                    DetailedGstLedgerEntries.SetRange("Document Line No.", "Purch. Inv. Line"."Line No.");
                    if DetailedGstLedgerEntries.FindSet() then
                        repeat
                            CASE DetailedGstLedgerEntries."GST Component Code" OF
                                'CGST':
                                    BEGIN
                                        Var_CGSTAmt += ABS(DetailedGstLedgerEntries."GST Amount");
                                        Var_AmountGST += ABS(DetailedGstLedgerEntries."GST Base Amount");
                                        Var_CGSTPer := DetailedGstLedgerEntries."GST %";// * 2;
                                        CGST := true;
                                    END;
                                'SGST':
                                    BEGIN
                                        Var_SGSTAmt += ABS(DetailedGstLedgerEntries."GST Amount");
                                        Var_SGSTPer := DetailedGstLedgerEntries."GST %";// * 2;
                                        Var_AmountGST += ABS(DetailedGstLedgerEntries."GST Base Amount");
                                        SGST := true;
                                    END;
                                'IGST':
                                    BEGIN
                                        Var_IGSTAmt += ABS(DetailedGstLedgerEntries."GST Amount");
                                        Var_AmountGST += ABS(DetailedGstLedgerEntries."GST Base Amount");
                                        Var_IGSTPer := DetailedGstLedgerEntries."GST %";
                                        IGST := true;
                                    END;
                            end;

                        until DetailedGstLedgerEntries.next = 0;
                    //Var_TotalGSTAmt := Var_CGSTAmt + Var_SGSTAmt + Var_IGSTAmt;
                    //Var_Amount += "Purch. Inv. Line".Amount; + Var_CGSTAmt + Var_SGSTAmt + Var_IGSTAmt;
                    Var_Amount := PurchInvHeader.Amount + Var_CGSTAmt + Var_SGSTAmt + Var_IGSTAmt;
                    GSTComponentLbl(Var_CGSTPer, Var_SGSTPer, Var_IGSTPer);
                    CheckCodeUnit.InitTextVariable;
                    CheckCodeUnit.FormatNoText(AmtInWords, Var_Amount, PurchInvHeader."Currency Code");
                    AmountW1 := AmtInWords[1] + AmtInWords[2];


                end;

            }
            trigger OnPreDataItem()
            var
                GSTLedgerEntry: Record "GST Ledger Entry";
            begin
                CompanyInfo.GET();
                CompanyInfo.CalcFields(Picture);
                GSTLedgerEntry.Reset();
                GSTLedgerEntry.SetRange("Document No.", PurchInvHeader."No.");
                GSTLedgerEntry.SetRange("Document Type", GSTLedgerEntry."Document Type"::Invoice);
                GSTLedgerEntry.SetRange("Reverse Charge", true);
                if not GSTLedgerEntry.FindFirst() then
                    CurrReport.Skip();
                Var_Amount := 0;
                Var_AmountGST := 0;
                Var_CGSTAmt := 0;
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
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        CompanyInfo: Record "Company Information";
        DetailedGstLedgerEntries: Record "Detailed GST Ledger Entry";
        CheckCodeUnit: Codeunit "Check Codeunit";
        AmtInWords: array[2] of text[250];
        AmountW1: Text[250];
        CgstTXT, SgstTxt, IgstTxt : Text;
        Var_TotalGSTAmt, Var_CGSTAmt, Var_SGSTAmt, Var_IGSTAmt, Var_Amount, Var_AmountGST : Decimal;
        Var_IGSTPer, Var_SGSTPer, Var_CGSTPer : Decimal;
        RcmSelfInvoiceLbl000: Label 'RCM-SELF INVOICE';
        DocumentNoLbl001: Label 'Document No.';
        DocumentDateLbl002: Label 'Document Date';
        InvoiceNoLbl003: Label ' vendor Invoice No';
        InvoiceDateLbl004: Label 'Vendor Invoice Date';
        SiNoLbl005: Label 'SI No.';
        Desc_ServiceLbl006: Label 'Desctiption/ Service';
        HSNCodeLbl007: Label 'HSN Code';
        TaxibleLbl008: Label 'TAXABLE';
        RCM_StatusLbl009: Label 'RCM Status';
        GstNoLbl010: Label 'GST No.';
        TotalAmountLbl011: Label 'Total Amount';
        SelfInvoiceNoLbl013: Label 'Self Invoice No.';
        RCM_StatusLbl012: Label 'RCM STATUS:';
        CGST: Boolean;
        SGST: Boolean;
        IGST: Boolean;

    local procedure GSTComponentLbl(CGST: Decimal; SGST: Decimal; IGST: Decimal)
    var
        TxtMsg000: Label 'CGST@ %1%';
        TxtMsg001: Label 'SGST@ %1%';
        TxtMsg002: Label 'IGST@ %1%';
    begin
        if CGST = 0 then
            CgstTXT := 'CGST'
        else
            CgstTXT := StrSubstNo(TxtMsg000, CGST);
        if SGST = 0 then
            SgstTxt := 'SGST'
        else
            SgstTxt := StrSubstNo(TxtMsg001, SGST);

        if IGST = 0 then
            IgstTxt := 'IGST'
        else
            IgstTxt := StrSubstNo(TxtMsg002, IGST)
    end;
}
