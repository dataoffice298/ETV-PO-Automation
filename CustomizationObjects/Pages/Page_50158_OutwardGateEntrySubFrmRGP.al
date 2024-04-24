page 50158 "Outward Gate Entry SubFrm-RGP"
{
    Caption = 'RGP-OUTWARD Subform';
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Gate Entry Line_B2B";



    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = ALL;
                    OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Item,Fixed Asset,Others,Indent';

                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = ALL;
                    /*trigger OnLookup(var Text: Text): Boolean
                    var
                        IndentHdt: Record "Indent Header";
                        FA: record "Fixed Asset";
                        ItemLRec: record Item;
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                        TransShptHeader: Record "Transfer Shipment Header";
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                    begin
                        if GateEntryHeader.GET(Rec."Entry Type", Rec."Type", Rec."Gate Entry No.") then;
                        case Rec."Source Type" of

                            Rec."Source Type"::"Fixed Asset":
                                begin
                                    FA.Reset();
                                    FA.SetRange(Blocked, false);
                                    FA.FilterGroup(0);
                                    if PAGE.RUNMODAL(0, FA) = ACTION::LookupOK then begin
                                        Rec."Source No." := FA."No.";
                                        Rec."Source Name" := FA.Description;
                                        Rec.Description := FA.Description;
                                        Rec.ModelNo := FA."Model No.";//B2BSSD04APR2023
                                        Rec.SerialNo := FA."Serial No.";//B2BSSD04APR2023
                                    end;
                                end;
                            Rec."Source Type"::Item:
                                begin
                                    ItemLRec.Reset();
                                    ItemLRec.SetRange(Blocked, false);
                                    ItemLRec.FilterGroup(0);
                                    if PAGE.RUNMODAL(0, ItemLRec) = ACTION::LookupOK then begin
                                        Rec."Source No." := ItemLRec."No.";
                                        Rec."Source Name" := ItemLRec.Description;
                                        Rec.Description := ItemLRec.Description;
                                        Rec."Unit of Measure" := ItemLRec."Base Unit of Measure";
                                    end;
                                end;
                            Rec."Source Type"::"Transfer Shipment":
                                begin
                                    TransShptHeader.RESET;
                                    TransShptHeader.FILTERGROUP(2);
                                    TransShptHeader.SETRANGE("Transfer-from Code", GateEntryHeader."Location Code");
                                    TransShptHeader.FILTERGROUP(0);
                                    if PAGE.RUNMODAL(0, TransShptHeader) = ACTION::LookupOK then begin
                                        Rec."Source No." := TransShptHeader."No.";
                                        Rec."Source Name" := TransShptHeader."Transfer-to Name";
                                    end;
                                end;
                            Rec."Source Type"::Indent:
                                begin
                                    IndentHdt.Reset();
                                    IndentHdt.SetRange("Released Status", IndentHdt."Released Status"::"Pending Approval");
                                    IndentHdt.FilterGroup(0);
                                    if PAGE.RUNMODAL(0, ItemLRec) = ACTION::LookupOK then begin
                                        Rec."Source No." := IndentHdt."No.";
                                        Rec."Source Name" := IndentHdt.Description;
                                    end;
                                end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        SalesShipHeader: Record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                        ReturnShipHeader: Record "Return Shipment Header";
                        TransHeader: Record "Transfer Header";
                        TransShptHeader: Record "Transfer Shipment Header";
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                        FA: Record "Fixed Asset";
                    BEGIN
                        if Rec."Source Type" = 0 then
                            ERROR(Text16500, Rec.FIELDCAPTION("Line No."), Rec."Line No.");
                        if Rec."Source No." <> xRec."Source No." then
                            Rec."Source Name" := '';
                        if Rec."Source No." = '' then begin
                            Rec."Source Name" := '';
                            exit;
                        end;
                    end;*/
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;

                    //B2bSSD25APR2023<<
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if rec."Source Type" = Rec."Source Type"::Item then begin
                            if Rec.Quantity > Rec."Avail Qty" then
                                Error('Quantity should not be greater than Available Quantity');
                        end;
                    end;
                    // B2bSSD25APR2023>>
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                }
                // field("Expected Receipt Date"; Rec."Expected Receipt Date")
                // {
                //     ApplicationArea = all;
                // }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                //B2bSSD22Dec2022<<
                field(Variant; Rec.Variant)
                {
                    ApplicationArea = All;
                }
                field(ModelNo; Rec.ModelNo)
                {
                    ApplicationArea = All;
                }
                field(SerialNo; Rec.SerialNo)
                {
                    ApplicationArea = All;
                }
                //B2bSSD22Dec2022>>
                //B2BVCOn03April2024 >>
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order No.';
                    Editable = false;
                }
                field("InWard Gate Entry No."; Rec."InWard Gate Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Inward Gate Entry No.';
                    Editable = false;
                }
                //B2BVCOn03April2024 <<
            }
        }
    }
    //B2BSSD30JUN2023>>
    actions
    {
        area(Processing)
        {
            group("Import Excel")
            {
                action(Import)
                {
                    ApplicationArea = All;
                    Caption = 'Import';
                    Image = ImportExcel;
                    trigger OnAction()
                    var
                    begin
                        FixedAssetsReadExcelSheet();
                        ImportExcelData();
                    end;
                }
            }
        }
    }
    //Excel Import Start......
    local procedure FixedAssetsReadExcelSheet()
    var
        FileManagement: Codeunit "File Management";
        Istream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(uplodMsg, '', '', FromFile, Istream);
        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := ExcecllBuffer.SelectSheetsNameStream(Istream)
        end else
            Error(NoFileMsg);
        ExcecllBuffer.Reset();
        ExcecllBuffer.DeleteAll();
        ExcecllBuffer.OpenBookStream(Istream, SheetName);
        ExcecllBuffer.ReadSheet();
    end;

    procedure GetCellValue(RowNo: Integer; ColNo: Integer): Text
    begin
        ExcecllBuffer.Reset();
        if ExcecllBuffer.Get(RowNo, ColNo) then
            exit(ExcecllBuffer."Cell Value As Text")
        else
            exit('');
    end;

    local procedure ImportExcelData()
    var
        RGPOutwarExcelImport: Record "Gate Entry Line_B2B";
        //ExcelImport: Record "Excel Import Buffer";
        RowNo: Integer;
        ColNo: Integer;
        MaxRow: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        LineNo := 0;
        MaxRow := 0;

        RGPOutwarExcelImport.Reset();
        if RGPOutwarExcelImport.FindLast() then;


        ExcecllBuffer.Reset();
        if ExcecllBuffer.FindLast() then begin
            MaxRow := ExcecllBuffer."Row No.";
        end;
        // LineNo := 10000;
        for RowNo := 2 to MaxRow Do begin
            //RGpNo
            Evaluate(RGpNo, GetCellValue(RowNo, 10));

            RgpOutwardEntry.Reset();
            RgpOutwardEntry.SetRange("Entry Type", RgpOutwardEntry."Entry Type"::Outward);
            RgpOutwardEntry.SetRange("No.", RGpNo);
            if RgpOutwardEntry.FindFirst() then begin
                RGPOutNo := RgpOutwardEntry."No.";
                //repeat
                RGPOutwarExcelImport1.Reset();
                RGPOutwarExcelImport1.SetRange("Entry Type", RgpOutwardEntry."Entry Type"::Outward);
                RGPOutwarExcelImport1.SetRange("Gate Entry No.", RGpNo);
                if RGPOutwarExcelImport1.FindLast() then
                    LineNo := RGPOutwarExcelImport1."Line No." + 10000
                else
                    LineNo := 10000;

                RGPOutwarExcelImport.Init();
                RGPOutwarExcelImport."Entry Type" := RGPOutwarExcelImport."Entry Type"::Outward;
                RGPOutwarExcelImport.Type := RgpOutwardEntry.Type::RGP;
                RGPOutwarExcelImport."Gate Entry No." := RGPOutNo;
                RGPOutwarExcelImport."Line No." := LineNo;
                //  LineNo += 10000;
                Evaluate(RGPOutwarExcelImport."Source Type", GetCellValue(RowNo, 1));
                RGPOutwarExcelImport.Validate("Source Type");
                Evaluate(RGPOutwarExcelImport."Source No.", GetCellValue(RowNo, 2));
                RGPOutwarExcelImport.Validate("Source No.");
                Evaluate(RGPOutwarExcelImport."Source Name", GetCellValue(RowNo, 3));
                RGPOutwarExcelImport.Validate("Source Name");

                Evaluate(RGPOutwarExcelImport.Description, GetCellValue(RowNo, 4));
                if RGPOutwarExcelImport."Source Type" = RGPOutwarExcelImport."Source Type"::"Fixed Asset" then begin
                    //Evaluate(RGPOutwarExcelImport.Quantity, GetCellValue(RowNo, 5));
                    RGPOutwarExcelImport.Validate(Quantity, 1);
                end else
                    if RGPOutwarExcelImport."Source Type" = RGPOutwarExcelImport."Source Type"::Item then
                        Evaluate(RGPOutwarExcelImport.Quantity, GetCellValue(RowNo, 5));

                Evaluate(RGPOutwarExcelImport."Unit of Measure", GetCellValue(RowNo, 6));
                Evaluate(RGPOutwarExcelImport.Variant, GetCellValue(RowNo, 7));
                RGPOutwarExcelImport.Validate(Variant);

                Evaluate(RGPOutwarExcelImport.ModelNo, GetCellValue(RowNo, 8));
                RGPOutwarExcelImport.Validate(ModelNo);

                Evaluate(RGPOutwarExcelImport.SerialNo, GetCellValue(RowNo, 9));
                RGPOutwarExcelImport.Validate(SerialNo);

                //  Evaluate(RGPOutwarExcelImport."Gate Entry No.", GetCellValue(RowNo, 10));
                //   RGPOutwarExcelImport.Validate("Gate Entry No.");

                RGPOutwarExcelImport.Insert();
                // until RGPOutwarExcelImport.Next() = 0;
            end;
        end;
        Message(ExcelImportSuccess);
    end;
    //Excel Import End....
    var
        GatEntHdrGRec: Record "Gate Entry Header_B2B";
        ExcecllBuffer: Record "Excel Buffer" temporary;
        uplodMsg: Label 'Please Choose The Excel file';
        FileName: text[100];
        SheetName: Text[100];
        NoFileMsg: Label 'No excel File Found';
        ExcelImportSuccess: TextConst ENN = 'Excel File Imported Successfully';
        RgpOutwardEntry: Record "Gate Entry Header_B2B";
        RGPOutwarExcelImport1: Record "Gate Entry Line_B2B";
        RGPOutNo: Code[20];
        RGpNo: Code[20];
        LineNo: Integer;

}

