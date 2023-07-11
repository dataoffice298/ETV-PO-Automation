pageextension 50119 FixedAssetListExt extends "Fixed Asset List"
{


    actions
    {
        addafter(Details)
        {
            action("generate qr codes")
            {
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                Caption = 'Print QR codes';
                trigger OnAction()
                var
                    Fixedasset: Record "Fixed Asset";
                    FixedassetList: Page "Fixed Asset List";
                    RefRec: RecordRef;
                    SelectionMgnt: Codeunit SelectionFilterManagement;
                begin
                    Fixedasset.Reset();
                    CurrPage.SetSelectionFilter(Fixedasset);
                    Report.RunModal(Report::QRReport, true, false, Fixedasset);
                end;

            }
        }
    }

}