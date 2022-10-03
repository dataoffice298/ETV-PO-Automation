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
    }

}