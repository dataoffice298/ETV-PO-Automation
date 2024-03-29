tableextension 50051 PurchRcptHdr extends "Purch. Rcpt. Header"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO

    fields
    {

        field(51000; Subject; Text[200])
        {
            Caption = 'Subject';
        }
        field(50110; "LC No."; Code[20])
        {
            Caption = 'LC No.';

        }
        field(50111; "Bill of Entry No"; Code[20])
        {
            Caption = 'Bill of Entry No';

        }
        field(50112; "EPCG No."; Code[20])
        {
            Caption = 'EPCG No';
        }
        field(50113; "EPCG Scheme"; Option)
        {
            OptionMembers = " ","Under EPCG","Non EPCG";
            OptionCaption = ' ,Under EPCG,Non EPCG';
        }

        field(50114; "Import Type"; Option)
        {
            OptionMembers = " ",Import,Indigenous;
            OptionCaption = ' ,Import,Indigenous'; //B2BVCOn28Dec2023
        }
        //B2BMSOn18Oct2022>>
        Field(50115; "Regularization"; Boolean)
        {
            Caption = 'Regularization';
        }
        field(50117; "Programme Name"; Code[50])//B2BSSD20MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50118; Purpose; Text[250])//B2BSSD21MAR2023
        {
            DataClassification = CustomerContent;
        }
        //B2BMSOn18Oct2022<<
        field(33002900; "RFQ No."; Code[20])
        {
            Description = 'PO1.0';
            TableRelation = "RFQ Numbers"."RFQ No." WHERE(Completed = FILTER(false));

            trigger OnValidate();
            var
                RFQNumbers: Record "RFQ Numbers";
            begin
            end;
        }
        field(33002901; "Quotation No."; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002902; "ICN No."; Code[20])
        {
            Description = 'PO1.0';
            Editable = false;
            TableRelation = "Quotation Comparison";
        }
        field(33002903; "Indent Req No"; Code[20])
        {
            Description = 'PO1.0';
        }
        field(33002904; "Approval Status"; Option)
        {
            OptionMembers = ,Open,"Pending Approval",Released;
            OptionCaption = ' ,Open,Pending Approval,Released';
        }
        field(50119; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(50116; "Vendor Invoice Date"; Date)
        {
            Caption = 'Vendor Invoice Date';
        }


    }


}

