tableextension 50053 tableextension70000014 extends "Purchase Header Archive"
{
    fields
    {
        modify("Document Type")
        {
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Enquiry', ENN = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Enquiry';
        }

        field(51000; Subject; Text[200])
        {
            Caption = 'Subject';
        }
        field(50110; "LC No."; Code[20])
        {
            Caption = 'LC No.';
        }
        Field(50111; "Bill of Entry No"; Code[20])
        {
            Caption = 'Bill of Entry No';
        }
        Field(50112; "EPCG No."; Code[20])
        {
            Caption = 'EPCG No';
        }
        Field(50115; "Regularization"; Boolean)
        {
            Caption = 'Regularization';

            DataClassification = CustomerContent;
        }
        field(50119; "Ammendent Comments"; code[500])//B2BSSD29JUN2023
        {
            DataClassification = CustomerContent;
        }
        field(50125; Amendment; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Amendment';
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
    }
}

