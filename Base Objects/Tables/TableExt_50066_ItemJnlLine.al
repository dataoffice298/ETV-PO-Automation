tableextension 50066 ItemJnlLine extends "Item Journal Line"
{
    fields
    {
        field(50150; "Indent No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50151; "Indent Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //BaluOn19Oct2022<<
        field(50152; "Issue Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50153; "Issue Sub Location"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        //BaluOn19Oct2022>>
        field(50154; "Qty issue&Return"; Boolean)//B2BSSD10JUL2023
        {
            DataClassification = CustomerContent;
        }
        field(50160; "Shortcut Dimension 3 Code"; Code[20]) //B2BVCOn30April2024
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
            Blocked = CONST(false));
            DataClassification = CustomerContent;
        }

    }

}