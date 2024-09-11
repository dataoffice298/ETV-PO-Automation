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
        //B2BVC >>
        addafter("C&opy Fixed Asset")
        {
            action("Update FA Location")
            {
                ApplicationArea = All;
                Caption = 'Update FA Location';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
        }
        //B2BVC <<
    }
    procedure ReadExcelSheet()
    var
        FileManagement: Codeunit "File Management";
        Istream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(uplodMsg, '', '', FromFile, Istream);
        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(Istream)
        end else
            Error(NoFileMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(Istream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    procedure GetCellValue(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value As Text")
        else
            exit('');
    end;

    procedure ImportExcelData()
    var
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRow: Integer;
        FANo: Code[20];
        FALocation: Code[10];
        FASubLoc: Code[20];
        PhysicalLoc: Text[50];
    begin
        RowNo := 0;
        ColNo := 0;
        LineNo := 0;
        MaxRow := 0;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRow := TempExcelBuffer."Row No.";
        end;
        for RowNo := 2 to MaxRow do begin
            Evaluate(FANo, GetCellValue(RowNo, 1));
            Evaluate(FALocation, GetCellValue(RowNo, 2));
            Evaluate(FASubLoc, GetCellValue(RowNo, 3));
            Evaluate(PhysicalLoc, GetCellValue(RowNo, 4));
            FixedAsset.Reset();
            FixedAsset.SetRange("No.", FANo);
            if FixedAsset.FindFirst() then begin
                FALocationRec.Reset();
                FALocationRec.SetRange(Code, FALocation);
                if FALocationRec.FindFirst() then
                    FixedAsset."FA Location Code" := FALocation;

                FASubLocation.Reset();
                FASubLocation.SetRange("Location Code", FixedAsset."FA Location Code");
                FASubLocation.SetRange("Sub Location Code", FASubLoc);
                if FASubLocation.FindFirst() then
                    FixedAsset."FA Sub Location" := FASubLoc;

                FixedAsset."Physical-Location" := PhysicalLoc;
                FixedAsset.Modify();
            end;
        end;
        Message(ExcelImportSuccess);
    end;

    var
        uplodMsg: Label 'Please Choose The Excel file';
        FileName: text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NoFileMsg: Label 'No excel File Found';
        ExcelImportSuccess: Label 'Excel File Imported Successfully';
        FixedAsset: Record "Fixed Asset";
        FALocationRec: Record "FA Location";
        FASubLocation: Record "FA Sub Location";

}