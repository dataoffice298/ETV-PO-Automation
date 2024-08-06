pageextension 50114 PurchQuoteSubformExtB2B extends "Purchase Quote Subform"
{
    layout
    {
        addbefore("Shortcut Dimension 1 Code")
        {
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

            field(warranty; Rec.warranty)//B2BSSD11Feb2023
            {
                ApplicationArea = All;
                Caption = 'warranty';
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Caption = 'Project Code';
            }
        }
        addafter(Type)
        {
            field("Spec Id"; rec."Spec Id")
            {
                ApplicationArea = all;
            }
            field("Indentor Description"; Rec."Indentor Description")//B2BSSD03Feb2023
            {
                ApplicationArea = All;
            }
        }
        addafter("Variant Code")
        {
            field("Variant Description"; "Variant Description") //B2BSCM11JAN2024
            {
                ApplicationArea = All;
            }
        }

    }
    //B2BSSD07Feb2023<<
    actions
    {
        addlast("&Line")
        {
            action(Specification)
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Specification';
                RunObject = page TechnicalSpecifications;
                RunPageLink = "Document No." = field("Indent No."), "Line No." = field("Indent Line No.");
            }
        }

        //B2BSSD17FEB2023<<
        modify(DocAttach)
        {
            Visible = false;
        }
        addafter(Specification)
        {
            action(AttachmentsPurQuo)
            {
                ApplicationArea = All;
                Image = Attachments;
                Visible = true;
                Caption = 'Attachements';
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
                end;
            }
            action("Create Variant Lines")
            {
                ApplicationArea = All;
                Image = Line;
                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                    ItmeVariant: Record "Item Variant";
                    LineNo: Integer;
                    TextLbl: Label 'Variant Lines Inserted.';
                    ErrorMsg: Label ' No Variants in Item No %1, Line No %2';
                begin
                    LineNo := 1000;
                    ItmeVariant.Reset();
                    ItmeVariant.SetRange("Item No.", Rec."No.");
                    if ItmeVariant.FindSet() then begin
                        repeat
                            if ItmeVariant.Code <> Rec."Variant Code" then begin
                                PurchLine.Init();
                                PurchLine.TransferFields(Rec);
                                PurchLine."Line No." := Rec."Line No." + LineNo;
                                PurchLine."Variant Code" := ItmeVariant.Code;
                                PurchLine."Variant Description" := ItmeVariant.Description;
                                PurchLine.Insert(true);
                                LineNo += 1000;
                            end;
                        until ItmeVariant.Next = 0;
                        Message(TextLbl);
                    end else
                        Error(ErrorMsg, Rec."No.", Rec."Line No.");
                end;
            }
        }
        //B2BSSD17FEB2023>>
    }
    //B2BSSD07Feb2023>>
}