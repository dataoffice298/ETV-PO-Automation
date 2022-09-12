enumextension 50000 PurchaseDoc extends "Purchase Document Type"
{
    value(6; Enquiry)
    {
        Caption = 'Enquiry';
    }

}

//B2BMSOn12Sep2022>>
enumextension 50001 PurchaseCommentDoc extends "Purchase Comment Document Type"
{
    value(10; Indent)
    {
        CaptionML = ENU = 'Indent', ENN = 'Indent';
    }
    value(11; Enquiry)
    {
        CaptionML = ENU = 'Enquiry', ENN = 'Enquiry';
    }

}
//B2BMSOn12Sep2022<<