report 50181 "Non Returnable Gatepass"
{
    DefaultLayout = RDLC;
    RDLCLayout = './NonReturnableGatepass.rdl';
    Caption = 'Non Returnable Gatepass_50181';
    ApplicationArea = Manufacturing;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Posted Gate Entry Header_B2B"; "Posted Gate Entry Header_B2B")
        {
            DataItemTableView = WHERE("Entry Type" = const(Outward),
                                      Type = FILTER('NRGP'));
            column(CompanyInfoName; CompanyInfo.Name)
            { }
            column(CompanyInfoPic; CompanyInfo.Picture)
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
            column(PurposeCapLbl; PurposeCapLbl)
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
            column(TOLocationCapLbl; TOLocationCapLbl)
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
            column(VendorNameCapLbl; VendorNameCapLbl)
            { }
            column(UOMCapLbl; UOMCapLbl)
            { }
            column(DesignVar; DesignVar) { }
            column(No_; "No.")
            { }
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
            column(Location_Code; LocName)
            { }
            column(To_Location; ToLocationRec.Name)
            { }
            //B2BAnusha10FEB2025
            column(Vehicle_No_; "Vehicle No.") { }
            column(Cityvar; Cityvar) { }
            column(PageLbl; PageLbl) { }
            column(PostCodeVar; PostCodeVar) { }
            column(Add1Var; Add1Var) { }
            column(Add2Var; Add2Var) { }
            column(UserName; UserName)//B2BSSD27MAR2023
            { }
            column(VendorName; VendorName)
            { }
            dataitem("Posted Gate Entry Line_B2B"; "Posted Gate Entry Line_B2B")
            {
                DataItemLink = "Entry Type" = FIELD("Entry Type"),
                "type" = field("Type"),
                              "Gate Entry No." = FIELD("No.");
                column(Source_No_; "Source No.")
                { }
                // column(Source_Name; "Source Name")
                // { }
                column(Quantity; Quantity)
                { }
                column(Gate_Entry_No_; "Gate Entry No.") { }
                column(Entry_Type; "Entry Type") { }
                column(Users; Users."Full Name")
                { }
                column(Make; Variant)
                { }
                column(ModelNo; ModelNo)
                { }
                column(SerialNo; SerialNo)
                { }
                column(DescriptionLVar; DescriptionLVar)
                { }
                column(QtyDispatchLRec; QtyDispatchLRec)
                { }
                column(ItemName; ItemName)
                { }
                column(Unit_of_Measure; "Unit of Measure")
                { }
                column(SourceNameVar; SourceNameVar) { }
                trigger OnAfterGetRecord()
                begin
                    Users.Reset();
                    Users.SetRange("User Name", "Posted Gate Entry Header_B2B"."User ID");
                    if Users.FindFirst() then
                        UserName := Users."Full Name";//B2BSSD27MAR2023

                    if "Posted Gate Entry Line_B2B"."Source Type" = "Posted Gate Entry Line_B2B"."Source Type"::Others then
                        SourceNameVar := "Posted Gate Entry Line_B2B".Description
                    else
                        SourceNameVar := "Posted Gate Entry Line_B2B"."Source Name";
                end;

            }
            //B2BAnusha10FEB2025
            trigger OnAfterGetRecord()
            var
                LocationRec: Record Location;
                UserRec: Record "User Setup";

            begin
                Clear(LocName);
                Clear(VendorName);
                LocationRec.Reset();
                LocationRec.SetRange(Code, "Posted Gate Entry Header_B2B"."Location Code");
                if LocationRec.FindFirst() then begin
                    Add1Var := LocationRec.Address;
                    Add2Var := LocationRec."Address 2";
                    Cityvar := LocationRec.City;
                    PostCodeVar := LocationRec."Post Code";
                    LocName := LocationRec.Name; //B2BVCOn21April2025
                end;
                UserRec.Reset();
                if UserRec.Get("Posted Gate Entry Header_B2B"."User ID") then
                    DesignVar := UserRec.Designation;

                if ToLocationRec.Get("To Location") then;

                if VendorRec.Get("Vendor No") then begin
                    VendorName := VendorRec.Name;
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.get;
                CompanyInfo.CALCFIELDS(Picture);
                if PostedNrgpOutwardNo <> '' then
                    SetFilter("No.", '%1', PostedNrgpOutwardNo);//B2BSSD20Jan2023
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
                    field(PostedNrgpOutwardNo; PostedNrgpOutwardNo)
                    {
                        TableRelation = "Posted Gate Entry Header_B2B"."No." where("Entry Type" = const(Outward), Type = filter(NRGP));
                        Caption = 'Posted Nrgp Outward No';
                        ApplicationArea = All;
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

        PurchaseRetnLRec: record "Return Shipment Header";
        PurchaseRetLinLRec: Record "Return Shipment Line";
        ItemName: Code[20];
        SourceNameVar: Text;
        DescriptionLVar, DesignVar : Text[100];
        QtyDispatchLRec: Decimal;
        SalesShipmentHeaderLRec: record "Sales Shipment Header";
        SalesShipmentLinLRec: record "Sales Shipment Line";
        TransferShpntHdr: record "Transfer Shipment Header";
        TransferShpntLine: Record "Transfer Shipment Line";
        TransferHdr: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        Users: Record User;
        CompanyInfo: Record "Company Information";
        NonReturnCapLbl: Label 'NON RETURNABLE GATEPASS';
        GatepassCapLbl: Label 'GATEPASS NO:';
        NameCapLbl: Label 'Name';
        DesigCapLbl: Label 'DESIGNATION';
        UseridCapLbl: Label 'USERID';
        DepartmentCapLbl: Label 'DEPARTMENT';
        PurposeCapLbl: Label 'PURPOSE';
        GatepassDate: Label 'GATEPASS DATE';
        InstallationDateCap: Label 'INSTALLATION DATE-FROM';
        ShootingCapLbl: Label 'SHOOTING DATE -  FROM';
        ExpecteddateCapLbl: Label 'EXPECTED DATE OF RETURN';
        LocationCapLbl: Label 'LOCATION';
        TOLocationCapLbl: Label 'TO LOCATION';
        SUbLocCapLbl: Label 'SUB LOCATION';
        ToCapLbl: Label 'To,';
        VendorNameCapLbl: Label 'VENDOR NAME';
        SucurtyCapLbl: Label 'The Security Inspector/Supervisor.';
        MrCapLbl: Label 'MR/MS';
        IsauthCapLbl: Label 'is authorised to take the following material from the office by hand/vehicle';
        SNOCapLbl: Label 'SNO.';
        ItemcodeCapLbl: Label 'ITEM CODE';
        ItemNameCapLbl: Label 'ITEM NAME';
        UOMCapLbl: Label 'Unit of Measure';
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
        PostedNrgpOutwardNo: Code[30];//B2BSSD20Jan2023
        UserName: Text[50]; //B2BSSD27MAR2023
        //B2BAnusha10FEB2025
        Add1Var, Add2Var, Cityvar, PostCodeVar, LocName : Text;
        PageLbl: label 'Page';
        ToLocationRec: Record Location;
        VendorRec: Record Vendor;
        VendorName: Text[100];
}