pageextension 50081 DocAttachmentsEXT extends "Document Attachment Details"
{
    layout
    {
        addafter("Attached Date")
        {
            field(Select; Rec.Select)
            {
                ApplicationArea = All;
                Caption = 'Select';
            }
        }
    }

    actions
    {
        modify(Preview)
        {
            Enabled = true;
        }
    }
}