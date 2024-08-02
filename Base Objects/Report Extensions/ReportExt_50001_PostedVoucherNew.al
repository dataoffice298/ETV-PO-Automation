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
            column(DocumentDate; DocumentDate)
            { }
        }
        modify("G/L Entry")
        {
            trigger OnAfterAfterGetRecord()
            var
                VLEntry: Record "Vendor Ledger Entry";
            begin
                Clear(DocumentDate);
                VLEntry.Reset();
                VLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                if VLEntry.FindFirst() then begin
                    PONarration := VLEntry."PO Narration";
                    DocumentDate := 'Date : ' + Format(VLEntry."Document Date");

                    CLEAR(InvoiceNum);
                    purInvheader.RESET;
                    purInvheader.SETRANGE("No.", VLEntry."Document No.");
                    IF purInvheader.FINDFIRST THEN BEGIN
                        //InvoiceNum := purInvheader."Vendor Invoice No." + '  Date : ' + FORMAT(DocumentDate) + '  Purchase Invoice Date :' + Format((purInvheader."Vendor Invoice Date"));
                        InvoiceNum := 'Invoice No.:' + purInvheader."Vendor Invoice No." + '  Invoice Date :' + Format((purInvheader."Vendor Invoice Date"));
                    end;
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
        DocumentDate: Text;

}