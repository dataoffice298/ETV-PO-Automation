pageextension 50100 PosPurchReceipt extends "Posted Purchase Receipt"
{
    layout
    {
        addlast(Invoicing)
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
            }
            field("Bill of Entry No"; Rec."Bill of Entry No")
            {
                ApplicationArea = All;
            }
            field("EPCG No."; Rec."EPCG No.")
            {
                ApplicationArea = all;
            }



        }

    }

    actions
    {
        addafter(Approvals)
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
                    RecRef: RecordRef;
                    PurchHdr: Record "Purchase Header";
                begin
                    if PurchHdr.get(PurchHdr."Document Type"::Order, Rec."Order No.") then begin
                        RecRef.GetTable(PurchHdr);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                end;
            }
        }
    }

}