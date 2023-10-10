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
            RequestFilterFields = "No.";
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

            column(DCNO; DCNO)
            { }
            column(DCDate; DCDate)
            { }
            column(InwardNo; InwardNo)
            { }
            column(InwardDate; InwardDate)
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
            column(Spot; Spot)
            { }
            column(Indentor; Indentor)
            {

            }
            column(Purpose; Purpose)
            { }
            column(VehicleNo; VehicleNo)
            { }
            column(IndNo1; IndNo1)
            { }
            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                { }
                column(Line_No_; "Line No.")
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
                column(UOM; UOM)
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
                column(Totamt; Totamt)
                { }
                column(ChallanQty; ChallanQty)
                { }
                column(TotalAmount; TotalAmount)
                { }
                dataitem(Integer; Integer)
                {
                    DataItemTableView = sorting(Number);
                    column(GRNNo; PurchaseRcptLine."Document No.")
                    { }
                    trigger OnPreDataItem()
                    begin

                        PurchaseRcptLine.reset();
                        PurchaseRcptLine.SetRange("Indent No.", "Indent Line"."Document No.");
                        PurchaseRcptLine.SetRange("Indent Line No.", "Indent Line"."Line No.");
                        If PurchaseRcptLine.FindSet() then
                            repeat
                                PurchaseRcptLine.Mark(true);
                            until PurchaseRcptLine.next = 0;

                        if PurchaseRcptLine.markedonly(true) then begin
                            if PurchaseRcptLine.FindSet() then;
                            if PurchaseRcptLine.Count > 0 then
                                SetRange(number, 1, PurchaseRcptLine.count)
                            else
                                currreport.break;
                        end else
                            currreport.break;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if Number > 1 then
                            PurchaseRcptLine.Next;
                        Clear(Qty);
                        Clear(QtyReceived);
                        Clear(QtyRejected);
                        Clear(QtyAccepted);
                        IndNo1 := PurchaseRcptLine."Document No.";
                        Qty := PurchaseRcptLine.Quantity;
                        // QtyReceived := PurchaseLineGRec."Quantity Received";
                        // QtyRejected := PurchaseLineGRec."Quantity Rejected B2B";
                        // QtyAccepted := PurchaseLineGRec."Quantity Accepted B2B";
                        Rate := PurchaseRcptLine."Direct Unit Cost";
                        //BasicAmt := PurchaseRcptLine."Job Line Amount";
                        PONo := PurchaseRcptLine."Order No.";
                        Discount := PurchaseRcptLine."Line Discount %";
                        Make := PurchaseRcptLine.Make_B2B;
                        Vat := PurchaseRcptLine."VAT %";
                        desc := PurchaseRcptLine.Description;
                        UOM := PurchaseRcptLine."Unit of Measure";
                        // Totamt := PurchaseRcptLine.am

                        PurchaseRcptHdr.Reset();
                        PurchaseRcptHdr.Setrange("No.", PurchaseRcptLine."Document No.");
                        If PurchaseRcptHdr.FindFirst() then begin
                            PurchaseHdr.Reset();
                            PurchaseHdr.setrange("No.", PurchaseRcptHdr."Order No.");
                            if PurchaseHdr.FindFirst() then begin
                                PurchaseLineGRec.reset();
                                PurchaseLineGRec.SetRange("Document No.", PurchaseHdr."No.");
                                PurchaseLineGRec.SetRange("Line No.", PurchaseRcptLine."Line No.");
                                if PurchaseLineGRec.findset then begin
                                    QtyReceived := PurchaseLineGRec."Quantity Received";
                                    QtyRejected := PurchaseLineGRec."Quantity Rejected B2B";
                                    QtyAccepted := PurchaseLineGRec."Quantity Accepted B2B";
                                    Totamt := PurchaseLineGRec."Amount Including VAT";
                                    BasicAmt := PurchaseLineGRec."Line Amount";
                                end
                            end else begin
                                QtyReceived := PurchaseRcptLine.Quantity;
                                QtyAccepted := PurchaseRcptLine.Quantity;
                                BasicAmt := PurchaseRcptLine.Quantity * PurchaseRcptLine."Unit Cost";
                                TotalAmount := BasicAmt + Discount + Vat;

                            end;
                        end;

                    end;

                }

                trigger OnAfterGetRecord()
                begin
                    IndentReqLine.Reset();
                    IndentReqLine.setrange("Indent No.", "Indent Header"."No.");
                    If IndentReqLine.FindFirst() then begin
                        PurchaseRcptHdr.Reset();
                        PurchaseRcptHdr.SetRange("Indent Req No", IndentReqLine."Document No.");
                        if PurchaseRcptHdr.FindFirst() then begin
                            repeat
                                IndNo2 := PurchaseRcptHdr."Order No.";
                                GRNNo := PurchaseRcptHdr."No.";
                                GRNDate := PurchaseRcptHdr."Document Date";
                                SupplierName := PurchaseRcptHdr."Buy-from Vendor Name";
                                ReceiptDate := PurchaseRcptHdr."Posting Date";
                                Spot := PurchaseRcptHdr."Location Code";
                                VehicleNo := PurchaseRcptHdr."Vehicle No.";
                                VendorInvNo := PurchaseRcptHdr."Vendor Invoice No.";
                                VendorInvDate := PurchaseRcptHdr."Vendor Invoice Date";
                                GateEntryhdrGRecB2B.Reset();
                                GateEntryhdrGRecB2B.SetRange("Purchase Order No.", IndNo2);
                                if GateEntryhdrGRecB2B.FindFirst() then begin
                                    InwardNo := GateEntryhdrGRecB2B."Gate Entry No.";
                                    InwardDate := GateEntryhdrGRecB2B."Posting Date";
                                    DCNO := GateEntryhdrGRecB2B."Challan No.";
                                    DCDate := GateEntryhdrGRecB2B."Challan Date";
                                    ChallanQty := GateEntLinGRecB2B.Quantity;
                                end;
                            until PurchaseRcptHdr.Next() = 0;
                        end;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    CompanyInfo.FIND('-');
                    CompanyInfo.CALCFIELDS(Picture);
                end;

            }

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
        SupplierName: Code[20];
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
        Indentor: Code[20];
        Purpose: Text[100];
        NetTotal: Decimal;
        IteNo: Code[20];
        ChallanQty: Decimal;
        TotalAmount: Decimal;

}