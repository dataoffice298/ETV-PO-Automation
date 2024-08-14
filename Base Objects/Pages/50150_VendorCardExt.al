pageextension 50150 "Vendor CardExt" extends "Vendor Card"
{
    layout
    {
        addafter("Tax Information")
        {
            part(TrermsAndCondition; "Terms and Condition")
            {
                ApplicationArea = all;
                SubPageLink = DocumentNo = field("No.");
                UpdatePropagation = Both;
            }

        }
        moveafter("Address 2"; "Address 3")
    }

    actions
    {

    }


    var
        POTerms: Record "PO Terms And Conditions";
}