table 50225 "Technical Specifications"//B2BSSD30Jan2023
{
    DataClassification = CustomerContent;
    Caption = 'Technical Specifications';

    fields
    {
        /*field(1; "No."; Code[50])
        {
            DataClassification = CustomerContent;
        }*/
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            //B2BSSD03Feb2023<<
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if "Document No." <> '' then
                    "Document Type" := "Document Type"::Indent;
            end;
            //B2BSSD03Feb2023>>
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Document Type"; Enum Technicalspec)
        {
            DataClassification = CustomerContent;
        }
        field(6; "S.No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'S.No.';

        }
        field(7; "Product Name"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Name';
        }
        field(8; Description; Code[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(9; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Total Amount" := Quantity * "Unit Price";
            end;

        }
        field(10; Units; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Units';
            TableRelation = "Item Unit of Measure".Code;
        }
        field(11; Make; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Make';
        }
        field(12; "CAT No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Make';
        }
        field(13; "Imported Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Imported Date';
        }
        field(14; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(15; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Uint Price';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Total Amount" := Quantity * "Unit Price";
            end;
        }
        field(16; "Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount';

        }
    }

    keys
    {
        key(PK; "Document No.", "Document Type", "Item No.", "S.No.", "Line No.")
        {
            Clustered = true;
        }
    }
    //B2BSSD31Jan2023<<
    trigger OnInsert()
    var
        Technicalspec: Record "Technical Specifications";
    begin
        Technicalspec.Reset();
        if Technicalspec.FindLast() then
            "S.No." := Technicalspec."S.No." + 1
        else
            "S.No." := 1
    end;
    //B2BSSD31Jan2023>>

    //B2BSSD30Jan2023<<
    var
        uplodMsg: Label 'Please Choose The Excel file';
        FileName: text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NoFileMsg: Label 'No excel File Found';
        ExcelImportSuccess: Label 'Excel File Imported Successfully';

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
        TechnicalSpec: Record "Technical Specifications";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRow: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        LineNo := 0;
        MaxRow := 0;
        TechnicalSpec.Reset();
        if TechnicalSpec.FindFirst() then
            LineNo := TechnicalSpec."Line No.";
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRow := TempExcelBuffer."Row No.";
        end;
        for RowNo := 2 to MaxRow Do begin
            LineNo := LineNo + 10000;

            TechnicalSpec.Init();
            //Evaluate(ExcelImport."Transaction Name", TransName1);
            TechnicalSpec."Line No." := LineNo;
            Evaluate(TechnicalSpec."S.No.", GetCellValue(RowNo, 1));
            Evaluate(TechnicalSpec."Product Name", GetCellValue(RowNo, 2));
            Evaluate(TechnicalSpec.Description, GetCellValue(RowNo, 3));
            Evaluate(TechnicalSpec.Quantity, GetCellValue(RowNo, 4));
            Evaluate(TechnicalSpec.Units, GetCellValue(RowNo, 5));
            Evaluate(TechnicalSpec.Make, GetCellValue(RowNo, 6));
            Evaluate(TechnicalSpec."CAT No.", GetCellValue(RowNo, 7));
            TechnicalSpec."Imported Date" := Today;
            TechnicalSpec.Insert();
        end;
        Message(ExcelImportSuccess);
    end;
    //B2BSSD30Jan2023>>
}