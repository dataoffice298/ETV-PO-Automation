codeunit 50014 "Approvals MGt 3"

{
    //CHP>>
    SingleInstance = true;


    Var
        AlreadyCreated: Boolean;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    procedure OnInsertILECostRefNo(VAR NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; VAR ItemLedgEntryNo: Integer)
    var
        IndentLine: Record "Indent Line";
        INDENTHEADER: Record "Indent Header";

    begin
        NewItemLedgEntry."Indent No." := ItemJournalLine."Indent No.";
        NewItemLedgEntry."Indent Line No." := ItemJournalLine."Indent Line No.";
        NewItemLedgEntry."Qty issue&Return" := ItemJournalLine."Qty issue&Return";//B2BSSD10JUL2023
        if IndentLine.Get(NewItemLedgEntry."Indent No.", NewItemLedgEntry."Indent Line No.") then
            if INDENTHEADER.Get(IndentLine."Document No.") then
                if not AlreadyCreated then begin
                    INDENTHEADER.ArchiveQuantityIssued(INDENTHEADER, IndentLine, NewItemLedgEntry);
                    AlreadyCreated := true;
                end;
        if NewItemLedgEntry."Indent Line No." <> 0 then begin
            IndentLine.Get(NewItemLedgEntry."Indent No.", NewItemLedgEntry."Indent Line No.");
            IndentLine.NoHeadStatusCheck(true);
            IndentLine.Validate("Delivery Location");
            //B2BSSD03MAY2023>>
            if NewItemLedgEntry."Entry Type" = NewItemLedgEntry."Entry Type"::"Negative Adjmt." then begin
                IndentLine."Avail.Qty" := IndentLine."Avail.Qty" - ItemJournalLine.Quantity;
                IndentLine.VALIDATE("Qty To Issue", 0); //B2BMSOn07Nov2022
            end else
                if NewItemLedgEntry."Entry Type" = NewItemLedgEntry."Entry Type"::"Positive Adjmt." then begin
                    IndentLine."Avail.Qty" := IndentLine."Avail.Qty" + ItemJournalLine.Quantity;
                    IndentLine."Qty To Return" := 0; //B2BSSD25JUL2023
                end;
            IndentLine.Modify();
            //I += 1;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterPostSplitJnlLine', '', false, false)]
    local procedure OnAfterPostSplitJnlLine(var ItemJournalLine: Record "Item Journal Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        AlreadyCreated := false;
    end;
}
