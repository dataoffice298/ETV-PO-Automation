report 50183 "Returnable Gatepass"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReturnableGatepass.rdl';
    Caption = 'Returnable Gatepass_50183';
    ApplicationArea = Manufacturing;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Posted Gate Entry Header_B2B"; "Posted Gate Entry Header_B2B")//B2BSSD19Jan2023
        {
            RequestFilterFields = "No.";
            //DataItemTableView = WHERE("Entry Type" = const(Inward),
            //Type = const(RGP));
            DataItemTableView = WHERE("Entry Type" = const(Outward),
                                      Type = const(RGP));//B2BSSD19Jan2023
            column(Program; Program)
            { }
            column(No_; "No.")
            { }
            column(Designation; Designation)
            {

            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            { }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            { }
            column(Purpose; Purpose)
            { }
            column(InstallationFromDate; InstallationFromDate)
            { }
            column(InstallationToDate; InstallationToDate)
            { }
            column(ShootingStartDate; ShootingStartDate)
            { }
            column(ShootingEndDate; ShootingEndDate)
            { }
            column(ExpectedDateofReturn; ExpectedDateofReturn)
            { }
            column(SubLocation; SubLocation)
            { }
            column(User_ID; "User ID")
            { }
            column(GatepassDt; "Document Date")
            { }
            column(Location_Code; "Location Code")
            { }

            column(CompanyInfoName; CompanyInfo.Name)
            { }
            column(CompanyInfoPic; CompanyInfo.Picture)
            {

            }
            column(NonReturnCapLbl; NonReturnCapLbl)
            { }
            column(GatepassCapLbl; GatepassCapLbl)
            { }
            column(NameCapLbl; NameCapLbl)
            { }
            column(DesigCapLbl; DesigCapLbl)
            { }
            column(UseridCapLbl; UseridCapLbl)
            { }
            column(DepartmentCapLbl; DepartmentCapLbl)
            { }
            column(ChannelCapLbl; ChannelCapLbl)
            { }
            column(PurposeCapLbl; PurposeCapLbl)
            { }
            column(ProgramCapLbl; ProgramCapLbl)
            { }
            column(GatepassDate; GatepassDate)
            { }
            column(InstallationDateCap; InstallationDateCap)
            { }
            column(ShootingCapLbl; ShootingCapLbl)
            { }
            column(ExpecteddateCapLbl; ExpecteddateCapLbl)
            { }
            column(LocationCapLbl; LocationCapLbl)
            { }
            column(SUbLocCapLbl; SUbLocCapLbl)
            { }
            column(ToCapLbl; ToCapLbl)
            { }
            column(SucurtyCapLbl; SucurtyCapLbl)
            { }
            column(MrCapLbl; MrCapLbl)
            { }
            column(IsauthCapLbl; IsauthCapLbl)
            { }
            column(SNOCapLbl; SNOCapLbl)
            { }
            column(ItemcodeCapLbl; ItemcodeCapLbl)
            { }
            column(ItemNameCapLbl; ItemNameCapLbl)
            { }
            column(QtyCapLbl; QtyCapLbl)
            { }
            column(MakeCapLbl; MakeCapLbl)
            { }
            column(ModelNoCapLbl; ModelNoCapLbl)
            { }
            column(SerialCapLbl; SerialCapLbl)
            { }
            column(AuthCapLbl; AuthCapLbl)
            { }
            column(ISSEdCapLbl; ISSEdCapLbl)
            { }
            column(ReceiedCapLbl; ReceiedCapLbl)
            { }
            column(Securitysepcaplbl; Securitysepcaplbl)
            { }
            column(OutgoingVerCapLbl; OutgoingVerCapLbl)
            { }
            column(ItematerialCapLbl; ItematerialCapLbl)
            { }
            column(CheckedCapLbl; CheckedCapLbl)
            { }
            column(IncomingVerCapLbl; IncomingVerCapLbl)
            { }
            column(ReturntoCapLbl; ReturntoCapLbl)
            { }
            column(UserName; UserName)//B2BSS27MAR2023
            { }
            dataitem("Posted Gate Entry Line_B2B"; "Posted Gate Entry Line_B2B")//B2BSSD19Jan2023
            {
                DataItemLink = "Entry Type" = FIELD("Entry Type"),
                               "type" = field("Type"),
                               "Gate Entry No." = FIELD("No.");

                column(Source_No_; "Source No.")
                { }
                column(Source_Type; "Source Type")
                { }
                column(Source_Name; "Source Name")
                { }
                column(QuantityGEL; Quantity)
                { }
                column(Users; Users."Full Name")
                { }
                column(Make; Variant)
                { }
                column(ModelNoGEL; ModelNo)
                { }
                column(SerialNoGEL; SerialNo)
                { }
                trigger OnAfterGetRecord()

                begin
                    Users.Reset();
                    Users.SetRange("User Name", "Posted Gate Entry Header_B2B"."User ID");
                    if Users.FindFirst() then
                        UserName := Users."Full Name";//B2BSSD27MAR2023
                end;
            }
            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.get;
                CompanyInfo.CALCFIELDS(Picture);
                SetFilter("No.", '%1', PostedRGPOutWardList);//B2BSSD20Jan2023
            end;


        }

    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                //B2BSSD20Jan2023<<
                group(GroUpName)
                {
                    field(PostedRGPOutWardList; PostedRGPOutWardList)
                    {
                        ApplicationArea = All;
                        TableRelation = "Posted Gate Entry Header_B2B"."No." where("Entry Type" = const(Outward));
                        Caption = 'Posted RGP OutWard No.';
                    }
                }
                //B2BSSD20Jan2023>>
            }
        }


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }


        }

    }




    var
        VariantCode: Code[10];
        TransferHdr: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        PurchaseRetnLRec: record "Return Shipment Header";
        PurchaseRetLinLRec: Record "Return Shipment Line";

        SalesHdrLRec: Record "Sales Header";
        SalesLineLRec: Record "Sales Line";
        TransferShpntHdr: record "Transfer Shipment Header";
        TransferShpntLine: Record "Transfer Shipment Line";
        item: Record Item;
        ItemName: Code[20];
        DescriptionLVar: Text[100];
        QtyDispatchLRec: Decimal;

        SalesShipmentHeaderLRec: record "Sales Shipment Header";
        SalesShipmentLinLRec: record "Sales Shipment Line";
        Users: Record User;
        CompanyInfo: Record "Company Information";
        NonReturnCapLbl: Label 'RETURNABLE GATEPASS';
        GatepassCapLbl: Label 'GATEPASS NO:';
        NameCapLbl: Label 'Name';
        DesigCapLbl: Label 'DESIGNATION';
        PurposeCapLbl: Label 'PURPOSE';
        UseridCapLbl: Label 'USERID';
        DepartmentCapLbl: Label 'DEPARTMENT';
        ChannelCapLbl: Label 'CHANNEL';
        ProgramCapLbl: Label 'PROGRAM';
        GatepassDate: Label 'GATEPASS DATE';
        InstallationDateCap: Label 'INSTALLATION DATE-FROM';
        ShootingCapLbl: Label 'SHOOTING DATE -  FROM';
        ExpecteddateCapLbl: Label 'EXPECTED DATE OF RETURN';
        LocationCapLbl: Label 'LOCATION';
        SUbLocCapLbl: Label 'SUB LOCATION';
        ToCapLbl: Label 'To,';
        SucurtyCapLbl: Label 'The Security Inspector/Supervisor.';
        MrCapLbl: Label 'MR/MS';
        IsauthCapLbl: Label 'is authorised to take the following material from the office by hand/vehicle';
        SNOCapLbl: Label 'SNO.';
        ItemcodeCapLbl: Label 'ITEM CODE';
        ItemNameCapLbl: Label 'ITEM NAME';
        QtyCapLbl: Label 'QTY';
        MakeCapLbl: Label 'MAKE';
        ModelNoCapLbl: Label 'MODEL NO.';
        SerialCapLbl: Label 'SERIAL NO';
        AuthCapLbl: Label 'AUTHORISED SIGN:';
        ISSEdCapLbl: Label 'ISSUED BY:';
        ReceiedCapLbl: Label 'RECEIVED BY:';
        Securitysepcaplbl: Label 'SECURITY DEPARTMENT';
        OutgoingVerCapLbl: Label 'Outgoing Verification:';
        ItematerialCapLbl: Label '1)Item/Material checked and entered in Returnable Items Register on________________Time_____________Signature of SI/SS___________________';
        CheckedCapLbl: Label '2)Checked and allowed at the gate on_____________________Time____________________';
        IncomingVerCapLbl: Label 'Incoming Verification';
        ReturntoCapLbl: Label 'Returned to back on___________________________Time____________and Entered in R/I Register by SI/SS________________________';
        PostedRGPOutWardList: Code[30];//B2BSSD20Jan2023
        UserName: Text[50];//B2BSSD27MAR2023
}