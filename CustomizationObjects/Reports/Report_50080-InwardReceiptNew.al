report 50300 "INWARD RECEIPT New"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'INWARD RECEIPT New';
    RDLCLayout = './InwardReceiptNew.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Posted Gate Entry Header_B2B"; "Posted Gate Entry Header_B2B")
        {

            column(No_; "No.")
            { }
            column(CompanyInfoName; CompanyInfo.Name)
            { }
            column(CompanyInfoAddress; CompanyInfo.Address)
            { }
            column(CompanyInfoAddress2; CompanyInfo."Address 2")
            { }
            column(StoresRecCumInspectionCapLbl; StoresRecCumInspectionCapLbl)
            { }
            Column(SupplierNameCapLbl; SupplierNameCapLbl)
            { }
            column(DCNoCapLbl; DCNoCapLbl)
            { }
            column(DCDateCapLbl; DCDateCapLbl)
            { }

            column(InvNoCapLbl; InvNoCapLbl)
            { }
            column(InvDateCapLbl; InvDateCapLbl)
            { }
            column(ReceiptDateCapLbl; ReceiptDateCapLbl)
            { }
            column(VehicleNoCapLbl; VehicleNoCapLbl)
            { }
            column(InwardNoCapLbl; InwardNoCapLbl)
            { }
            column(InwardDateCapLbl; InwardDateCapLbl)
            { }
            column(GrnNoCapLbl; GrnNoCapLbl)
            { }
            column(GRNDateCapLbl; GRNDateCapLbl)
            { }
            column(SpotCapLbl; SpotCapLbl)
            { }
            column(PurposeCapLbl; PurposeCapLbl)
            { }
            column(IndentorNameCapLbl; IndentorNameCapLbl)
            { }
            column(SNoCapLbl; SNoCapLbl)
            { }
            column(DescCapLbl; DescCapLbl)
            { }
            column(UOMCapLbl; UOMCapLbl)
            { }
            column(Sample1CapLbl; Sample1CapLbl)
            { }
            column(Sample2CapLbl; Sample2CapLbl)
            { }
            column(Sample3CapLbl; Sample3CapLbl)
            { }
            column(ChallanQtyCapLbl; ChallanQtyCapLbl)
            { }
            column(ReceivedQtyCapLbl; ReceivedQtyCapLbl)
            { }
            column(AcceptedCapLbl; AcceptedCapLbl)
            { }
            column(RejectedCapLbl; RejectedCapLbl)
            { }
            column(RateCapLbl; RateCapLbl)
            { }
            column(PONoCapLbl; PONoCapLbl)
            { }
            column(BasicAmtCapLbl; BasicAmtCapLbl)
            { }
            column(DiscountCapLbl; DiscountCapLbl)
            { }
            column(VatCapLbl; VatCapLbl)
            { }
            column(TotalAmtCapLbl; TotalAmtCapLbl)
            { }
            column(MakeCapLbl; MakeCapLbl)
            { }
            column(PackCapLbl; PackCapLbl)
            { }
            column(TotBasicValueCapLbl; TotBasicValueCapLbl)
            { }
            column(TotalCapLbl; TotalCapLbl)
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
            column(RupeesCapLbl; RupeesCapLbl)
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
            column(NetAmtCapLbl; NetAmtCapLbl)
            { }
            column(RamojiFCCapLbl; RamojiFCCapLbl)
            { }

            column(DCNO; "Challan No.")
            { }
            column(DCDate; "Challan Date")
            { }
            column(InwardNo; "Gate Entry No.")
            { }
            column(InwardDate; "Posting Date")
            { }
            column(GRNDate; GRNDate)
            { }
            column(GRNNo; GRNNo)
            {

            }
            column(SupplierName; SupplierName)
            { }
            Column(ReceiptDate; ReceiptDate)
            { }
            column(VendorInvNo; VendorInvNo)
            { }
            column(VendorInvDate; VendorInvDate)
            { }
            column(Spot; Spot)
            { }

            column(VehicleNo; "Vehicle No.")
            { }
            column(IndNo1; IndNo1)
            { }
            column(Indentor; Indentor)
            {

            }
            column(Purpose; Purpose)
            { }



            dataitem("Posted Gate Entry Line_B2B"; "Posted Gate Entry Line_B2B")
            {
                DataItemLink = "Gate Entry No." = field("No."), "Entry Type" = field("Entry Type");

                column(Document_No_; "Gate Entry No.")
                { }
                column(Line_No_; "Line No.")
                { }
                column(Qty; Quantity)
                {

                }

                column(SNo; SNo)
                { }
                column(UOM; "Unit of Measure")
                { }

                column(Make; Make)
                { }
                column(Vat; Vat)
                { }

                column(Totamt; Totamt)
                { }
                column(ChallanQty; Quantity)
                { }
                column(TotalAmount; TotalAmount)
                { }
                column(Rate; Rate)
                { }
                column(QtyReceived; QtyReceived)
                { }
                column(QtyRejected; QtyRejected)
                { }
                column(PONo; PONo)
                {

                }
                column(BasicAmt; BasicAmt)
                {

                }
                column(desc; Description)
                { }
                column(Discount; Discount)
                { }
                column(QtyAccepted; QtyAccepted)
                {

                }

                trigger OnPreDataItem();
                begin
                    CompanyInfo.FIND('-');
                    CompanyInfo.CALCFIELDS(Picture);
                end;

                trigger OnAfterGetRecord()
                begin
                    Clear(Qty);
                    Clear(QtyReceived);
                    Clear(QtyRejected);
                    Clear(QtyAccepted);
                    Clear(Discount);
                    Clear(TotalAmount);

                    PurchaseRcptLine.SetRange("Order No.", "Posted Gate Entry Line_B2B"."Purchase Order No.");
                    PurchaseRcptLine.SetRange("Order Line No.", "Posted Gate Entry Line_B2B"."Purchase Order Line No.");
                    IF PurchaseRcptLine.FindFirst() then begin
                        QtyAccepted := PurchaseRcptLine.Quantity;
                        Rate := PurchaseRcptLine."Unit Cost";
                        QtyReceived := PurchaseRcptLine.Quantity;
                        PONo := PurchaseRcptLine."Order No.";
                        BasicAmt := PurchaseRcptLine.Quantity * PurchaseRcptLine."Unit Cost";
                        desc := PurchaseRcptLine.Description;
                        Discount := (BasicAmt / 100) * PurchaseRcptLine."Line Discount %";
                        TotalAmount := BasicAmt - Discount;
                        /* if PurchaseRcptHdr.Get(PurchaseRcptLine."Document No.") then begin
                             IndNo2 := PurchaseRcptHdr."Order No.";
                             GRNNo := PurchaseRcptHdr."No.";
                             GRNDate := PurchaseRcptHdr."Document Date";
                             SupplierName := PurchaseRcptHdr."Buy-from Vendor Name";
                             ReceiptDate := PurchaseRcptHdr."Posting Date";
                             Spot := PurchaseRcptHdr."Location Code";
                             VehicleNo := PurchaseRcptHdr."Vehicle No.";
                             VendorInvNo := PurchaseRcptHdr."Vendor Invoice No.";
                             VendorInvDate := PurchaseRcptHdr."Vendor Invoice Date";
                         end;*/

                        PurchaseHdr.Reset();
                        PurchaseHdr.SetRange("No.", PurchaseRcptLine."Order No.");
                        if PurchaseHdr.FindFirst() then begin
                            PurchaseLineGRec.Reset();
                            PurchaseLineGRec.SetRange("Document No.", PurchaseHdr."No.");
                            if PurchaseLineGRec.FindSet() then begin
                                PurchaseLineGRec.calcsums("Quantity Rejected B2B");
                                QtyRejected := PurchaseLineGRec."Quantity Rejected B2B";
                            end;
                        end;


                    end;
                end;

            }

            trigger OnAfterGetRecord()
            begin
                PurchaseRcptHdr.Reset();
                PurchaseRcptHdr.SetRange("Order No.", "Posted Gate Entry Header_B2B"."Purchase Order No.");
                if PurchaseRcptHdr.FindFirst() then begin
                    IndNo2 := PurchaseRcptHdr."Order No.";
                    GRNNo := PurchaseRcptHdr."No.";
                    GRNDate := PurchaseRcptHdr."Document Date";
                    SupplierName := PurchaseRcptHdr."Buy-from Vendor Name";
                    ReceiptDate := PurchaseRcptHdr."Posting Date";
                    Spot := PurchaseRcptHdr."Location Code";
                    VehicleNo := PurchaseRcptHdr."Vehicle No.";
                    VendorInvNo := PurchaseRcptHdr."Vendor Invoice No.";
                    VendorInvDate := PurchaseRcptHdr."Vendor Invoice Date";
                    PurchaseRcptLine.Reset();
                    PurchaseRcptLine.setrange("Document No.", PurchaseRcptHdr."No.");
                    if PurchaseRcptLine.FindSet() then begin
                        repeat
                            IndentHdr.reset();
                            IndentHdr.SetRange("No.", PurchaseRcptLine."Indent No.");
                            if IndentHdr.FindFirst() then
                                Indentor := IndentHdr.Indentor;
                        until PurchaseRcptLine.next = 0;
                    end;


                end;


            end;






            trigger OnPreDataItem()
            var
            begin
                "Posted Gate Entry Header_B2B".SetRange("No.", No);

            end;





        }


    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Posted Gate Entry")
                {
                    field(No; No)
                    {
                        ApplicationArea = all;
                        TableRelation = "Posted Gate Entry Header_B2B"."No." where("Entry Type" = const(Inward));
                    }

                }
            }
        }

    }


    var
        No: Code[50];
        CompanyInfo: Record "Company Information";
        StoresRecCumInspectionCapLbl: Label 'STORES RECEIPT CUM INSPECTION REPORT';
        SupplierNameCapLbl: Label 'SUPPLIER NAME:';
        DCNoCapLbl: Label 'DC.NO:';
        DCDateCapLbl: Label 'DC DATE';
        InvNoCapLbl: Label 'INV.NO:';
        InvDateCapLbl: Label 'INV.DATE:';
        ReceiptDateCapLbl: Label 'RECEIPT DATE:';
        VehicleNoCapLbl: Label 'VEHICLE NO:';
        InwardNoCapLbl: Label 'INWARD NO:';
        InwardDateCapLbl: Label 'INWARD DATE:';
        GrnNoCapLbl: Label 'GRN No:';
        GRNDateCapLbl: Label 'GRN DATE:';
        SpotCapLbl: Label 'SPOT:';
        PurposeCapLbl: Label 'PURPOSE:';
        IndentorNameCapLbl: Label 'INDENTOR NAME:';
        SNoCapLbl: Label 'SNO.';
        DescCapLbl: Label 'DESCRIPTION';
        UOMCapLbl: Label 'UOM';
        Sample1CapLbl: Label '----';
        Sample2CapLbl: Label '----';
        Sample3CapLbl: Label '----';
        ChallanQtyCapLbl: Label 'Challan Qty';
        ReceivedQtyCapLbl: Label 'Received Qty';
        AcceptedCapLbl: Label 'Accepted';
        RejectedCapLbl: Label 'Rejected';
        RateCapLbl: Label 'Rate';
        PONoCapLbl: Label 'PO NO.';
        BasicAmtCapLbl: Label 'Basic Amt';
        DiscountCapLbl: Label 'Discount';
        VatCapLbl: Label 'Vat';
        TotalAmtCapLbl: Label 'Total Amt';
        TotBasicValueCapLbl: Label 'Total Basic Value';
        TotalCapLbl: Label 'TOTAL';
        TotalAmountCapLbl: Label 'TOTAL AMOUNT';
        Discount2CapLbl: label 'Discount--';
        TaxCapLbl: Label 'Tax--';
        FrgtChargesCapLbl: Label 'Frgt charges--';
        OtherchargesCapLbl: Label 'Other charges--';
        RupeesCapLbl: Label '';
        EnteredbyCapLbl: Label 'ENTERED BY';
        SectioninChargeCapLbl: Label 'SECTION IN-CHARGE';
        StoresinChargeCapLbl: Label 'STORES IN-CHARGE';
        PurchDeptCapLbl: Label 'PURCHASE DEPT';
        AccountsDeptCapLbl: Label 'ACCOUNTS DEPT';
        MakeCapLbl: Label 'MAKE';
        PackCapLbl: Label 'PACK';
        NetAmtCapLbl: Label 'NET AMOUNT';
        RamojiFCCapLbl: Label 'RAMOJI FILM CITY - HYDERBAD';
        PurchaseOrderGRec: Record "Purchase Header";
        PurchaseHdr: Record "Purchase Header";
        PurchaseLineGRec: Record "Purchase Line";
        PurchaseRcptHdr: Record "Purch. Rcpt. Header";

        PurchaseRcptLine: Record "Purch. Rcpt. Line";

        IndentHdr: Record "Indent Header";
        IndentLine: Record "Indent Line";
        GateEntLinGRecB2B: Record "Posted Gate Entry Line_B2B";
        GateEntryhdrGRecB2B: record "Posted Gate Entry Header_B2B";
        IndentReqHdr: Record "Indent Req Header";
        IndentReqLine: Record "Indent Requisitions";

        InwardDate: Date;
        InwardNo: Code[20];
        DCNO: Code[20];
        DCDate: Date;
        IndNo: Code[20];
        IndNo1: Code[20];
        IndNo2: Code[20];

        GRNNo: Code[20];
        GRNDate: Date;
        SupplierName: Code[40];
        ReceiptDate: Date;
        VehicleNo: Code[20];
        VendorInvNo: Code[35];
        VendorInvDate: date;
        Qty: Decimal;
        QtyReceived: Decimal;
        QtyAccepted: Decimal;
        QtyRejected: Decimal;
        Rate: Decimal;
        BasicAmt: Decimal;
        Discount: Decimal;
        SNo: Code[20];
        PONo: Code[20];
        Make: Code[50];
        Vat: Decimal;
        Totamt: decimal;
        desc: Text[100];
        UOM: Text[50];
        Spot: Code[20];
        Indentor: Code[30];
        Purpose: Text[100];
        NetTotal: Decimal;
        IteNo: Code[20];
        ChallanQtyvar: Decimal;
        TotalAmount: Decimal;
        Indent: Record "Indent Header";

}