/* table 50230 "CWIP Ledger Entry"
{
    Caption = 'CWIP Ledger Entry';
    DataClassification = CustomerContent;
    LookupPageId = "CWIP Ledger Entries";
    DrillDownPageId = "CWIP Ledger Entries";
    DataCaptionFields = Description;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(4; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(7; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(8; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(19; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(20; "FA Acquired"; Boolean)
        {
            Caption = 'FA Acquired';
        }
        field(21; "FA No."; Code[20])
        {
            Caption = 'FA No.';
        }
        field(22; "FA Name"; Text[100])
        {
            Caption = 'FA Name';
        }
        field(23; "Receipt No."; Code[20])
        {
            TableRelation = "Purch. Rcpt. Header"."No.";
            Caption = 'Receipt No.';
        }
        field(24; "Receipt Line No."; Integer)
        {
            Caption = 'Receipt Line No.';
        }
        field(25; "CWIP No."; Code[20])
        {
            Caption = 'CWIP No.';
        }
        field(26; "CWIP Line No."; Integer)
        {
            Caption = 'CWIP Line No.';
        }
        field(27; Make; Text[250])
        {
            Caption = 'Make';
            Editable = false;
        }
        field(28; Model; Text[100])
        {
            Caption = 'Model';
            Editable = false;
        }
        field(29; "Serial No."; Text[50])
        {
            Caption = 'Serial No.';
            Editable = false;
        }
        field(30; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;
        }
        field(31; "CWIP Detail Line No."; Integer)
        {
            
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
    end;
}
 */