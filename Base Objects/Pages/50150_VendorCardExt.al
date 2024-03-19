pageextension 50150 "Vendor CardExt" extends "Vendor Card"
{
    layout
    {
        addafter("Tax Information")
        {
            part(TrermsAndCondition; "Terms and Condition")
            {
                ApplicationArea = all;
                SubPageLink = DocumentType = field("Document Type"), DocumentNo = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {

    }
    trigger OnOpenPage()
    begin
        Rec."Document Type" := Rec."Document Type"::Vendor;
        Rec.Modify;
    end;

    var
        POTerms: Record "PO Terms And Conditions";
}