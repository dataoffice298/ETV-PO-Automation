pageextension 50073 pageextension70000001 extends "Purchase Quote"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,PO1.0

    layout
    {
        //B2BSSD17FEB2023<<
        modify("Attached Documents")
        {
            Visible = false;
        }
        addafter("Attached Documents")
        {
            part(AttachmentPurQUO; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Provider = PurchLines;
                SubPageLink = "Table ID" = CONST(50202),
                "No." = FIELD("Indent No."), "Line No." = field("Indent Line No.");
            }
        }
        //B2BSSD17FEB2023>>

        /*modify(General)
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }*/

        /*modify("Invoice Details")
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }*/
        modify("Shipping and Payment")
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }
        modify("Foreign Trade")
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }
        modify("Tax Information ")
        {
            Editable = PageEditable; //B2BVCOn03Oct22
        }
        modify("Payment Terms Code")//B2BSSD08Feb2023
        {
            ShowMandatory = true;
        }
        addafter("Document Date")
        {
            field("RFQ No."; Rec."RFQ No.")
            {
                ApplicationArea = All;

            }
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        //B2BSSD25Jan2023<<
        addafter(PurchLines)
        {
            part(TrermsAndCondition; "Terms and Condition")
            {
                ApplicationArea = all;
                SubPageLink = DocumentNo = field("No.");
                SubPageView = where(DocumentType = const(Quote));
                UpdatePropagation = Both;
            }
        }
        //B2BSSD25Jan2023>>

    }
    //B2BSSD017Feb2023<<
    actions
    {
        modify(MakeOrder)
        {
            trigger OnBeforeAction()
            begin
                if rec."Payment Terms Code" = '' then
                    Error('Payment Trems Code Must Have a value');
            end;
        }
        modify(DocAttach)
        {
            Visible = false;
        }
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TestField("RFQ No.");
                Rec.TestField("Payment Terms Code");
            end;
        }

    }

    //B2BSSD017Feb2023>>

    //Unsupported feature: PropertyChange. Please convert manually.
    //B2BVCOn03Oct22>>>
    trigger OnOpenPage()
    begin
        if (Rec.Status = Rec.Status::Released) then
            PageEditable := false
        else
            PageEditable := true;
    end;
    //B2BVCOn03Oct22>>>
    var

        FieldEditable: Boolean;
        PageEditable: Boolean;

        PurChQuo: Record "Purchase Header";
}

