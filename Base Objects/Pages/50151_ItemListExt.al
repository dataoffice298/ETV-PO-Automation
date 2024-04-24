pageextension 50151 ItemListExt extends "Item List"
{
    trigger OnOpenPage()
    begin
        Rec.SetFilter(Blocked, '%1', false);
    end;
}