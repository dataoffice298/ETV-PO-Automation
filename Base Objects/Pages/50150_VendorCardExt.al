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
                SubPageView = where(Type = filter("Terms & Conditions"));
                UpdatePropagation = Both;
            }
            part(termAndSpecifications; "PO Terms and Specifications") //B2BVCOn23Sep2024
            {
                ApplicationArea = All;
                SubPageLink = DocumentNo = field("No.");
                SubPageView = where(Type = filter(Specifications));
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