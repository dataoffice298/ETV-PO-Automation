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
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Caption = 'Project Code';
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
        addafter("Approval Status")//B2BSSD20MAR2023
        {
            field("Programme Name"; Rec."Programme Name")
            {
                ApplicationArea = All;
                Caption = 'Programme Name';
            }
        }
        addafter("Programme Name")
        {
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = All;
                Caption = 'Purpose';
            }
        }
        addafter("Vendor Shipment No.")
        {
            field("Vendor Quotation No."; Rec."Vendor Quotation No.") //B2BVCOn12Mar2024
            {
                ApplicationArea = All;
                Caption = 'Vendor Quotation No.';
                ShowMandatory = true;
            }
            field("Vendor Quotation Date"; Rec."Vendor Quotation Date") //B2BVCOn18Mar2024
            {
                ApplicationArea = All;
                Caption = 'Vendor Quotation Date';
                ShowMandatory = true;
            }

            field("Ammendent Comments"; Rec."Ammendent Comments") //B2BVCOn12Mar2024
            {
                ApplicationArea = All;
                Caption = 'Ammendent Comments';
            }
        }
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

            trigger OnAfterAction()
            var
                POAutomation: Codeunit "PO Automation";
                PurchaseOrder: Record "Purchase Header";
            begin
                PurchaseOrder.Reset();
                PurchaseOrder.SetRange("Quotation No.", Rec."No.");
                if PurchaseOrder.FindFirst() then
                    POAutomation.CopyTermsandConditionsofVendorDoc(Rec, PurchaseOrder);
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
                Rec.TestField("Vendor Quotation No."); //B2BVCOn12Mar2024
                Rec.TestField("Vendor Quotation Date"); //B2BVCOn18Mar2024
            end;
        }
        modify(Reopen)
        {
            trigger OnBeforeAction()
            var
                PurchaseHeadArchive: Record "Purchase Header Archive";
                ArchiveManagement: Codeunit ArchiveManagement;
                ReleasePurchDoc: Codeunit "Release Purchase Document";

            begin
                //B2BVCOn12Mar2024 >>
                if Rec.Status = rec.Status::Released then begin
                    Rec.TestField("Ammendent Comments");

                end;
                ArchiveManagement.ArchivePurchDocument(Rec);
                ReleasePurchDoc.PerformManualReopen(Rec);
                Rec."Ammendent Comments" := '';
                //B2BVCOn12Mar2024 <<
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

