pageextension 50122 ItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Qty issue&Return"; Rec."Qty issue&Return")
            {
                ApplicationArea = All;
                Caption = 'Qty issue & Return';
            }
        }
    }
}