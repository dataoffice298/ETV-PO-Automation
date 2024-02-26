pageextension 50061 PurchaseLineArchiveExt extends "Purchase Line Archive List"
{
    layout
    {
        addafter("No.")
        {
            field("Indentor Description"; Rec."Indentor Description")
            {
                Caption = 'Indentor Description';
                ApplicationArea = All;
                ToolTip = 'Sort on Indentor Description';
            }
            field("Spec Id"; Rec."Spec Id")
            {
                Caption = 'Spec Id';
                ApplicationArea = All;
                ToolTip = 'Sort on Spec Id';
            }
        }
        modify("Variant Code")
        {
            Visible = True;
        }
        addafter("Variant Code")
        {
            field("Variant Description"; Rec."Variant Description")
            {
                Caption = 'Variant Description';
                ApplicationArea = All;
                ToolTip = 'Sort on Variant Description';
            }
        }
        addafter(Quantity)
        {
            field("Qty to Inward_B2B"; Rec."Qty to Inward_B2B")
            {
                Caption = 'Qty to Inward';
                ApplicationArea = All;
                ToolTip = 'Specifies a Qty to Inward';
            }
        }


    }
}
