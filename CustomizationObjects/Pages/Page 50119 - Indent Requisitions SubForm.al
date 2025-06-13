page 50119 "Indent Requisitions SubForm"
{
    // version PO1.0

    AutoSplitKey = false;
    PageType = ListPart;
    SourceTable = "Indent Requisitions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ApplicationArea = All;
                    Caption = 'Requisition Status';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Requisition Status field.';
                }
                field("Purch Order No."; Rec."Purch Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Purch Order No.';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Purch Order No. field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                    ApplicationArea = All;
                    TableRelation = "Unit of Measure";
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    trigger OnDrillDown();
                    begin
                        IndentLine.RESET;
                        IndentLine.SETRANGE("Indent Req No", Rec."Document No.");
                        IndentLine.SETRANGE("Indent Req Line No", Rec."Line No.");
                        PAGE.RUNMODAL(0, IndentLine);
                    end;
                }
                field("Manufacturer Code"; Rec."Manufacturer Code")
                {
                    Caption = 'Vendor';
                    //TableRelation = "Item Vendor"."Vendor No." WHERE("Item No." = FIELD("Item No."));
                    ApplicationArea = All;
                    TableRelation = Vendor."No.";
                    ToolTip = 'Specifies the value of the Vendor field.';

                    /*trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemVendor: Record "Item Vendor";
                        Vendor: Record Vendor;
                    begin
                        ItemVendor.Reset();
                        ItemVendor.SetRange("Item No.", Rec."Item No.");
                        if ItemVendor.FindSet() then
                            if Page.RunModal(Page::"Item Vendor Catalog", ItemVendor) = Action::LookupOK then
                                Rec.Validate("Manufacturer Code", ItemVendor."Vendor No.");
                    end;*/

                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purchaser Code field.';
                }
                field("Spec Id"; rec."Spec Id")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Spec Id field.';
                }
                //B2BMSOn01Nov2022>>
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
                field("Variant Description"; Rec."Variant Description") //B2BSCM11JAN2024
                {
                    ApplicationArea = all;
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Variant Description field.';
                }
                field("Qty. Ordered"; Rec."Qty. Ordered")
                {
                    ApplicationArea = All;
                    Editable = false;//B2BSCM19SEP2023
                    ToolTip = 'Specifies the value of the Qty. Ordered field.';
                }
                field("Received Quantity"; Rec."Received Quantity")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Received Quantity field.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Remaining Quantity field.';
                }
                field("Qty. To Order"; Rec."Qty. To Order")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;//B2BSCM20SEP2023
                    ToolTip = 'Specifies the value of the Qty. To Order field.';
                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Vendor Min.Ord.Qty"; Rec."Vendor Min.Ord.Qty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Min.Ord.Qty field.';
                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")//B2BSSD20FEB2023
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 9 Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 9 Code field.';
                }
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Indent No. field.';
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Indent Line No. field.';
                }
                field("PO Vendor"; Rec."PO Vendor") //B2BVCOn20Mar2024
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Previous PO Vendor';
                    ToolTip = 'Specifies the value of the Previous PO Vendor field.';
                }
                field("PO Vendor Name"; Rec."PO Vendor Name")
                {
                    Caption = 'Previous Vendor Name';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Previous PO Date field.';
                }
                field("PO Order No."; Rec."PO Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Previous Order No.';
                    ToolTip = 'Specifies the value of the PO Order No. field.';
                }
                field("PO Order Date"; Rec."PO Order Date")
                {
                    Caption = 'Previous Order Date';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the PO Order Date field.';
                }
                field("Last Purchase Price"; Rec."Last Purchase Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Last Purchase Price field.';
                }
                field("Gst %"; Rec."Gst %")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Gst % field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Project Code';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Project Code field.';
                }

                //B2BMSOn01Nov2022<<
                field("Order No"; Rec."Order No")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order No field.';
                    trigger OnDrillDown();
                    var
                        PurchHeader: Record 38;
                        PurchLine: Record 39;
                    begin
                        //B2B.1.3
                        PurchLine.RESET;
                        PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SETRANGE(PurchLine."Indent No.", Rec."Document No.");
                        PurchLine.SETRANGE(PurchLine."Indent Line No.", Rec."Line No.");
                        IF PurchLine.FINDSET THEN
                            PAGE.RUNMODAL(0, PurchLine);
                        //B2B.1.3
                    end;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                    Caption = 'Select';
                    Editable = FieldEditableGVar;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = all;
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Line Type field.';
                }

                field("Indentor Description"; Rec."Indentor Description")//B2BSSD02Feb2023
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Indentor Description field.';
                }
                field("Carry out Action"; Rec."Carry out Action")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Carry out Action field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }

                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                    ApplicationArea = All;
                    Visible = false; //B2BMSOn10Oct2022
                    ToolTip = 'Specifies the value of the Payment Method Code field.';
                    trigger OnValidate();
                    begin
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RFQ No. field.';
                    Editable = false;
                }
                field("RFQ Date"; Rec."RFQ Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RFQ Date field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Doc&Attachments")
            {
                ApplicationArea = All;
                Image = Attachments;
                Caption = 'Attachments';
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    DocumentAttRec: Record "Document Attachment";
                    RecRef: RecordRef;
                    IndentLine: Record "Indent Line";
                begin
                    DocumentAttRec.Reset();
                    DocumentAttRec.SetRange("No.", Rec."Indent No.");
                    DocumentAttRec.SetRange("Line No.", Rec."Indent Line No.");
                    if DocumentAttRec.FindSet() then
                        Page.RunModal(50183, DocumentAttRec)
                    else begin
                        IndentLine.Get(Rec."Indent No.", Rec."Indent Line No.");
                        RecRef.GetTable(IndentLine);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                    CurrPage.Update();
                end;
            }
            //B2BSSD02Jan2023<<
            action("Item TechnicalSpec")
            {
                RunPageMode = View;
                ApplicationArea = All;
                Image = Import;
                Caption = 'Specification';
                RunObject = page TechnicalSpecifications;
                RunPageLink = "Document No." = field("Indent No."), "Line No." = field("Indent Line No.");
                ToolTip = 'Executes the Specification action.';
                trigger OnAction()
                var
                begin

                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        IndentReqHdr: Record "Indent Req Header";
    begin
        if IndentReqHdr.Get(Rec."Document No.") then
            if (IndentReqHdr.Status = IndentReqHdr.Status::Release) then
                FieldEditable := false
            else
                FieldEditable := true;
        if IndentReqHdr.Get(Rec."Document No.") then
            if IndentReqHdr.Type = IndentReqHdr.Type::Order then
                FieldEditableGVar := true
            else
                FieldEditableGVar := false;
    end;

    trigger OnAfterGetCurrRecord()
    var
        IndentReqHeader: Record "Indent Req Header";
    begin

    end;


    var
        CreateIndents: Record "Indent Requisitions";
        Indent: Text[1024];
        Carry: Integer;
        IndentLine: Record "Indent Line";
        PurchaseOrder: Record 38;
        Vendor: Record 99;
        FieldEditable: Boolean;
        FieldEditableGVar: Boolean;
        PurchaseLine: Record "Purchase Line";
}

