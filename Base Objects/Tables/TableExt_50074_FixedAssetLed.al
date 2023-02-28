tableextension 50074 "FALedgerEntries" extends "FA Ledger Entry"
{
    fields
    {
        field(50030; Make_B2B; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Make_B2B';
        }
        field(50031; "Serial No."; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.';
        }
        field(50032; "Model No."; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Model No.';
        }
    }

    var
        myInt: Integer;
}