pageextension 50070 MyExtension1 extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Accounts")
        {
            group(Weightages)
            {
                field("Price Required"; Rec."Price Required")
                {
                    ApplicationArea = all;
                }
                field("Price Weightage"; Rec."Price Weightage")
                {
                    ApplicationArea = all;
                }
                field("Quality Required"; Rec."Quality Required")
                {
                    ApplicationArea = all;
                }
                field("Quality Weightage"; Rec."Quality Weightage")
                {
                    ApplicationArea = all;
                }
                field("Delivery Required"; Rec."Delivery Required")
                {
                    ApplicationArea = all;
                }
                field("Delivery Weightage"; Rec."Delivery Weightage")
                {
                    ApplicationArea = all;
                }
                field("Payment Terms Required"; Rec."Payment Terms Required")
                {
                    ApplicationArea = all;
                }
                field("Payment Terms Weightage"; Rec."Payment Terms Weightage")
                {
                    ApplicationArea = all;
                }
                field("Default Quality Rating"; Rec."Default Quality Rating")
                {
                    ApplicationArea = all;
                }
                field("Default Delivery Rating"; Rec."Default Delivery Rating")
                {
                    ApplicationArea = all;
                }
                field("Quote Comparision"; Rec."Quote Comparision")
                {
                    ApplicationArea = All;
                }


            }
        }

        addafter("Return Order Nos.")
        {
            field("Indent Nos."; Rec."Indent Nos.")
            {
                ApplicationArea = all;
            }
            field("Indent Req No."; Rec."Indent Req No.")
            {
                ApplicationArea = all;
            }
            field("Quotation Comparision Nos."; Rec."Quotation Comparision Nos.")
            {
                ApplicationArea = All;
            }
            field("Purchase Enquiry Nos."; Rec."Purchase Enquiry Nos.")
            {
                ApplicationArea = All;
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