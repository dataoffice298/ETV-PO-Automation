report 50068 "Archive Material Issue Slip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Archive Material Issue Slip';
    RDLCLayout = './CustomizationObjects/Reports/Layouts/ArchiveMaterialIssueSlip.rdl';
    DefaultLayout = RDLC;


    dataset
    {
        dataitem("Archive Indent Header"; "Archive Indent Header")
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
            column(ArchiveMatIssueSlipCapLbl; ArchiveMatIssueSlipCapLbl)
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
            /* column(programme_Name; "programme Name")
            { }
            column(Purpose; Purpose)
            { } */
            dataitem("Archive Indent Line"; "Archive Indent Line")
            {
                DataItemLink = "Document No." = field("No."), "Archived Version" = field("Archived Version");
                column(Variant_Code; "Variant Code")
                { }
                column(Document_No_; "Document No.") { }

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
                column(QtyIssue; QtyIssue)
                { }
                column(Qty_Iss; Qty_Iss) { }
                column(Req_Q; Req_Q) { }
                column(Archived_Qty_Issued; "Archived Qty Issued") { }

                trigger OnAfterGetRecord()

                begin

                    ArchiveLine.Reset();
                    ArchiveLine.SetRange("Document No.", "Archive Indent Line"."Document No.");
                    ArchiveLine.SetRange("Archived Version", "Archive Indent Line"."Archived Version");
                    if ArchiveLine.FindSet() then begin
                        ArchiveLine.CalcSums("Archived Qty Issued", "Req.Quantity");
                        Req_Q := ArchiveLine."Req.Quantity";
                        Qty_Iss := ArchiveLine."Archived Qty Issued";
                    end;

                    SNo += 1;
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
        ArchiveLine: Record "Archive Indent Line";
        CompanyInfo: Record "Company Information";
        TechnicalStoresCapLbl: Label 'TECHNICAL STORES';
        ArchiveMatIssueSlipCapLbl: Label 'ARCHIVE MATERIAL ISSUE SLIP';
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
        ILEQuantity: Decimal;
        Qty_Iss: Decimal;
        Req_Q: Decimal;
}