reportextension 50001 PostedVoucherNew extends "Posted Voucher New1"
{
    dataset
    {

        add("G/L Entry")
        {
            column(PONarration; PONarration)
            {

            }
            column(InvoiceNum; InvoiceNum)
            {

            }
        }
        modify("G/L Entry")
        {
            trigger OnAfterAfterGetRecord()
            var
                VLEntry: Record "Vendor Ledger Entry";
            begin
                VLEntry.Reset();
                VLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                if VLEntry.FindFirst() then
                    PONarration := VLEntry."PO Narration";

                CLEAR(InvoiceNum);
                purInvheader.RESET;
                purInvheader.SETRANGE("No.", "Document No.");
                IF purInvheader.FINDFIRST THEN BEGIN
                    PurRcptheader.Reset();
                    PurRcptheader.SetRange("Order No.", purInvheader."Order No.");
                    if PurRcptheader.FindFirst() then
                        InvoiceNum := purInvheader."Vendor Invoice No." + '  Date : ' + FORMAT(PurRcptheader."Vendor Invoice Date") + '  Purchase Invoice Date :' + Format((purInvheader."Vendor Invoice Date"));
                end;
            end;
        }
    }

    rendering
    {
        layout(PostedVoucherNew)
        {
            Type = RDLC;
            Caption = 'Posted Voucher New';
            LayoutFile = './Posted Voucher1.rdl';
        }
    }

    var
        PONarration: Code[50];
        InvoiceNum: Text;
        purInvheader: Record "Purch. Inv. Header";
        PurRcptheader: Record "Purch. Rcpt. Header";

}