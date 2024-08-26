report 50127 InwardReceipt1
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Inward Receipt1';
    RDLCLayout = './InwardReceipt1.rdl';
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
            
            dataitem("Indent Requisitions"; "Indent Requisitions")
            {
                DataItemLink = "Indent No." = field("No.");
                column(Indent_No_; "Indent No.")
                { }
                dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
                {
                    DataItemLink = "Indent Req No" = field("Document No.");
                    column(No_;"No.")
                    { }
                    column(Order_No_;"Order No.")
                    { }
                    column(Order_Date;"Order Date")
                    { }
                    column(Buy_from_Vendor_No_;"Buy-from Vendor No.")
                    { }
                    column(Location_Code;"Location Code")
                    { }
                    column(Purpose;Purpose)
                    { }
                    column(Indent_Req_No;"Indent Req No")
                    { }
                    column(Vendor_Invoice_No_;"Vendor Invoice No.")
                    { }
                    column(Vendor_Invoice_Date;"Vendor Invoice Date")
                    { }
                    column(Vehicle_No_;"Vehicle No.")
                    { }
                    column(Posting_Date;"Posting Date")
                    { }
                    dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        column(Document_No_; "Document No.")
                        { }
                        column(Line_No_;"Line No.")
                        { }
                        column(Quantity;Quantity)
                        { }
                        column(Unit_of_Measure;"Unit of Measure")
                        { }
                        column(Direct_Unit_Cost;"Direct Unit Cost")
                        { }
                        column(Unit_Cost;"Unit Cost")
                        { }
                        column(Description;Description)
                        { }
                        column(VAT__;"VAT %")
                        { }
                        column(Line_Discount__;"Line Discount %")
                        { }
                        column(Make_B2B;Make_B2B)
                        { }
                        
                    }
                }
            }
            trigger OnPreDataItem();
            begin
                CompanyInfo.FIND('-');
                CompanyInfo.CALCFIELDS(Picture);
            end;

        }

    }




    var
        myInt: Integer;
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
}