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
                myInt: Integer;
            begin

            end;
        }
        addafter("Applied E&ntries")
        {
            action("Applied Entries New")
            {
                ApplicationArea = All;
                Image = Apply;
                Caption = 'Applied Entries New';
                Promoted = true;
                PromotedIsBig = True;
                trigger OnAction()
                var
                    TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                begin
                    FindAppliedEntries(Rec, TempItemLedgerEntry);
                end;
            }
        }
    }
    procedure FindAppliedEntries(ItemLedgEntry: Record "Item Ledger Entry"; var TempItemLedgerEntry: Record "Item Ledger Entry" temporary)
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        with ItemLedgEntry do
            if Positive then begin
                ItemApplnEntry.Reset();
                ItemApplnEntry.SetCurrentKey("Inbound Item Entry No.", "Outbound Item Entry No.", "Cost Application");
                ItemApplnEntry.SetRange("Inbound Item Entry No.", "Entry No.");
                ItemApplnEntry.SetFilter("Outbound Item Entry No.", '<>%1', 0);
                ItemApplnEntry.SetRange("Cost Application", true);
                if ItemApplnEntry.Find('-') then
                    repeat
                        InsertTempEntry(TempItemLedgerEntry, ItemApplnEntry."Outbound Item Entry No.", ItemApplnEntry.Quantity);
                    until ItemApplnEntry.Next() = 0;
            end else begin
                ItemApplnEntry.Reset();
                ItemApplnEntry.SetCurrentKey("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
                ItemApplnEntry.SetRange("Outbound Item Entry No.", "Entry No.");
                ItemApplnEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                ItemApplnEntry.SetRange("Cost Application", true);

                if ItemApplnEntry.Find('-') then
                    repeat
                        InsertTempEntry(TempItemLedgerEntry, ItemApplnEntry."Inbound Item Entry No.", -ItemApplnEntry.Quantity);
                        Message('ItemLedgerEntries EntryNo is %1', TempItemLedgerEntry."Entry No.");
                    until ItemApplnEntry.Next() = 0;
            end;
    end;

    local procedure InsertTempEntry(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; EntryNo: Integer; AppliedQty: Decimal)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        IsHandled: Boolean;
    begin
        ItemLedgEntry.Get(EntryNo);

        IsHandled := false;
        if IsHandled then
            exit;

        if AppliedQty * ItemLedgEntry.Quantity < 0 then
            exit;

        if not TempItemLedgerEntry.Get(EntryNo) then begin
            TempItemLedgerEntry.Init();
            TempItemLedgerEntry := ItemLedgEntry;
            TempItemLedgerEntry.Quantity := AppliedQty;
            TempItemLedgerEntry.Insert();
        end else begin
            TempItemLedgerEntry.Quantity := TempItemLedgerEntry.Quantity + AppliedQty;
            TempItemLedgerEntry.Modify();
        end;
    end;
}