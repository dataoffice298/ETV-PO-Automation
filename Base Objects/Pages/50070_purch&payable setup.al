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
                field("Indent Workflow User Group"; Rec."Indent Workflow User Group")
                {
                    ApplicationArea = All;
                    Caption = 'PO Workflow User Group';
                }

            }
        }

        addafter("Return Order Nos.")
        {
            field("Indent Nos."; Rec."Indent Nos.")
            {
                ApplicationArea = all;
            }
            field("Transfer Indent"; "Transfer Indent")
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
            field("LC Detail Nos."; Rec."LC Detail Nos.")
            {
                ApplicationArea = All;
            }
        }

        //B2BMSOn13Sep2022>>
        addlast(General)
        {
            group("Indent Issue")
            {
                field("Indent Issue Jnl. Template"; Rec."Indent Issue Jnl. Template")
                {
                    ApplicationArea = All;
                }
                field("Indent Issue Jnl. Batch"; Rec."Indent Issue Jnl. Batch")
                {
                    ApplicationArea = All;
                }
            }
            group("Indent Return")
            {
                field("Indent Return Jnl. Template"; Rec."Indent Return Jnl. Template")
                {
                    ApplicationArea = All;
                }
                field("Indent Return Jnl. Batch"; Rec."Indent Return Jnl. Batch")
                {
                    ApplicationArea = All;
                }
            }
            group("Indent Location")
            {
                field("Indent Store Location"; Rec."Indent Store Location")
                {
                    ApplicationArea = All;
                }
            }
        }
        //B2BMSOn13Sep2022<<
        addafter(Weightages)
        {
            group("Enquiry Note")
            {
                field("Terms & Conditions"; Rec."Terms & Conditions")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Terms & Conditions field.';
                }
                field("Req Note"; Rec."Req Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Req Note field.';
                }
            }
        }

        addlast("Number Series")
        {
            field("RFQ Nos."; Rec."RFQ Nos.")
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