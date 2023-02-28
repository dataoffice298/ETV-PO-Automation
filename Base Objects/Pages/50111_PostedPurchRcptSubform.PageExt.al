pageextension 50111 PostedPurchRcptSubform extends "Posted Purchase Rcpt. Subform"
{
    Editable = false;
    layout
    {
        addafter(Description)
        {
            //B2BVCOn03Oct22>>>
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                ApplicationArea = all;
            }
            //B2BVCOn03Oct22<<<
            field("Rejection Comments B2B"; "Rejection Comments B2B")
            {
                ApplicationArea = all;
            }
            field("Spec Id"; rec."Spec Id")
            {
                ApplicationArea = all;
            }
            field("Indentor Description"; Rec."Indentor Description")//B2BSSD07Feb2023
            {
                ApplicationArea = All;
                Caption = 'Indentor Description';
            }
            field(warranty; Rec.warranty)//B2BSSD10Feb2023
            {
                ApplicationArea = All;
                Caption = 'warranty';
            }
        }

    }
    //B2BSSD10Feb2023<<
    actions
    {
        addafter(ItemInvoiceLines)
        {
            action("Item TechnicalSpec")
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Specification';
                RunObject = page TechnicalSpecifications;
                RunPageLink = "Document No." = field("Indent No."), "Line No." = field("Indent Line No.");
            }
        }
        addafter("Item TechnicalSpec")
        {
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
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
                        DocumentAttachmentDetails.RunModal;
                    end;
                    CurrPage.Update();
                end;
            }
        }
    }

    //B2BSSD10Feb2023>>
}