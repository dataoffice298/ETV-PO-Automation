report 50063 "Material Issue Slip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Material Issue Slip';
    RDLCLayout = './MaterialIssueSlip.rdl';
    DefaultLayout = RDLC;


    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            RequestFilterFields = "No.";
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
            column(PackCapLbl; PackCapLbl)
            { }
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
            column(IssNo; ItemJournalLine."Document No.")
            { }
            column(IssDate; ItemJournalLine."Posting Date")
            { }

            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(SNo; SNo)
                { }
                column(DescriptionGrec; DescriptionGrec)
                { }
                column(CategoryName; CategoryName)
                { }
                column(UomGrec; UomGrec)
                { }
                column(ReqQty; ReqQty)
                { }
                column(QtyIssue; QtyIssue)
                { }

                trigger OnAfterGetRecord()
                begin
                    "Indent Line".Reset();
                    "Indent Line".SetRange("Document No.", "No.");
                    if "Indent Line".FindSet() then begin
                        repeat
                            SNo += 1;
                            DescriptionGrec := "Indent Line".Description;
                            CategoryName := "Indent Line".Type;
                            UomGrec := "Indent Line"."Unit of Measure";
                            ReqQty := "Indent Line"."Req.Quantity";
                            QtyIssue := "Indent Line"."Qty To Issue";
                        until "Indent Line".Next = 0;
                    end;
                end;
            }

            trigger OnPreDataItem();
            begin

                CompanyInfo.FIND('-');
                CompanyInfo.CALCFIELDS(Picture);
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

    /*  rendering
      {
          layout(LayoutName)
          {
              Type = RDLC;
              LayoutFile = 'mylayout.rdl';
          }
      }*/

    var
        CompanyInfo: Record "Company Information";
        TechnicalStoresCapLbl: Label 'TECHNICAL STORES';
        MatIssueSlipCapLbl: Label 'MATERIAL ISSUE SLIP';
        IndentorCapLbl: Label 'Indentor    :';
        DeptCapLbl: Label 'Dept    :   ';
        LocationCapLbl: Label 'Location    :';
        ProgNamCapLbl: Label 'Programme Name    :';
        IndentNoCapLbl: Label 'Indent No    :';
        IndentDateCapLbl: Label 'Indent Date    :';
        ChannelCapLbl: Label 'Channel    :';
        IssNoCapLbl: Label 'ISS.NO    :';
        IssDateCapLbl: Label 'ISS.Date    :';
        SNoCapLbl: Label 'SNO.';
        DescofMatCapLbl: Label 'DESCRIPTION OF MATERIAL';
        CatNameCapLbl: Label 'CATERGORY NAME';
        MakeCapLbl: Label 'MAKE';
        PackCapLbl: Label 'PACK';
        UOMCapLbl: Label 'UOM';
        ReqQtyCapLbl: Label 'REQ QTY';
        IssQtyCapLbl: Label 'ISS QTY';
        PurposeCapLbl: Label 'PURPOSE:';
        StoresAssCapLbl: Label 'Stores Assistant';
        ReceiversSigCapLbl: Label 'Receivers Signature';
        RamojiFCCapLbl: Label 'RAMOJI FILM CITY - HYDERBAD';
        ItemJournalLine: Record "Item Journal Line";
        DescriptionGrec: Text[50];
        CategoryName: Option;
        UomGrec: Code[10];
        ReqQty: Decimal;
        QtyIssue: Decimal;
        SNo: Integer;
}