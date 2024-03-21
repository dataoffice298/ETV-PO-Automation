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
    }

    actions
    {

    }


    var
        POTerms: Record "PO Terms And Conditions";
}