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
    actions
    {
        modify("Applied E&ntries")
        {
            trigger OnBeforeAction()
            var
                myInt: Record "Item Ledger Entry";
            begin
                GetAppliedEntries(Rec);
            end;
        }
    }
    procedure GetAppliedEntries(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        CreateItemLedgerEntry: Record "Item Ledger Entry";
        PurchaseReceiptHeader: Record "Purch. Rcpt. Header";
        GateEntryHeader_B2B: Record "Gate Entry Header_B2B";
    begin
        ItemLedgerEntry.Reset();
        if ItemLedgerEntry."Entry No." <> 0 then begin
            CreateItemLedgerEntry := ItemLedgerEntry;


            ItemLedgerEntry.SetCurrentKey("Entry No.");
            ItemLedgerEntry.SetRange("Entry No.");

            if CreateItemLedgerEntry."Entry No." <> 0 then begin

                ItemLedgerEntry."Entry No." := CreateItemLedgerEntry."Entry No.";
                ItemLedgerEntry.Mark(true);
            end;

            ItemLedgerEntry.SetCurrentKey("Entry No.");
            ItemLedgerEntry.SetRange("Entry No.", CreateItemLedgerEntry."Entry No.");
            if ItemLedgerEntry.Find('-') then
                repeat
                    ItemLedgerEntry.Mark(true);
                until ItemLedgerEntry.Next() = 0;
            ItemLedgerEntry.SetCurrentKey("Document No.");

        end;
        ItemLedgerEntry.MarkedOnly(true);
        if ItemLedgerEntry.FindSet() then begin
            repeat
                ItemLedgerEntry.SetRange("Document No.", PurchaseReceiptHeader."Order No.");
                if GateEntryHeader_B2B.Get("Document No.") then;
            until ItemLedgerEntry.Next() = 0;

        end;

    end;




}