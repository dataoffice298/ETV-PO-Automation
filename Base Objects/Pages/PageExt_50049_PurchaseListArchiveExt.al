pageextension 50049 PurchaseListArchiveExt extends "Purchase List Archive"
{
    layout
    {
        addafter("Location Code")
        {
            field("Ammendent Comments"; Rec."Ammendent Comments")
            {
                ApplicationArea = All;
                Caption = 'Ammendent Comments';
            }
        }
    }
}