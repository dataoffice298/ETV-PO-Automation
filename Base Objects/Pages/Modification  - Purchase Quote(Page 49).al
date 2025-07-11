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
        addafter(Control5)
        {
            part(PurchLineItemPicture; "Purchase Line Item Picture")
            {
                ApplicationArea = All;
                Provider = PurchLines;
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
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
                SubPageView = where(DocumentType = const(Quote), Type = filter("Terms & Conditions"));
                UpdatePropagation = Both;
            }
            part(PoTermsAndSpecification; "PO Terms and Specifications")
            {
                ApplicationArea = All;
                SubPageLink = DocumentNo = field("No.");
                SubPageView = WHERE(DocumentType = const(Quote), Type = filter(Specifications));
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
        addafter("Invoice Details")
        {
            field(IGST;Rec.IGST)
            {
                ApplicationArea = All;
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
        //B2BSSD23Aug2024 >>
        addafter("&Quote")
        {
            action(TermsandCondition)
            {
                Image = GetLines;
                ApplicationArea = All;
                Caption = 'Get Terms and Condition';
                trigger OnAction()
                var
                    POTermsAndConditionsfrom: Record "PO Terms And Conditions";
                    PurchaseHeaderLvar: Record "Purchase Header";
                    POTermsAndConditionsTo: Record "PO Terms And Conditions";
                    LineNo: Integer;
                begin
                    PurchaseHeaderLvar.Reset();
                    PurchaseHeaderLvar.SetRange("Document Type", PurchaseHeaderLvar."Document Type"::Quote);
                    PurchaseHeaderLvar.SetRange("RFQ No.", Rec."RFQ No.");
                    if PurchaseHeaderLvar.FindSet() then;
                    if page.RunModal(Page::"Purchase Quotes", PurchaseHeaderLvar) = Action::LookupOK then begin
                        POTermsAndConditionsfrom.Reset();
                        POTermsAndConditionsfrom.SetRange(DocumentType, POTermsAndConditionsfrom.DocumentType::Quote);
                        POTermsAndConditionsfrom.SetRange(DocumentNo, PurchaseHeaderLvar."No.");
                        POTermsAndConditionsfrom.SetRange(Type, POTermsAndConditionsfrom.Type::"Terms & Conditions");
                        IF POTermsAndConditionsfrom.FindSet() then
                            //LineNo := POTermsAndConditionsfrom.LineNo + 10000;
                        repeat
                            POTermsAndConditionsTo.Init();
                            POTermsAndConditionsTo.DocumentNo := Rec."No.";
                            POTermsAndConditionsTo.LineType := POTermsAndConditionsfrom.LineType;
                            POTermsAndConditionsTo.Description := POTermsAndConditionsfrom.Description;
                            POTermsAndConditionsTo.Type := POTermsAndConditionsfrom.Type;
                            POTermsAndConditionsTo.LineNo := POTermsAndConditionsfrom.LineNo;
                            POTermsAndConditionsTo.Insert();
                            //LineNo += 10000;
                            until POTermsAndConditionsfrom.Next() = 0;
                    end;
                end;
            }
            action(Specifications)
            {
                Image = GetLines;
                ApplicationArea = All;
                Caption = 'Get Specifications';
                trigger OnAction()
                var
                    //POTermsAndConditionsfrom: Record "PO Terms And Conditions";
                    POSpecifications: Record "PO Specifications";
                    PurchaseHeaderLvar: Record "Purchase Header";
                    //POTermsAndConditionsTo: Record "PO Terms And Conditions";
                    POSpecificationsTo: Record "PO Specifications";
                    LineNo: Integer;
                begin
                    PurchaseHeaderLvar.Reset();
                    PurchaseHeaderLvar.SetRange("Document Type", PurchaseHeaderLvar."Document Type"::Quote);
                    PurchaseHeaderLvar.SetRange("RFQ No.", Rec."RFQ No.");
                    if PurchaseHeaderLvar.FindSet() then;
                    if page.RunModal(Page::"Purchase Quotes", PurchaseHeaderLvar) = Action::LookupOK then begin
                        POSpecifications.Reset();
                        POSpecifications.SetRange(DocumentType, POSpecifications.DocumentType::Quote);
                        POSpecifications.SetRange(DocumentNo, PurchaseHeaderLvar."No.");
                        POSpecifications.SetRange(Type, POSpecifications.Type::Specifications);
                        IF POSpecifications.FindSet() then
                            //LineNo := POTermsAndConditionsfrom.LineNo + 10000;
                        repeat
                            POSpecificationsTo.Init();
                            POSpecificationsTo.DocumentNo := Rec."No.";
                            POSpecificationsTo.LineType := POSpecifications.LineType;
                            POSpecificationsTo.Description := POSpecifications.Description;
                            POSpecificationsTo.Type := POSpecifications.Type;
                            POSpecificationsTo.LineNo := POSpecifications.LineNo;
                            POSpecificationsTo.Insert();
                            //LineNo += 10000;
                            until POSpecifications.Next() = 0;
                    end;
                end;
            }
        }
        addafter(Category_New)
        {
            group(TermsandCondition1)
            {
                Caption = 'Get Terms and Condition';
                actionref(TermsandCondition_promated; TermsandCondition)
                { }
                actionref(Specifications_promoted; Specifications)
                { }
            }
        }
        //B2BSSD23Aug2024 <<

    }

    //B2BSSD017Feb2023>>

    //Unsupported feature: PropertyChange. Please convert manually.
    //B2BVCOn03Oct22>>>
    trigger OnAfterGetRecord()
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
        Currency: Record "Currency Exchange Rate";

}

