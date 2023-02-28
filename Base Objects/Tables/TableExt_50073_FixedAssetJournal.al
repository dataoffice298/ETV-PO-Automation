tableextension 50073 FixedAsstesJournal extends "FA Journal Line"
{
    fields
    {
        field(50001; Make_B2B; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Make_B2B';
        }
        field(50002; "Serial No."; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Serial No.';
        }
        field(50003; "Model No."; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Model No.';
        }
    }

    var
        myInt: Integer;
}