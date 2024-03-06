pageextension 50109 PostedSaleInvExtB2B extends "Posted Sales Invoice"
{
    layout
    {
        addlast("Shipping and Billing")
        {
            field("LC No."; Rec."LC No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Invoice")
        {
            action(DocAttachCust)
            {
                ApplicationArea = All;
                Caption = 'Attachments1';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
        }
    }

    var
        myInt: Integer;
}