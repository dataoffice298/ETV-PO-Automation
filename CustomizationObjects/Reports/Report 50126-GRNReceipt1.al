report 50126 "GRN RECEIPT1"
{
    Caption = 'GRN RECEIPT1';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './GRNReceipt1.rdl';
    DefaultLayout = RDLC;


    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            column(DCNO; DCNO)//B2BPGON12OCT2022
            { }
            column(GrnNo; "No.")//B2BPGON12OCT2022
            { }
            column(GrnDate; "Document Date")//B2BPGON12OCT2022
            { }
            column(Order_No_; "Order No.")
            { }
            column(DCDate; DCDate)//B2BPGON12OCT2022
            { }
            column(VendorInvNo; VendorInvNo)
            { }
            column(VendorInvDate; VendorInvDate)
            { }
            column(Spot; "Location Code")//B2BPGON12OCT2022
            { }
            column(PONo; "Order No.")
            { }
            column(ReceiptDate; "Document Date")
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(CompanyInfoName; CompanyInfo.Name)
            { }
            column(CompanyInfoName2; CompanyInfo."Name 2")
            { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2")
            { }
            column(StoresReceiptCapLbl; StoresReceiptCapLbl)
            { }
            column(TechnicalStoresCapLbl; TechnicalStoresCapLbl)
            { }
            column(SupplierNameCapLbl; SupplierNameCapLbl)
            { }
            column(DCNoCapLbl; DCNoCapLbl)
            { }
            column(InvNoCapLbl; InvNoCapLbl)
            { }
            column(ReceiptDateCapLbl; ReceiptDateCapLbl)
            { }
            column(IndentNoCapLbl; IndentNoCapLbl)
            { }
            column(PONoCapLbl; PONoCapLbl)
            { }
            column(DCDateCapLbl; DCDateCapLbl)
            { }
            column(InvDateCapLbl; InvDateCapLbl)
            { }
            column(IndentDateCapLbl; IndentDateCapLbl)
            { }
            column(POReqNoCapLbl; POReqNoCapLbl)
            { }
            column(InwardNoCapLbl; InwardNoCapLbl)
            { }
            column(GrnNoCapLbl; GrnNoCapLbl)
            { }
            column(SpotCapLbl; SpotCapLbl)
            { }
            column(IndentorNameCapLbl; IndentorNameCapLbl)
            { }
            column(InwardDateCapLbl; InwardDateCapLbl)
            { }
            column(GRNDateCapLbl; GRNDateCapLbl)
            { }
            column(ReferenceNoCapLbl; ReferenceNoCapLbl)
            { }
            column(PurposeCapLbl; PurposeCapLbl)
            { }
            column(SNoCapLbl; SNoCapLbl)
            { }
            column(CategoryCapLbl; CategoryCapLbl)
            { }
            column(SubCategoryCapLbl; SubCategoryCapLbl)
            { }
            column(ItemNameCapLbl; ItemNameCapLbl)
            { }
            column(MakeCapLbl; MakeCapLbl)
            { }
            column(UOMCapLbl; UOMCapLbl)
            { }
            column(ChallanQtyCapLbl; ChallanQtyCapLbl)
            { }
            column(ReceivedQtyCapLbl; ReceivedQtyCapLbl)
            { }
            column(AcceptedQtyCapLbl; AcceptedQtyCapLbl)
            { }
            column(RejectedQtyCapLbl; RejectedQtyCapLbl)
            { }
            column(RateCapLbl; RateCapLbl)
            { }
            column(BasicAmtCapLbl; BasicAmtCapLbl)
            { }
            column(DiscountCapLbl; DiscountCapLbl)
            { }
            column(SGSTCapLbl; SGSTCapLbl)
            { }
            column(CGSTCapLbl; CGSTCapLbl)
            { }
            column(TotamtCapLbl; TotamtCapLbl)
            { }
            column(TotalAmountCapLbl; TotalAmountCapLbl)
            { }
            column(Discount2CapLbl; Discount2CapLbl)
            { }
            column(TaxCapLbl; TaxCapLbl)
            { }
            column(FrgtChargesCapLbl; FrgtChargesCapLbl)
            { }
            column(OtherchargesCapLbl; OtherchargesCapLbl)
            { }
            column(InsuranceCapLbl; InsuranceCapLbl)
            { }
            column(NetAmtCapLbl; NetAmtCapLbl)
            { }

            column(EnteredbyCapLbl; EnteredbyCapLbl)
            { }
            column(SectioninChargeCapLbl; SectioninChargeCapLbl)
            { }
            column(StoresinChargeCapLbl; StoresinChargeCapLbl)
            { }
            column(PurchDeptCapLbl; PurchDeptCapLbl)
            { }
            column(AccountsDeptCapLbl; AccountsDeptCapLbl)
            { }
            column(RamojiFCCapLbl; RamojiFCCapLbl)
            { }
            column(CGSTAmt; CGSTAmt)
            { }
            column(SGSTAmt; SGSTAmt)
            { }
            column(Purpose; Purpose)
            { }
            column(IndentDate; IndentDate)
            { }
            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLinkReference = "Purch. Rcpt. Header";
                DataItemLink = "Document No." = field("No.");
                column(Indent_No_; "Indent No.")
                { }
                column(POReqNo; "Indent Req No")
                { }
                // column(InwardNo; "Ref. Posted Gate Entry")
                // { }
                //B2BMMOn06Oct2022>>
                column(InwardNo; InwardNo)
                { }
                column(InwardDate; InwardDate)
                { }
                column(Indentor; Indentor)
                { }//B2BPGON12OCT2022
                column(Item_Category_Code; "Item Category Code")
                { }
                column(Description; Description)
                { }
                column(Unit_of_Measure; "Unit of Measure")
                { }
                column(Quantity; Quantity)
                { }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                { }
                column(BasicAmount; BasicAmount)
                { }
                column(NetTotal; NetTotal)
                { }
                column(NumberText1; NumberText[1])
                { }
                column(Rate; Rate)
                { }
                column(DiscAmount; DiscAmount)
                { }

                trigger OnAfterGetRecord()
                begin
                    Clear(NumberText);
                    CheckGRec.InitTextVariable;
                    CheckGRec.FormatNoText(NumberText, Round(NetTotal, 1, '='), "Currency Code");
                end;
            }
            trigger OnAfterGetRecord()
            begin
                PurchaseOrderGRec.Reset();
                PurchaseOrderGRec.SetRange("No.", "Order No.");
                if PurchaseOrderGRec.FindFirst() then begin
                    VendorInvNo := PurchaseOrderGRec."Vendor Invoice No.";
                    VendorInvDate := PurchaseOrderGRec."Vendor Invoice Date";
                    // Purpose := PurchaseOrderGRec.Purpose;
                    PurchaseRcptHdr.Reset();
                    PurchaseRcptHdr.SetRange("Order No.", PurchaseOrderGRec."No.");
                    If PurchaseRcptHdr.FindFirst() then
                        Purpose := PurchaseRcptHdr.Purpose;
                    /*  PurchaseLineGRec.Reset();
                      PurchaseLineGRec.SetRange("Document No.", PurchaseOrderGRec."No.");
                      if PurchaseLineGRec.FindSet() then begin
                          if (PurchaseLineGRec.Type = PurchaseLineGRec.Type::Item) or (PurchaseLineGRec.Type = PurchaseLineGRec.Type::"Fixed Asset") or (PurchaseLineGRec.Type = PurchaseLineGRec.Type::Description) then begin
                              IndentHeaderGRec.Reset();
                              IndentHeaderGRec.SetRange("No.", PurchaseLineGRec."Indent No.");
                              if IndentHeaderGRec.FindFirst() then begin
                                  IndentNo := IndentHeaderGRec."No.";
                                  IndentDate := IndentHeaderGRec."Document Date";
                                  Indentor := IndentHeaderGRec.Indentor;
                              end;
                          end;//B2BSCM25SEP2023
                          BasicAmount := PurchaseLineGRec."Quantity Received" * PurchaseLineGRec."Direct Unit Cost";
                          DiscAmount := PurchaseLineGRec."Line Discount Amount";
                      end;*/
                    PurchaseRcptLine.Reset();
                    PurchaseRcptLine.SetRange("Indent Req No", IndNo);
                    PurchaseRcptLine.SetRange("No.", "No.");
                    If PurchaseRcptLine.FindSet() then begin
                        if (PurchaseRcptLine.Type = PurchaseRcptLine.Type::Item) or (PurchaseRcptLine.Type = PurchaseRcptLine.Type::"Fixed Asset") or (PurchaseRcptLine.Type = PurchaseRcptLine.Type::Description) then begin
                            IndentHeaderGRec.Reset();
                            IndentHeaderGRec.SetRange("No.", PurchaseRcptLine."Indent No.");
                            if IndentHeaderGRec.FindFirst() then begin
                                IndentNo := IndentHeaderGRec."No.";
                                IndentDate := IndentHeaderGRec."Document Date";
                                Indentor := IndentHeaderGRec.Indentor;
                            end;
                        end;
                        BasicAmount := PurchaseLineGRec."Quantity Received" * PurchaseLineGRec."Direct Unit Cost";
                        DiscAmount := PurchaseLineGRec."Line Discount Amount";
                    end;

                    GateEntryhdrGRecB2B.Reset();
                    GateEntryhdrGRecB2B.SetRange("Purchase Order No.", "Order No.");
                    if GateEntryhdrGRecB2B.FindFirst() then begin
                        InwardNo := GateEntryhdrGRecB2B."No.";
                        InwardDate := GateEntryhdrGRecB2B."Document Date";
                        DCNO := GateEntryhdrGRecB2B."Challan No.";
                    end;
                    DCDate := GateEntryhdrGRecB2B."Challan Date";
                end;
                NetTotal := (BasicAmount + CGSTAmt + SGSTAmt);
            end;



            trigger OnPreDataItem();
            begin
                CompanyInfo.FIND('-');
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }
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


    local procedure GetPurchGSTAmount(PurchInvoiceHeader: Record "Purch. Inv. Header";
              PurchInvoiceLine: Record "Purch. Inv. Line");
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        //  Clear(IGSSTAmt);
        Clear(CGSTAmt);
        Clear(SGSTAmt);
        // Clear(CessAmt);
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", PurchInvoiceLine."Document No.");
        DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."Entry Type"::"Initial Entry");
        DetailedGSTLedgerEntry.SetRange("Document Line No.", PurchInvoiceLine."Line No.");
        if DetailedGSTLedgerEntry.FindSet() then begin
            // repeat
            if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) And (PurchInvoiceHeader."Currency Code" <> '') then
                CGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * PurchInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
            else
                if (DetailedGSTLedgerEntry."GST Component Code" = CGSTLbl) then
                    CGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");

            if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) And (PurchInvoiceHeader."Currency Code" <> '') then
                SGSTAmt += Round((Abs(DetailedGSTLedgerEntry."GST Amount") * PurchInvoiceHeader."Currency Factor"), GetGSTRoundingPrecision(DetailedGSTLedgerEntry."GST Component Code"))
            else
                if (DetailedGSTLedgerEntry."GST Component Code" = SGSTLbl) then
                    SGSTAmt += Abs(DetailedGSTLedgerEntry."GST Amount");


            // until DetailedGSTLedgerEntry.Next() = 0;
            //B2BMMOn07Oct2022<<

        end;
    end;


    var
        IndentNo: Code[30];
        InwardDate: Date;
        Indentor: Text[50];
        DCNO: Code[20];
        IndentDate: Date;
        DCDate: Date;
        VendorInvNo: Code[20];
        VendorInvDate: Date;
        IndentHeaderGRec: Record "Indent Header";
        GateEntLinGRecB2B: Record "Posted Gate Entry Line_B2B";
        GateEntryhdrGRecB2B: record "Posted Gate Entry Header_B2B";
        CompanyInfo: Record "Company Information";
        StoresReceiptCapLbl: Label 'STORES RECEIPT CUM INSPECTION REPORT';
        TechnicalStoresCapLbl: Label 'TECHNICAL STORES';
        SupplierNameCapLbl: Label 'SUPPLIER NAME:';
        DCNoCapLbl: Label 'DC.NO:';
        InvNoCapLbl: Label 'INV.NO:';
        ReceiptDateCapLbl: Label 'RECEIPT DATE.:';
        IndentNoCapLbl: Label 'INDENT NO.:';
        PONoCapLbl: Label 'PO NO.:';
        DCDateCapLbl: Label 'DC DATE:';
        InvDateCapLbl: Label 'INV.DATE:';
        IndentDateCapLbl: Label 'INDENT DATE.:';
        POReqNoCapLbl: Label 'PO REQ NO.:';
        InwardNoCapLbl: Label 'INWARD NO:';
        GrnNoCapLbl: Label 'GRN NO:';
        SpotCapLbl: Label 'SPOT:';
        IndentorNameCapLbl: Label 'INDENTOR NAME.:';
        InwardDateCapLbl: Label 'INWARD DATE:';
        GRNDateCapLbl: Label 'GRN DATE:';
        ReferenceNoCapLbl: Label 'REFERENCE NO.:';
        PurposeCapLbl: Label 'PURPOSE:';
        SNoCapLbl: Label 'SNO.';
        CategoryCapLbl: Label 'CATEGORY';
        SubCategoryCapLbl: Label 'SUB-CATEGORY';
        ItemNameCapLbl: Label 'ITEM NAME';
        MakeCapLbl: Label 'MAKE';
        UOMCapLbl: Label 'UOM';
        ChallanQtyCapLbl: Label 'CHALLAN QTY';
        ReceivedQtyCapLbl: Label 'RECEIVED QTY';
        AcceptedQtyCapLbl: Label 'ACCEPTED QTY';
        RejectedQtyCapLbl: Label 'REJECTED QTY';
        RateCapLbl: Label 'RATE';
        BasicAmtCapLbl: Label 'BASIC AMT';
        DiscountCapLbl: Label 'DISCOUNT';
        SGSTCapLbl: Label 'SGST';
        CGSTCapLbl: Label 'CGST';
        TotamtCapLbl: Label 'TOTAL AMT';
        TotalAmountCapLbl: Label 'TOTAL AMOUNT--';
        Discount2CapLbl: label 'Discount--';
        TaxCapLbl: Label 'Tax--';
        FrgtChargesCapLbl: Label 'Frgt charges--';
        OtherchargesCapLbl: Label 'Other charges--';
        InsuranceCapLbl: Label 'Insurance--';
        NetAmtCapLbl: Label 'NET AMOUNT-- ';

        EnteredbyCapLbl: Label 'ENTERED BY';
        SectioninChargeCapLbl: Label 'SECTION IN-CHARGE';
        StoresinChargeCapLbl: Label 'STORES IN-CHARGE';
        PurchDeptCapLbl: Label 'PURCHASE DEPT';
        AccountsDeptCapLbl: Label 'ACCOUNTS DEPT';
        RamojiFCCapLbl: Label 'RAMOJI FILM CITY - HYDERABAD';
        //B2BMMOn06Oct2022>>
        NumberText: array[2] of Text;
        CheckGRec: Codeunit "Gate Entry- Post Yes/No";
        ValueEntry: Record "Value Entry";
        Rate: Decimal;
        PurInvHdr1: Record "Purch. Inv. Header";
        PurchInvln1: Record "Purch. Inv. line";
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        DiscAmount: Decimal;
        Spot: Code[20];//B2BPGON12OCT2022
        GrnNo: Code[20];//B2BPGON12OCT2022
        GrnDate: Date;//B2BPGON12OCT2022
        NetTotal: Decimal;
        BasicAmount: Decimal;
        PurchaseOrderGRec: Record "Purchase Header";
        PurchaseLineGRec: Record "Purchase Line";
        SNo: Integer;
        Purpose: Text[100];
        InwardNo: Code[30];
        PurchaseRcptHdr: Record "Purch. Rcpt. Header";
        PurchaseRcptLine: Record "Purch. Rcpt. Line";
        IndNo: Code[20];
    //B2BMMOn06Oct2022<<
}