pageextension 50119 FixedAssetListExt extends "Fixed Asset List"
{

    layout
    {
        addafter(Description)//B2BSSD02AUG2023
        {
            field("available/Unavailable"; Rec."available/Unavailable")
            {
                ApplicationArea = All;
                Caption = 'Available/Unavailable';
            }
            field(Acquired1; Rec.Acquired)
            {
                ApplicationArea = All;
                Caption = 'Acquired';
            }
        }
    }
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