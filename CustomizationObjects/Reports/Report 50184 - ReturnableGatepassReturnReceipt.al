report 50184 "Return Gatepass Return Rcpt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ReturnableGatepassReturnReceipt.rdl';
    Caption = 'Returnable Gatepass Return Receipt_50184';
    ApplicationArea = Manufacturing;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Posted Gate Entry Header_B2B"; "Posted Gate Entry Header_B2B")
        {

            DataItemTableView = WHERE("Entry Type" = const(Inward),
                                      Type = FILTER('RGP'));
            column(Program; Program)
            { }
            column(No_; "No.")
            {

            }
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
            column(PostedRGPOutwardDate; "Posted RGP Outward Date")//B2BSSD27MAR2023
            { }
            column(Location_Code; "Location Code")
            { }

            column(ReturnRcptNo; ReturnRcptNo)
            { }
            column(CompanyInfoName; CompanyInfo.Name)
            { }
            column(CompanyInfoPic; CompanyInfo.Picture)
            {

            }
            column(CompanyInfoAdd; CompanyInfo.Address)
            { }
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

            column(IncomingVerCapLbl; IncomingVerCapLbl)
            { }
            column(ReturntoCapLbl; ReturntoCapLbl)
            { }
            column(UserName; UserName)//B2BSSD27MAR2023
            { }
            column(PostedRGPOutwardNo; "Posted RGP Outward No")//B2BSSD27MAR2023
            { }
            column(Document_Date; "Document Date")//B2BSSD28MAR2023
            { }

            dataitem("Posted Gate Entry Line_B2B"; "Posted Gate Entry Line_B2B")
            {
                DataItemLink = "Entry Type" = FIELD("Entry Type"),
                "type" = field("Type"),
                              "Gate Entry No." = FIELD("No.");
                column(Source_No_; "Source No.")
                { }
                column(Source_Name; "Source Name")
                { }
                column(Quantity; Quantity)
                {

                }
                column(Users; Users."Full Name")
                { }
                column(Make; Variant)
                { }
                column(ModelNo; ModelNo)
                { }
                column(SerialNo; SerialNo)
                { }
                trigger OnAfterGetRecord()
                var

                begin
                    Users.Reset();
                    Users.SetRange("User Name", "Posted Gate Entry Header_B2B"."User ID");
                    if Users.FindFirst() then
                        UserName := Users."Full Name";//B2BSSD27MAR2023
                end;
            }

            trigger OnAfterGetRecord()
            var
                postedRgpoutward: Record "Posted Gate Entry Header_B2B";
            begin
                postedRgpoutward.Reset();
                postedRgpoutward.SetRange("No.", "Posted RGP Outward No");
                postedRgpoutward.SetRange(Type, Type);
                if postedRgpoutward.FindFirst() then
                    PostedRgpReturnRcptNo := postedRgpoutward."Posted RGP Outward No";
            end;

            trigger OnPreDataItem()
            var
                PostedGateEntry: Record "Posted Gate Entry Header_B2B";
            begin
                CompanyInfo.get;
                CompanyInfo.CALCFIELDS(Picture);
                SetFilter("No.", '%1', PostedGateEntryNo);//B2BSSD20Jan20023
            end;


        }

    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    //B2BSSD20Jan2023<<
                    field(PostedGateEntryNo; PostedGateEntryNo)
                    {

                        TableRelation = "Posted Gate Entry Header_B2B"."No." WHERE("Entry Type" = CONST(Inward));
                        ApplicationArea = All;
                        Caption = 'Posted Gate Entry No.';
                    }
                    //B2BSSD20Jan2023>>
                }
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
        Users: Record User;
        CompanyInfo: Record "Company Information";
        NonReturnCapLbl: Label 'RETURNABLE RECEIPT';
        ReturnRcptNo: Label 'RETURN RECEIPT No:';
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
        IsauthCapLbl: Label 'is authorised to take the following material.Please verify and enter in your Records';
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

        IncomingVerCapLbl: Label 'Incoming Verification';
        ReturntoCapLbl: Label 'Returned to back on___________________________Time____________and Entered in R/I Register by SI/SS________________________';
        PostedGateEntryNo: Code[30];//B2BSSD20Jan2023
        UserName: Text[50]; //B2BSSD27MAR2023
        PostedRgpReturnRcptNo: Code[50]; //B2BSSD27MAR2023
        GatepassDt: Date;//B2BSSD28MAR2023
}