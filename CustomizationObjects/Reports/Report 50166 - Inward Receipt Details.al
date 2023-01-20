report 50166 "Inward Receipt Details"
{
    Caption = 'Inward Receipt_50166';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Posted Gate Entry Header_B2B"; "Posted Gate Entry Header_B2B")
        {
            DataItemTableView = WHERE("Entry Type" = const(Inward),
                                      Type = FILTER('RGP'));//Baluon30Nov2022
            dataitem("Posted Gate Entry Line_B2B"; "Posted Gate Entry Line_B2B")
            {
                DataItemLink = "Entry Type" = field("Entry Type"), "Gate Entry No." = field("No.");

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    Vendor: Record Vendor;
                    Users: Record User;
                    PurchInvNo: Code[20];
                    PurchLine: Record "Purchase Line";
                    PurchaseHdr: Record "Purchase Header";
                    VATAmount: Decimal;
                    DocumentTotals: Codeunit "Document Totals";
                begin
                    SNo += 1;
                    Clear(CGSTAmt);
                    Clear(SGSTAmt);
                    Clear(IGSSTAmt);
                    WindPa.Update(1, "Gate Entry No.");

                    //B2BSSD28Dec2022<<
                    PurchaseHdr.Reset();
                    PurchaseHdr.SetRange("No.", "Source No.");
                    if PurchaseHdr.FindSet() then begin
                        PurchLine.Reset();
                        PurchLine.SetRange("Document No.", PurchaseHdr."No.");
                        PurchLine.SetRange("Document Type", PurchaseHdr."Document Type");
                        if PurchLine.FindSet() then;
                    end;
                    //B2BSSD28Dec2022<<
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Gate Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchaseHdr."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchaseHdr."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchaseHdr."Vendor Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchaseHdr."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(PurchLine."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchLine."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Line_B2B"."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Line_B2B".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchLine."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    //TempExcelBuffer.AddColumn(PurchInvLine."VAT %", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    //TempExcelBuffer.AddColumn(VATAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    //  TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    //TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    //TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    // TempExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchLine."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(CGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(SGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(IGSSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    //TempExcelBuffer.AddColumn(TDSAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchLine."Line Amount", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    //TempExcelBuffer.AddColumn(TotAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(TotAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchaseHdr."Import Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchaseHdr."EPCG Scheme", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchaseHdr."EPCG No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchaseHdr."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                end;
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Document Date", '%1..%2', StartDate, EndDate); //B2BSSDOn07Dec2022
                Clear(SNo);
                MakeExcelHeaders();
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Date Filters")
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = all;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    begin
        TempExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin
        WindPa.CLOSE();
        TempExcelBuffer.CreateBookAndOpenExcel('', 'Inward Receipt', '', COMPANYNAME, USERID);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        WindPa: Dialog;
        SNo: Integer;

    procedure MakeExcelHeaders()
    begin
        WindPa.OPEN('Processing #1###############');
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Inward Receipt Details', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('Inward Receipt: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INWARD NO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INWARD DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECEIPT DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SUPPLIER NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INVOICE NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INVOICE DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CATEGORY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QTY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('VAT%', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('VAT AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('CST%', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('CST AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('EXCISE%', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('EXCISE AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('DISCOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //TempExcelBuffer.AddColumn('TDS', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BASIC AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TOTAL AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('NARRATION', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IMPORT STATUS', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EPCG SHEME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('REFERENCE NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure GetGSTAmounts(TaxTransactionValue: Record "Tax Transaction Value";
    PurchaseLine: Record "Purchase Line";
    GSTSetup: Record "GST Setup");
    var
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        ComponentName := GetComponentName(PurchaseLine, GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                SGSTPer := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                IGSSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                IGSTPer := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
       GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl;
        exit(ComponentName)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
        GSTSetup.TestField("GST Tax Type");
        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;

    local procedure GetGSTPercents(PurchaseLine: Record "Purchase Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        ComponentName := GetComponentName(PurchaseLine, GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    GSTPercent += TaxTransactionValue.Percent;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    var
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
        IGSSTAmt: Decimal;
        SGSTPer: Decimal;
        CGSTPer: Decimal;
        IGSTPer: Decimal;
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        GSTPercent: Decimal;
        GSTPerText: Text;
        GSTText: Label 'GST @%1% on S.No. ';
        I: Integer;
        GSTAmountLine: array[10] of Decimal;
        LineSNo: Text[30];
        TotalGSTAmount: Decimal;
        PurchLineGST: Record "Purchase Line";
        GSTGroupCode: Code[10];
        NextLoop: Boolean;
        TotAmt: Decimal;
}
