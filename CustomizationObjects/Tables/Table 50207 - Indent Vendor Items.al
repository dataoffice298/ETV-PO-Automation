table 50207 "Indent Vendor Items"
{
    // version PH1.0,PO1.0

    // Resource : SM-SivaMohan
    // 
    // SM  1.0  04/06/08   "Indent Req No","Indent Req Line No" Fields Added


    fields
    {
        field(1; "Item No."; Code[20])
        {
        }
        field(2; Quantity; Decimal)
        {
        }
        field(3; "Vendor No."; Code[20])
        {
        }
        field(4; "Indent No."; Code[20])
        {
        }
        field(5; "Indent Line No."; Integer)
        {
        }
        field(6; "Due Date"; Date)
        {
        }
        field(7; Check; Boolean)
        {
        }
        field(8; "Location Code"; Code[10])
        {
        }
        field(11; "Variant Code"; Code[20])
        {
        }
        field(13; "Unit Of Measure"; Code[20])
        {
        }
        field(14; "Project No."; Code[20])
        {
            TableRelation = Job;
        }
        field(15; Department; Code[20])
        {
        }
        field(16; "Material Requisition No."; Code[20])
        {
            Editable = false;
            TableRelation = Job;
        }
        field(17; Brand; Text[50])
        {
            TableRelation = Manufacturer.Code;
        }
        field(19; "No.Series"; Code[20])
        {
        }
        field(22; "Indent Req No"; Code[20])
        {
            //TableRelation = Table50067;//balu
        }
        field(23; "Indent Req Line No"; Integer)
        {
        }
        field(50012; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));
        }
        field(50013; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
            Blocked = CONST(false));
        }
        field(50014; "Line Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Item,"Fixed Assets",Description,"G/L Account",Resource;
        }
        field(50015; "Sub Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50017; "Spec Id"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        //B2BSSD20FEB2023<<
        field(50018; "Shortcut Dimension 9 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(9),
            Blocked = CONST(false));
        }
        //B2BSSD20FEB2023>>
        field(50019; "Programme Name"; code[50])//B2BSSD20MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50020; Purpose; Text[250])//B2BSSD21MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50021; "Variant Description"; Text[100]) //B2BSCM11JAN2024
        {
            Caption = 'Variant Description';
            DataClassification = CustomerContent;
        }
        field(50022; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
            Blocked = CONST(false));
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Item No.", "Indent No.", "Indent Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

