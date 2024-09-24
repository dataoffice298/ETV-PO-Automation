tableextension 50124 GenJnlLine extends "Gen. Journal Line"
{
    fields
    {
        field(50120; "PO Narration"; Code[150])
        {
            Caption = 'PO Narration';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}