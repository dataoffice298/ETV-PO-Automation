page 50026 "Purchase Enquiry Subform"
{
    AutoSplitKey = true;
    Caption = 'Purchase Enquiry Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Enquiry));

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;

                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;
                    end;
                }
                field("Spec Id"; rec."Spec Id")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                }
                field("Indentor Description"; Rec."Indentor Description")//B2BSSD03Feb2023
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;

                }
                field("Variant Code"; Rec."Variant Code")//B2BSSD18APR2023
                {
                    ApplicationArea = All;
                }
                field("Variant Description"; Rec."Variant Description") //B2BSCM11JAN2024
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                    ApplicationArea = All;

                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;

                }
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Indent Req No"; Rec."Indent Req No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Indent Req Line No"; Rec."Indent Req Line No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }
    //B2BSSD07Feb2023<<
    actions
    {
        area(Processing)
        {
            action(Specification)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Specification';
                RunObject = page TechnicalSpecifications;
                RunPageLink = "Document No." = field("Indent No."), "Line No." = field("Indent Line No."),
                "Item No." = field("No.");
                trigger OnAction()
                var
                begin

                end;
            }
            //B2BSSD07Feb2023>>

            //B2BSSD17FEB2023<<
            action(AttachmentsPurEnq)
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
            //B2BSSD17FEB2023>>
        }


    }

    trigger OnAfterGetRecord();
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.Type := xRec.Type;
        CLEAR(ShortcutDimCode);
    end;

    var
        TransferExtendedText: Codeunit 378;
        ShortcutDimCode: array[8] of Code[20];

    procedure ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)", Rec);
    end;

    procedure CalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount", Rec);
    end;

    procedure ExplodeBOM();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM", Rec);
    end;

    procedure GetPhaseTaskStep();
    begin
        //CODEUNIT.RUN(CODEUNIT::"Purch.-Get Phase/...",Rec);//DM commented by
    end;

    procedure InsertExtendedText(Unconditionally: Boolean);
    begin
        IF TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            TransferExtendedText.InsertPurchExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
            UpdateForm(TRUE);
    end;

    procedure RecShowDimensions();
    begin
        Rec.ShowDimensions;
    end;

    procedure ItemChargeAssgnt();
    begin
        Rec.ShowItemChargeAssgnt;
    end;

    procedure RecOpenItemTrackingLines();
    begin
        Rec.OpenItemTrackingLines;
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure "---NAVIN---"();
    begin
    end;
    /*
        procedure ShowStrDetailsForm();
        var
            StrOrderLineDetails : Record "Structure Order Line Details";
            StrOrderLineDetailsForm : Page 16306;
        begin
            StrOrderLineDetails.RESET;
            StrOrderLineDetails.SETRANGE(Type,StrOrderLineDetails.Type::Purchase);
            StrOrderLineDetails.SETRANGE("Document Type","Document Type");
            StrOrderLineDetails.SETRANGE("Document No.","Document No.");
            StrOrderLineDetails.SETRANGE("Item No.","No.");
            StrOrderLineDetails.SETRANGE("Line No.","Line No.");
            StrOrderLineDetailsForm.SETTABLEVIEW(StrOrderLineDetails);
            StrOrderLineDetailsForm.RUNMODAL;
        end;
    *///Balu
    procedure "---B2B---"();
    begin
    end;

    procedure OpenAttachments();
    begin
        /*
        Attachment.RESET;
        Attachment.SETRANGE("Table ID",DATABASE::"Purchase Header");
        Attachment.SETRANGE("Document No.","Document No.");
        Attachment.SETRANGE("Document Type","Document Type");
        PAGE.RUN(PAGE::Form50038,Attachment);
        */

    end;

    local procedure NoOnAfterValidate();
    begin
        InsertExtendedText(FALSE);
        IF (Rec.Type = Rec.Type::"Charge (Item)") AND (Rec."No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
            CurrPage.SAVERECORD;
    end;
}

