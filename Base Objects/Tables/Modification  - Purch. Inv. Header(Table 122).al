tableextension 50049 tableextension70000004 extends "Purch. Inv. Header"
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
            DataClassification = CustomerContent;

        }
        field(50111; "Bill of Entry No"; Code[20])
        {
            Caption = 'Bill of Entry No.';
            Editable = false;
        }
        Field(50112; "EPCG No."; Code[20])
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
            OptionMembers = Import,Indigenous;
            OptionCaption = 'Import,Indigenous';
        }
        //B2BMSOn18Oct2022>>
        Field(50115; "Regularization"; Boolean)
        {
            Caption = 'Regularization';
        }
        field(50116; "Vendor Invoice Date"; Date)
        {
            Caption = 'Vendor Invoice Date';
        }
        field(50117; "Programme Name"; Code[50])//B2BSSD20MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50118; Purpose; Text[250])//B2BSSD21MAR2023
        {
            DataClassification = CustomerContent;
        }
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
        field(50120; "PO Narration"; Code[150]) //B2BAJ02012024
        {
            Caption = 'PO Narration';
            DataClassification = CustomerContent;
        }
    }


}

