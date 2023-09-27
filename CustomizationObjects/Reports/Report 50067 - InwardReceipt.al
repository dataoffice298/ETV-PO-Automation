report 50067 "INWARD RECEIPT"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'INWARD RECEIPT';
    RDLCLayout = './InwardReceipt.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
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

            column(DCNO; DCNO)
            { }
            column(DCDate; DCDate)
            { }
            column(InwardNo; InwardNo)
            { }
            column(InwardDate; InwardDate)
            { }
            column(GRNNo; GRNNo)
            { }
            column(GRNDate; GRNDate)
            { }
            column(SupplierName; SupplierName)
            { }
            Column(ReceiptDate; ReceiptDate)
            { }
            column(VendorInvNo; VendorInvNo)
            { }
            column(VendorInvDate; VendorInvDate)
            { }
            column(Qty; Qty)
            { }
            column(QtyAccepted; QtyAccepted)
            { }
            column(QtyReceived; QtyReceived)
            { }
            column(QtyRejected; QtyRejected)
            { }
            column(SNo; SNo)
            { }
            column(Rate; Rate)
            { }
            column(PONo; PONo)
            { }
            column(BasicAmt; BasicAmt)
            { }
            column(Discount; Discount)
            { }
            column(Make; Make)
            { }
            column(Vat; Vat)
            { }
            column(desc; desc)
            { }
            column(UOM; UOM)
            { }
            column(Totamt; Totamt)
            { }
            column(Spot; Spot)
            { }
            column(Indentor; Indentor)
            { }
            column(Purpose; Purpose)
            { }
            column(VehicleNo; VehicleNo)
            { }



            trigger OnPreDataItem();
            begin

                CompanyInfo.FIND('-');
                CompanyInfo.CALCFIELDS(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                IndentReqLine.reset;
                IndentReqLine.setrange("Indent No.", "No.");
                If IndentReqLine.FindFirst() then begin
                    IndNo := IndentReqLine."Document No.";

                    PurchaseLineGRec.Reset();
                    PurchaseLineGRec.SetRange("Indent Req No", IndNo);
                    If PurchaseLineGRec.FindFirst() then
                        IndNo1 := PurchaseLineGRec."Document No.";
                    Qty := PurchaseLineGRec.Quantity;
                    QtyReceived := PurchaseLineGRec."Quantity Received";
                    QtyAccepted := PurchaseLineGRec."Quantity Rejected B2B";
                    QtyAccepted := PurchaseLineGRec."Quantity Accepted B2B";
                    Rate := PurchaseLineGRec."Direct Unit Cost";
                    BasicAmt := PurchaseLineGRec."Line Amount";
                    PONo := PurchaseLineGRec."Document No.";
                    Discount := PurchaseLineGRec."Line Discount %";
                    Make := PurchaseLineGRec.Make_B2B;
                    Vat := PurchaseLineGRec."VAT %";
                    desc := PurchaseLineGRec.Description;
                    UOM := PurchaseLineGRec."Unit of Measure";
                    Totamt := PurchaseLineGRec."Amount Including VAT";
                    // NetTotal += PurchaseLineGRec."Line Amount";

                    PurchaseHdr.reset();
                    PurchaseHdr.SetRange("No.", IndNo1);
                    If PurchaseHdr.FindFirst() then begin
                        VendorInvNo := PurchaseHdr."Vendor Invoice No.";
                        VendorInvDate := PurchaseHdr."Vendor Invoice Date";
                        Spot := PurchaseHdr."Location Code";
                        Indentor := PurchaseHdr.Indenter;
                        Purpose := PurchaseHdr.Purpose;
                        VehicleNo := PurchaseHdr."Vehicle No.";
                    end;

                    PurchaseRcptHdr.Reset();
                    PurchaseRcptHdr.SetRange("Order No.", IndNo1);
                    If PurchaseRcptHdr.findfirst then
                        GRNNo := PurchaseRcptHdr."No.";
                    GRNDate := PurchaseRcptHdr."Document Date";
                    SupplierName := PurchaseRcptHdr."Buy-from Vendor No.";
                    ReceiptDate := PurchaseRcptHdr."Posting Date";

                    GateEntryhdrGRecB2B.Reset();
                    GateEntryhdrGRecB2B.SetRange("Purchase Order No.", IndNo1);
                    if GateEntryhdrGRecB2B.FindFirst() then begin
                        InwardNo := GateEntryhdrGRecB2B."Gate Entry No.";
                        InwardDate := GateEntryhdrGRecB2B."Posting Date";
                        DCNO := GateEntryhdrGRecB2B."Challan No.";
                        DCDate := GateEntryhdrGRecB2B."Challan Date";


                    end;
                end;

            end;

        }
    }

    requestpage
    {
        layout
        {

        }

        actions
        {

        }
    }

    /*   rendering
       {
           layout(LayoutName)
           {
               Type = RDLC;
               LayoutFile = 'mylayout.rdl';
           }
       }*/

    var
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
        GrnNoCapLbl: Label 'GRN NO:';
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
        TotalAmountCapLbl: Label 'TOTAL AMOUNT--';
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
        NetAmtCapLbl: Label 'NET AMOUNT --';
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
        InwardNo: Code[30];
        DCNO: Code[20];
        DCDate: Date;
        IndNo: Code[20];
        IndNo1: Code[20];

        GRNNo: Code[20];
        GRNDate: Date;
        SupplierName: Text[50];
        ReceiptDate: Date;
        VehicleNo: Code[20];
        VendorInvNo: Code[20];
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
        Make: Code[20];
        Vat: Decimal;
        Totamt: decimal;
        desc: Text[100];
        UOM: Code[20];
        Spot: Code[20];
        Indentor: Code[20];
        Purpose: Text[100];
        NetTotal: Decimal;


}