pageextension 50100 PosPurchReceipt extends "Posted Purchase Receipt"
{

    layout
    {
        //B2BSSD23FEB2023<<
        addfirst(factboxes)
        {
            part(AttachmentDocPostedPurOrd; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Provider = PurchReceiptLines;
                SubPageLink = "Table ID" = CONST(50202),
                "No." = FIELD("Indent No."), "Line No." = field("Indent Line No.");
            }
        }
        //B2BSSD23FEB2023>>
        addlast(Invoicing)
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Bill of Entry No"; Rec."Bill of Entry No")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("EPCG No."; Rec."EPCG No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("EPCG Scheme"; rec."EPCG Scheme")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Import Type"; rec."Import Type")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        //B2BMMOn06Oct2022>>
        addafter("&Print")
        {
            action("Posted Purchase Receipt")
            {
                ApplicationArea = All;
                Caption = 'GRN Receipt';
                Image = Report2;
                Promoted = true;

                trigger OnAction()
                var
                    PurRcptHeader: Record "Purch. Rcpt. Header";
                begin
                    PurRcptHeader.RESET;
                    PurRcptHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUNMODAL(50071, TRUE, TRUE, PurRcptHeader);
                end;
                //B2BMMOn06Oct2022<<
            }
        }
    }

}