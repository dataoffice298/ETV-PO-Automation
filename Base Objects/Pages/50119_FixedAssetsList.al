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
                Caption = 'QR Print';
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
            action("Generate QR Code")
            {
                ApplicationArea = All;
                Caption = 'Generate QR Code';

                trigger OnAction()
                var
                    QRGenerator: Codeunit "QR Generator";
                    TempBlob: Codeunit "Temp Blob";
                    FixedAsset: Record "Fixed Asset";

                    IndentLine: Record "Indent Line";
                    FieldRef: FieldRef;
                    RecRef: RecordRef;
                    UserSetup: Record "User Setup";
                    CF: Char;
                    LF: Char;
                    QRText: Text;
                    QRDescription: Text;
                    Text0001: Label 'You dont have Following Permessions To Generate Qr Code';
                begin
                    if (UserSetup.Get(UserId)) and (UserSetup."QR Code" = false) then
                        Error(Text0001);

                    FixedAsset.Reset();
                    FixedAsset.SetRange("No.", rec."No.");
                    CurrPage.SetSelectionFilter(FixedAsset);
                    if FixedAsset.FindSet() then begin
                        repeat

                            RecRef.GetTable(FixedAsset);
                            CF := 150;
                            LF := 200;
                            QRText := FixedAsset."No." + ',' + 'Description : ' + FixedAsset.Description + ',' + 'Model No. : ' + FixedAsset."Model No." + ',' + 'Serial No. : ' + FixedAsset."Serial No." + ',' + 'Make. :' + FixedAsset.Make_B2B;//B2BSSD13JUN2023
                            QRGenerator.GenerateQRCodeImage(QRText, TempBlob);
                            FieldRef := RecRef.Field(FixedAsset.FieldNo("QR Code"));
                            TempBlob.ToRecordRef(RecRef, FixedAsset.FieldNo("QR Code"));
                            RecRef.Modify();
                        until FixedAsset.Next() = 0;
                    end;

                end;
            }
        }
    }

}