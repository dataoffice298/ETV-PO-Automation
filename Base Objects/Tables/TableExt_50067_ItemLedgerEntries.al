tableextension 50067 ItemLedgerEntries extends "Item Ledger Entry"
{
    fields
    {
        field(50150; "Indent No."; Code[20])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(50151; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line No.';
            DataClassification = CustomerContent;
        }
        field(50154; "Qty issue&Return"; Boolean)//B2BSSD10JUL2023
        {
            Caption = 'Qty issue & Return';
            DataClassification = CustomerContent;
        }
    }

}