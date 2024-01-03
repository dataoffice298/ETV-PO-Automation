pageextension 50123 VendorLedgerEntries extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Location GST Reg. No.")
        {
            field("PO Narration"; Rec."PO Narration")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Value of PO Narration Value';
            }
        }
    }
}