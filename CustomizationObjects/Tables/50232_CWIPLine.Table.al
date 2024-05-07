
table 50232 "CWIP Line"

{
    Caption = 'CWIP Line';
    DataClassification = CustomerContent;
    DataCaptionFields = Description;
    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(4; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
            Editable = false;
        }
        field(5; "Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Order), "Document No." = field("Order No."));
            Editable = false;
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            Editable = false;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(8; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            Editable = false;
        }
        field(9; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(12; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
            Editable = false;
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            Editable = false;
        }
        field(14; "FA Start Date"; Date)
        {
            Caption = 'FA Start Date';
        }
        field(18; Make; Text[250])
        {
            Caption = 'Make';
            Editable = false;
        }
        field(19; Model; Text[100])
        {
            Caption = 'Model';
            Editable = false;
        }
        field(20; "Serial No."; Text[50])
        {
            Caption = 'Serial No.';
            Editable = false;
        }
        field(21; "Fixed Asset No."; Code[20])
        {
            Caption = 'Fixed Asset No.';
            TableRelation = "Fixed Asset";
            Editable = false;
        }
        field(22; "Fixed Asset Name"; Text[100])
        {
            Caption = 'Fixed Asset Name';
            Editable = false;
        }
        field(23; Amount; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(24; "CWIP Entry No."; Integer)
        {
            Caption = 'CWIP Entry No.';
            TableRelation = "CWIP Ledger Entry";
            Editable = false;
        }
        field(25; "FA Posting Group"; Code[10])
        {
            TableRelation = "FA Posting Group";
            Caption = 'FA Posting Group';
        }
        field(26; "FA Depreciation Book"; Code[10])
        {
            TableRelation = "Depreciation Book".Code;
            Caption = 'Depreciation Book Code';
        }
        field(27; "Receipt No."; Code[20])
        {
            TableRelation = "Purch. Rcpt. Header"."No.";
            Caption = 'Receipt No.';
        }
        field(28; "Receipt Line No."; Integer)
        {
            Caption = 'Receipt Line No.';
        }
        field(30; "No. of Depreciation Years"; Decimal)
        {
            Caption = 'No. of Depreciation Years';
        }
        field(31; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(32; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(33; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDimensions()
            end;

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(34; "FA Class Code"; Code[20])
        {
            TableRelation = "FA Class";
            Caption = 'FA Class Code';
        }
        field(35; "FA Sub Class Code"; Code[20])
        {
            TableRelation = "FA Subclass" where("FA Class Code" = field("FA Class Code"));
            Caption = 'FA Sub Class Code';
        }
        field(36; "FA No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'FA No. Series';
        }
        field(37; Select; Boolean)
        {
            Caption = 'Select';
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure ShowDimensions() IsChanged: Boolean
    var
        DimMgt: Codeunit DimensionManagement;
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IsChanged := OldDimSetID <> "Dimension Set ID";
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;
}

