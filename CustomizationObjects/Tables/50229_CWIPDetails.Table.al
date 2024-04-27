/* table 50229 "CWIP Details"
{
    Caption = 'CWIP Details';
    DataClassification = CustomerContent;
    LookupPageId = "CWIP Details";
    DrillDownPageId = "CWIP Details";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Make; Text[250])
        {
            Caption = 'Make';
        }
        field(5; Model; Text[100])
        {
            Caption = 'Model';
        }
        field(6; "Serial No."; Text[50])
        {
            Caption = 'Serial No.';
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(8; "FA Created"; Boolean)
        {
            Caption = 'FA Created';

        }
        field(9; "FA No."; Code[20])
        {
            Caption = 'FA No.';
            TableRelation = "Fixed Asset";
        }
        field(10; Reverse; Boolean)
        {
            Caption = 'Reverse';
        }
        field(11; Posted; Boolean)
        {
            Caption = 'Posted';
        }
    }
    keys
    {
        key(PK; "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        CheckLineLimit();
    end;

    trigger OnModify()
    begin
        TestField(Posted, false);
    end;

    trigger OnRename()
    begin
        TestField(Posted, false);
    end;

    trigger OnDelete()
    begin
        TestField(Posted, false);
    end;

    local procedure CheckLineLimit()
    var
        CWIPDetails: Record "CWIP Details";
        PurchaseLine: Record "Purchase Line";
        ErrLbl: Label 'You cannot insert the lines more than the qty. of purchase line.';
    begin
        if PurchaseLine.Get(PurchaseLine."Document Type"::Order, "Document No.", "Document Line No.") then begin
            CWIPDetails.Reset();
            CWIPDetails.SetRange("Document No.", "Document No.");
            CWIPDetails.SetRange("Document Line No.", "Document Line No.");
            if CWIPDetails.FindSet() then
                if CWIPDetails.Count + 1 > PurchaseLine.Quantity then
                    Error(ErrLbl);
        end;
    end;
}
 */