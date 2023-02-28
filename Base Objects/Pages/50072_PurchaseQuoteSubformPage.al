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
        }
        //B2BSSD17FEB2023>>
    }
    //B2BSSD07Feb2023>>
}