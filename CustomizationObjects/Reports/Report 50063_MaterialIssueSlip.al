report 50063 "Material Issue Slip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Material Issue Slip_50063';
    RDLCLayout = './MaterialIssueSlip.rdl';
    DefaultLayout = RDLC;


    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            RequestFilterFields = "No.";
            column(Indentor1; Indentor)
            { }
            column(IndentNo1; "No.")
            { }

            column(IndentDate; "Document Date")
            { }
            column(CompanyInfoName; Companyinfo.Name)
            { }
            column(CompanyInfoAddress; CompanyInfo.Address)
            { }
            column(CompanyInfoAdress2; CompanyInfo."Address 2")
            { }
            column(TechnicalStoresCapLbl; TechnicalStoresCapLbl)
            { }
            column(MatIssueSlipCapLbl; MatIssueSlipCapLbl)
            { }
            column(IndentorCapLbl; IndentorCapLbl)
            { }
            column(DeptCapLbl; DeptCapLbl)
            { }
            column(LocationCapLbl; LocationCapLbl)
            { }
            column(ProgNamCapLbl; ProgNamCapLbl)
            { }
            column(IndentNoCapLbl; IndentNoCapLbl)
            { }
            column(IndentDateCapLbl; IndentDateCapLbl)
            { }
            column(ChannelCapLbl; ChannelCapLbl)
            { }
            column(IssNoCapLbl; IssNoCapLbl)
            { }
            column(IssDateCapLbl; IssDateCapLbl)
            { }
            column(SNoCapLbl; SNoCapLbl)
            { }
            column(DescofMatCapLbl; DescofMatCapLbl)
            { }
            column(CatNameCapLbl; CatNameCapLbl)
            { }
            column(MakeCapLbl; MakeCapLbl)
            { }

            /* column(PackCapLbl; PackCapLbl)
             {

              }*/
            column(UOMCapLbl; UOMCapLbl)
            { }
            column(ReqQtyCapLbl; ReqQtyCapLbl)
            { }
            column(IssQtyCapLbl; IssQtyCapLbl)
            { }
            column(PurposeCapLbl; PurposeCapLbl)
            { }
            column(StoresAssCapLbl; StoresAssCapLbl)
            { }
            column(ReceiversSigCapLbl; ReceiversSigCapLbl)
            { }
            column(RamojiFCCapLbl; RamojiFCCapLbl)
            { }
            column(Indentor; Indentor)
            { }
            column(Department; Department)
            { }
            column(No_; "No.")
            { }
            column(Document_Date; "Document Date")
            { }
            column(Delivery_Location; "Delivery Location")
            { }
            column(programme_Name; "programme Name")//B2BSSD28MAR2023
            { }
            column(Purpose; Purpose)//B2BSSD28MAR2023
            { }
            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Qty Issued" = filter(<> 0)); // B2BSCM27SEP2023
                column(Variant_Code; "Variant Code")
                { }

                column(Req_Quantity; "Req.Quantity")
                { }

                column(Qty_Issued; "Qty Issued")
                { }

                column(Unit_of_Measure_Code; "Unit of Measure")
                { }

                column(Location_Code; "delivery location")
                { }

                column(Description; Description)
                { }
                column(SNo; SNo)
                { }
                column(DescriptionGrec; DescriptionGrec)
                { }
                column(UomGrec; UomGrec)
                { }
                column(ReqQty; ReqQty)
                { }
                column(ReqQtyVar; ReqQtyVar)
                { }
                column(QtyIssue; QtyIssue)
                { }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLink = "Indent No." = field("Document No."), "Item No." = field("No.");
                    DataItemTableView = where("Entry Type" = filter('Negative Adjmt.'));


                    column(ILEQuantity;
                    Quantity)
                    { }
                    column(ISSNo1; "Document No.")
                    { }
                    column(ISSDate1; "Document Date")
                    { }
                    column(Item_Category_Code; "Item Category Code")
                    { }
                    column(channel; "Global Dimension 1 Code")
                    { }
                    column(Dept; "Global Dimension 2 Code")
                    { }
                }
                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    SNo += 1;
                    ReqQtyVar += "Indent Line"."Req.Quantity";

                end;
            }

            trigger OnPreDataItem();
            begin
                Clear(SNo);
                CompanyInfo.get;
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }
    var
        StartDate: Date;
        EndDate: Date;
        pa: Page "Purchase Invoice Statistics";
        ItemCategoryCode: Code[20];
        ISSNo1: Code[20];
        ISSDate1: Date;
        CompanyInfo: Record "Company Information";
        TechnicalStoresCapLbl: Label 'TECHNICAL STORES';
        MatIssueSlipCapLbl: Label 'MATERIAL ISSUE SLIP';
        IndentorCapLbl: Label 'Indentor';
        DeptCapLbl: Label 'Dept';
        LocationCapLbl: Label 'Location';
        ProgNamCapLbl: Label 'Programme Name';
        IndentNoCapLbl: Label 'Indent No';
        IndentDateCapLbl: Label 'Indent Date';
        ChannelCapLbl: Label 'Channel';
        IssNoCapLbl: Label 'ISS.NO';
        IssDateCapLbl: Label 'ISS.Date';
        SNoCapLbl: Label 'SNO.';
        DescofMatCapLbl: Label 'DESCRIPTION OF MATERIAL';
        CatNameCapLbl: Label 'CATERGORY NAME';
        MakeCapLbl: Label 'MAKE';
        //PackCapLbl: Label 'PACK';
        UOMCapLbl: Label 'UOM';
        ReqQtyCapLbl: Label 'REQ QTY';
        IssQtyCapLbl: Label 'ISS QTY';
        PurposeCapLbl: Label 'PURPOSE';
        StoresAssCapLbl: Label 'Stores Assistant';
        ReceiversSigCapLbl: Label 'Receivers Signature';
        RamojiFCCapLbl: Label 'RAMOJI FILM CITY - HYDERBAD';
        DescriptionGrec: Text[50];
        UomGrec: Code[10];
        ReqQty: Decimal;
        QtyIssue: Decimal;
        SNo: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ILEQuantity: Decimal;//B2BSCM11SEP2023
        ReqQtyVar: Decimal;

}