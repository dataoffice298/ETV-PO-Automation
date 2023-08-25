table 50202 "Indent Line"
{
    // version PH1.0,PO1.0

    // Resource : SM -SivaMohan Y
    // 
    // SM  PO1.0  05/06/08  "Indent Req No" and "Indent Req Line No" fields added and Changed option values of Type field
    //                      and code in "No." field OnValidate

    LookupPageID = "Indent Line";
    DrillDownPageId = "Indent Line";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Indent Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "No."; Code[30])
        {
            Description = 'PO1.0';
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("Fixed Assets")) "Fixed Asset"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Resource)) Resource;//B2BSSD09Feb2023
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                ItemUnitofMeasure: Record 5404;
                textvar: Text;
            begin
                TestStatusOpen();
                //B2BSSD06APR2023<<
                if (StrPos("No.", ',')) > 1 then begin
                    if SelectStr(2, Rec."No.") = 'FIXED ASSET' then
                        Type := type::"Fixed Assets"
                    else
                        Type := type::Item;
                    IF SelectStr(1, Rec."No.") <> '' then begin
                        Rec."No." := SelectStr(1, Rec."No.");
                        if Rec.Type = Rec.Type::"Fixed Assets" then
                            Validate("Req.Quantity", 1);
                    end;
                end;
                //B2BSSD06APR2023>>
                CASE Type OF
                    Type::Item:
                        IF Item.GET("No.") THEN BEGIN
                            Item.TESTFIELD(Blocked, FALSE);
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            "Due Date" := CALCDATE(Item."Lead Time Calculation", WORKDATE);
                            "Unit of Measure" := Item."Base Unit of Measure";
                            VALIDATE("Unit Cost", Item."Last Direct Cost");//PO1.0
                            "Vendor No." := Item."Vendor No.";
                        END;
                    //<<PO1.0
                    Type::"Fixed Assets":
                        IF Fixedasset.GET("No.") THEN BEGIN
                            Fixedasset.TESTFIELD(Blocked, FALSE);
                            Description := Fixedasset.Description;
                            "Description 2" := Fixedasset."Description 2";
                            "Variant Code" := Fixedasset.Make_B2B;//B2BVOn20Dec22
                            Validate("Req.Quantity", 1);
                            //B2BSS01MAR2023<<
                            Fixedasset.CalcFields(Acquired);
                            Acquired := Fixedasset.Acquired;
                            //B2BSSD01MAR2023>>
                            "Avail/UnAvail" := Fixedasset."available/Unavailable";//B2BSSD17APR2023
                        END;
                    Type::"G/L Account":
                        IF GLAccount.GET("No.") THEN BEGIN
                            GLAccount.TESTFIELD(Blocked, FALSE);
                            Description := GLAccount.Name;
                        END;
                    //PO1.0>>
                    //B2BSSD09Feb2023<<
                    Type::Resource:
                        if Resource.Get("No.") then begin
                            Resource.TestField(Blocked, false);
                            Description := Resource.Name;
                        end;
                //B2BSSD09Feb2023>>
                END;

                "Avail.Qty" := 0;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", "No.");
                ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
                ItemLedgerEntry.SETRANGE("Location Code", "Delivery Location");
                IF ItemLedgerEntry.FindSet() THEN begin
                    ItemLedgerEntry.CalcSums(Quantity);
                    "Avail.Qty" := ItemLedgerEntry.Quantity;
                end;


            end;
        }
        field(4; Description; Text[50])
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(5; "Req.Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate();
            var
                indentLine: Record "Indent Line";
                ErrorReqQty: TextConst ENN = 'Qty must not less then Qty issued';
                ErrorReqQty1: TextConst ENN = 'Qty must not less then Qty issue';
            begin
                //TestStatusOpen;
                Amount := "Req.Quantity" * "Unit Cost";
                UpdateIndentQtyBase; // Nov042016
                //B2BMSOn13Sep2022>>
                if (IndentHeader.Get("Document No.")) and (IndentHeader."Released Status" = IndentHeader."Released Status"::"Pending Approval") then begin
                    IndentHeader.TestField("Ammendent Comments");
                    if (xRec."Req.Quantity" <> 0) AND ("Prev Quantity" = 0) AND (xRec."Req.Quantity" <> Rec."Req.Quantity") then
                        "Prev Quantity" := xRec."Req.Quantity";
                end;
                //B2BMSOn13Sep2022<<

                if Abs("Qty Issued") <> 0 then begin
                    if "Req.Quantity" < Abs("Qty Issued") then
                        error(ErrorReqQty)
                end
                else
                    if "Qty To Issue" <> 0 then begin
                        if "Req.Quantity" < "Qty To Issue" then
                            error(ErrorReqQty1)
                    end;
            end;
        }
        field(6; "Available Stock"; Decimal)
        {

        }
        field(10; "Due Date"; Date)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(11; "Delivery Location"; Code[20])
        {
            TableRelation = Location;

            trigger OnValidate();
            begin
                TestStatusOpen;

                "Avail.Qty" := 0;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", "No.");
                ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
                ItemLedgerEntry.SETRANGE("Location Code", "Delivery Location");
                IF ItemLedgerEntry.FindSet() THEN begin
                    ItemLedgerEntry.CalcSums(Quantity);
                    "Avail.Qty" := ItemLedgerEntry.Quantity;
                end;
            end;
        }
        field(12; "Unit of Measure"; Code[10])
        {
            Description = 'PO1.0';
            //TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(17; "Indent Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Indent,Enquiry,Offer,Order,Cancel,Closed';
            OptionMembers = Indent,Enquiry,Offer,"Order",Cancel,Closed;
        }
        field(18; "Avail.Qty"; Decimal)
        {
            Editable = false;

            trigger OnValidate();
            var
                IndentLine: Record "Indent Line";
            begin
                //if IndentLine.Type = IndentLine.Type::Item then begin
                // "Avail.Qty" := 0;
                // ItemLedgerEntry.RESET;
                // ItemLedgerEntry.SETRANGE("Item No.", "No.");
                // ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
                // ItemLedgerEntry.SETRANGE("Location Code", "Delivery Location");
                // IF ItemLedgerEntry.FINDFIRST THEN
                //     REPEAT
                //         "Avail.Qty" += ItemLedgerEntry."Remaining Quantity";
                //     UNTIL ItemLedgerEntry.NEXT = 0;

                //end;
            end;

        }
        field(20; Department; Code[20])
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(22; "Indent Req No"; Code[20])
        {
            Editable = false;
            TableRelation = "Indent Req Header";
        }
        field(23; "Indent Req Line No"; Integer)
        {
        }
        field(30; Type; Option)
        {
            Description = 'PO1.0';
            OptionMembers = Item,"Fixed Assets",Description,"G/L Account",Resource;

            trigger OnValidate();
            var
                Textvar: Text[50];
            begin

                TestStatusOpen;

            end;
        }
        field(32; "Unit Cost"; Decimal)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
                Amount := "Req.Quantity" * "Unit Cost";
            end;
        }
        field(33; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(36; "Release Status"; Option)
        {
            //B2BMSOn12Sep2022>>
            //OptionCaption = 'Open,Released,Cancel,Closed';
            //OptionMembers = Open,Released,Cancel,Closed;
            OptionCaption = 'Open,Released,Cancel,Closed,Pending Approval';
            OptionMembers = Open,Released,Cancel,Closed,"Pending Approval";
            //B2BMSOn12Sep2022<<
        }
        field(37; "Description 2"; Text[50])
        {
        }
        field(38; "Variant Code"; Code[50])//B2BSSD12APR2023 (Length Issue)  
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
            trigger OnValidate();
            begin

                TestStatusOpen;
                TESTFIELD(Type, Type::Item);
                if "Variant Code" = '' THEN
                    if Type = Type::Item THEN BEGIN
                        Item.GET("No.");
                        Description := Item.Description;
                        "Description 2" := Item."Description 2";
                    END;

                /*ItemVariant.GET("No.", "Variant Code");
                Description := ItemVariant.Description;
                "Description 2" := ItemVariant."Description 2";*/

                "Avail.Qty" := 0;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", "No.");
                ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
                ItemLedgerEntry.SETRANGE("Location Code", "Delivery Location");
                IF ItemLedgerEntry.FindSet() then begin
                    ItemLedgerEntry.CalcSums(Quantity);
                    "Avail.Qty" := ItemLedgerEntry.Quantity;
                end;
            end;
        }
        field(39; Remarks; Text[30])
        {
        }
        field(41; "Vendor No."; Code[20])
        {
            TableRelation = "Item Vendor" WHERE("Item No." = FIELD("No."));

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(50000; "Quantity (Base)"; Decimal)
        {
        }
        field(50001; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));
            Editable = false;
        }

        field(50002; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
            Blocked = CONST(false));
            Editable = false;
        }
        //B2BMSOn13Sep2022>>
        field(50003; "Prev Quantity"; Decimal)
        {
        }
        field(50004; "Transfer Order No."; Code[20])
        {
        }
        //B2BMSOn13Sep2022<<

        field(50005; "Qty To Issue"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IndentLine: Record "Indent Line";
            begin

                CalcFields("Qty issued");

                if IndentLine.Type = IndentLine.Type::Item then begin
                    if "Qty To Issue" > "Avail.Qty" then
                        Error('Qty Should not be greater than Available Qty')
                    else
                        if "Qty To Issue" > "Req.Quantity" then
                            Error('Qty Should not be greater than Req.Quantity')
                        else
                            if (Rec."Qty To Issue" - rec."Qty Issued") > Rec."Req.Quantity" then //B2BSSD03MAY2023
                                Error('Qty to Issue should not be greater than Req.Quantity %1', Rec."Req.Quantity")
                            else
                                if "Qty To Issue" < 0 then
                                    Error('Quantity issue Must Not be negative value');
                end;
            end;
        }
        field(50006; "Qty To Return"; Decimal)
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                IndentLine: Record "Indent Line";
            begin
                if IndentLine.Type = IndentLine.Type::Item then begin
                    if "Qty To Return" > "Avail.Qty" then
                        Error('Qty Should not be greater than Available Qty')
                    else
                        if "Qty To Return" > Abs("Qty Issued") then
                            Error('Nothing To Return because Qty Issued %1', "Qty Issued")
                        else
                            if (Rec."Qty To Return" + Rec."Qty Returned") > Abs(Rec."Qty Issued") then
                                Error('Qty to return should not be greater than Qty Issued %1', Abs((Rec."Qty Issued")))
                            else
                                if "Qty To Return" < 0 then
                                    Error('Quantity Return Must Not be negative value');
                end;
            end;
        }
        field(50007; "Qty Issued"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Indent No." = field("Document No."), "Indent Line No." = field("Line No."), Quantity = filter(< 0)));
        }
        field(50008; "Qty Returned"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Indent No." = field("Document No."), "Indent Line No." = field("Line No."), Quantity = filter(> 0)));

        }
        field(50009; "Archived Version"; Integer)
        {
        }
        field(50010; "Archived By"; Code[30])
        {
        }
        //BaluOn19Oct2022<<
        field(50012; "Indent Transfer"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50013; "Issue Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50014; "Issue Sub Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        //BaluOn19Oct2022>>

        field(50015; Make_B2B; Text[250])
        {
            Caption = 'Make';
            DataClassification = CustomerContent;
        }
        field(50016; "Spec Id"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50018; "Select"; Boolean)//B2BSSD30Jan2023
        {
            DataClassification = CustomerContent;
        }
        field(50017; "Indentor Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        //B2BSSD20Feb2023<<
        field(50019; "Shortcut Dimension 9 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(9),
            Blocked = CONST(false));
            Editable = false;
        }
        //B2BSS20FEB2023>>
        field(50020; Acquired; Boolean)//B2BSSD01MAR2023
        {
            DataClassification = CustomerContent;
            Caption = 'Acquired';
            Editable = false;
        }
        field(50021; "Indent No"; Code[50])//B2BSSD23MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50022; "Avail/UnAvail"; Boolean)
        {
            DataClassification = CustomerContent;

        }
        field(50023; QTyToIssueEditable; Boolean)//B2BSSD03AUG2023
        {
            DataClassification = CustomerContent;
        }
        //B2BSCM21AUG2023>>
        field(50024; "Variant Description"; Text[100])
        {
            Caption = 'Variant Description';
            TableRelation = "Item Variant".Description WHERE("Item No." = FIELD("No."));
            TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                itemvariant: Record "Item Variant";
                Vendor: Record "Purchase Header";
            begin
                itemvariant.Reset();
                itemvariant.SetRange(Description, "Variant Description");
                itemvariant.SetRange("Item No.", Rec."No.");//B2BSCM22AUG2023
                if itemvariant.FindFirst() then
                    "Variant Code" := itemvariant.Code
                else
                    if "Variant Description" = '' then //b
                        "Variant Code" := '';


            end;

        } //B2BSCM21AUG2023<<


    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        ErrorQty: TextConst ENN = 'You Can not delete the Line ';
    begin
        TESTFIELD("Indent Status", "Indent Status"::Indent);
        TESTFIELD("Release Status", "Release Status"::Open);
        if "Qty Issued" <> 0 then//B2BSSD03AUG2023
            error(ErrorQty, Rec."Line No.");
    end;

    trigger OnInsert();
    var
        IndHdr: Record "Indent Header";
    begin
        Compsetup.GET;
        "Delivery Location" := Compsetup."Location Code";
        If IndHdr.GET("Document No.") then begin
            Validate("Shortcut Dimension 1 Code", IndHdr."Shortcut Dimension 1 Code");
            Validate("Shortcut Dimension 2 Code", IndHdr."Shortcut Dimension 2 Code");
            Validate("Shortcut Dimension 9 Code", IndHdr."Shortcut Dimension 9 Code");//B2BSSD20FEB2023

            //B2BSSD06JUN2023>>
            "Avail.Qty" := 0;
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETRANGE("Item No.", "No.");
            ItemLedgerEntry.SETRANGE("Variant Code", "Variant Code");
            ItemLedgerEntry.SETRANGE("Location Code", "Delivery Location");
            IF ItemLedgerEntry.FindSet() then begin
                ItemLedgerEntry.CalcSums(Quantity);
                "Avail.Qty" := ItemLedgerEntry.Quantity;
            end;
            //B2BSSD06JUN2023<<
            // if rec."Qty To Issue" = 0 then
            //     QTyToIssueEditable := true;
        End;
    end;

    trigger OnModify();
    begin
        //TestStatusOpen;
    end;

    var
        IndentHeader: Record "Indent Header";
        Item: Record 27;
        ItemVariant: Record 5401;
        cust: Record 18;
        loc: Record 14;
        ProdOrderRoutingLine: Record 5409;
        changeIndentLine: Boolean;
        SalesPurchase: Record 13;
        Text000: Label 'Item dont have unit of measure %1';
        ItemLedgerEntry: Record 32;
        Compsetup: Record 79;
        Fixedasset: Record 5600;
        GLAccount: Record 15;
        NoStatusCheck: Boolean;
        Resource: Record Resource;//B2BSSD09Feb2023
        Translation: Codeunit Translation;
        IndentLineGvar: Record "Indent Line";

    procedure NoHeadStatusCheck(StatusCheck: Boolean)
    begin
        NoStatusCheck := StatusCheck;
    end;

    local procedure TestStatusOpen();
    begin
        if not NoStatusCheck then begin
            IF (IndentHeader.GET("Document No.")) THEN;
            if IndentHeader."Released Status" <> IndentHeader."Released Status"::"Pending Approval" then
                IndentHeader.TESTFIELD("Released Status", IndentHeader."Released Status"::Open);
            IndentHeader.MODIFY;
        end;
    end;

    procedure ChangePurchaser();
    begin
        changeIndentLine := TRUE;
        MESSAGE('fun %1', changeIndentLine);
    end;

    procedure UpdateIndentQtyBase();
    var
        Item2: Record 27;
        ItemUnitofMeasure: Record 5404;
    begin
        IF Type = Type::Item THEN BEGIN
            Item2.GET("No.");
            ItemUnitofMeasure.GET("No.", "Unit of Measure");
            IF Item2."Base Unit of Measure" = "Unit of Measure" THEN
                "Quantity (Base)" := "Req.Quantity"
            ELSE
                "Quantity (Base)" := "Req.Quantity" * ItemUnitofMeasure."Qty. per Unit of Measure";
        END else begin
            "Quantity (Base)" := "Req.Quantity";
        end;
    end;
    //B2BSCM23AUG2023>>
    procedure PermissionOfNRGP()
    var
        LocationWiseUser: Record "Location Wise User";
        CompanyInfo: Record "Company Information";
        Error001: Label 'User doesnot have permission to create NRGP OutWard';
    begin
        CompanyInfo.get();
        if LocationWiseUser.Get(CompanyInfo."Location Code", UserId) then
            if not LocationWiseUser.NRGPOutward then
                Error(Error001);
    end; //B2BSCM23AUG2023<<
         //B2BSCM24AUG2023>>
    procedure permissionRGPInward()
    var
        LocationWiseUser: Record "Location Wise User";
        CompanyInfo: Record "Company Information";
        Error001: Label 'User doesnot have permissions to RGP Inward';
    begin
        CompanyInfo.get();
        if LocationWiseUser.Get(CompanyInfo."Location Code", UserId) then begin
            if not LocationWiseUser.RGPInward then
                Error(Error001);

        end
    end;

    procedure permissionRGPOutward()
    var
        LocationWiseUser: Record "Location Wise User";
        CompanyInfo: Record "Company Information";
        Error002: Label 'User doesnot have permissions to RGP Outward';
    begin
        CompanyInfo.get();
        if LocationWiseUser.Get(CompanyInfo."Location Code", UserId) then
            if not LocationWiseUser.RGPOutward then
                Error(Error002);
    end;
    //B2BSCM24AUG2023<<

}

