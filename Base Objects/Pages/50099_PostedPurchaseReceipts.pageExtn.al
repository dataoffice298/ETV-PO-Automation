pageextension 50099 PostedPurchaseReceiptExt extends "Posted Purchase Receipts"
{
    layout
    {
        /* addlast(Control1)
         {
             field("LC No."; "LC No.")
             {
                 ApplicationArea = All;
             }
             field("Bill of Entry No"; "Bill of Entry No")
             {
                 ApplicationArea = All;
             }
         }*/

        // Add changes to page layout here
    }

    actions
    {
        addafter(Dimensions)
        {
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    Message('Hi');
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;

                end;
            }
        }
        /*  var
              myInt: Integer;*/
    }
}