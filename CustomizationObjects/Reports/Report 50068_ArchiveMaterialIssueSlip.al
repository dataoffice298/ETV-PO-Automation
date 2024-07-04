report 50068 "Archive Material Issue Slip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Archive Material Issue Slip';
    RDLCLayout = './ArchiveMaterialIssueSlip.rdl';
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
            column(RamojiFCCapLbl; RamojiFCCapLbl)
            { }
            column(ArchiveMatIssueSlipCapLbl; MatIssueSlipCapLbl)
            { }
            column(CompanyInfoName; Companyinfo.Name)
            { }
            column(CompanyInfoAddress; CompanyInfo.Address)
            { }
            column(CompanyInfoAdress2; CompanyInfo."Address 2")
            { }
            column(TechnicalStoresCapLbl; TechnicalStoresCapLbl)
            { }
            column(IndentNoCapLbl; IndentNoCapLbl)
            { }

            column(IndentorCapLbl; IndentorCapLbl)
            { }
            column(DeptCapLbl; DeptCapLbl)
            { }
            column(LocationCapLbl; LocationCapLbl)
            { }
            column(ProgNamCapLbl; ProgNamCapLbl)
            { }

            column(IndentDate; "Document Date")
            { }

            column(SD1; "Shortcut Dimension 1 Code")
            { }
            column(SD2; "Shortcut Dimension 2 Code")
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
            column(ProgrammeName; ProgrammeName)
            { }
            column(ISSNo1; ISSNo1)
            {

            }
            column(ISSDate1; ISSDate1)
            { }
            column(Purpose; Purpose) //B2BVCOn01Jan2023
            { }


            dataitem("Archive Indent Line"; "Archive Indent Line")
            {

                DataItemLinkReference = "Archive Indent Header";
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
                column(ItemCatcode; ItemCatcode)
                { }

                column(Qty_Iss; Qty_Iss) { }
                column(Req_Q; Req_Q) { }
                column(Archived_Qty_Issued; "Archived Qty Issued") { }


                trigger OnAfterGetRecord()
                var
                    ItemLVar: record Item;
                begin

                    if ItemLVar.Get("Archive Indent Line"."No.") then
                        ItemCatcode := ItemLVar."Item Category Code";

                    SNo += 1;

                end;

            }
            trigger OnAfterGetRecord()
            begin
                //B2BVCOn27Jun2024 >>
                if "Archive Indent Header"."ILE Doc No." <> '' then
                    ISSNo1 := "Archive Indent Header"."ILE Doc No."
                else
                    ISSNo1 := "Archive Indent Header"."Issue Doc No.";

                if "Archive Indent Header"."ILE Posting Date" <> 0D then
                    ISSDate1 := "Archive Indent Header"."ILE Posting Date"
                else
                    ISSDate1 := "Archive Indent Header"."Issue Date";
                //B2BVCOn27Jun2024 <<
                iF IndHdr.Get("No.") then
                    ProgrammeName := IndHdr."programme Name";

                /* ItemLedgerEntryGvar.Reset();
                ItemLedgerEntryGvar.SetRange("Indent No.", "Archive Indent Header"."No.");
                if ItemLedgerEntryGvar.FindFirst() then begin
                    ISSNo1 := ItemLedgerEntryGvar."Document No.";
                    ISSDate1 := ItemLedgerEntryGvar."Posting Date";
                end; */

            end;

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
        ItemCatcode: code[20];
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
        MatIssueSlipCapLbl: Label 'MATERIAL ISSUE SLIP';
        UomGrec: Code[10];
        ReqQty: Decimal;
        QtyIssue: Decimal;
        SNo: Integer;
        ItemLedgerEntryGvar: Record "Item Ledger Entry";
        ILEQuantity: Decimal;

        IndHdr: Record "Indent Header";
        ProgrammeName: Text[100];

        Qty_Iss: Decimal;
        Req_Q: Decimal;
}