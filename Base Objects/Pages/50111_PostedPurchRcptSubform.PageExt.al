pageextension 50111 PostedPurchRcptSubform extends "Posted Purchase Rcpt. Subform"
{
    Editable = false;
    layout
    {
        addafter(Description)
        {
            //B2BVCOn03Oct22>>>
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                ApplicationArea = all;
            }
            //B2BVCOn03Oct22<<<
            field("Rejection Comments B2B"; "Rejection Comments B2B")
            {
                ApplicationArea = all;
            }
            field("Spec Id"; rec."Spec Id")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}