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
                DataItemTableView = where("Source Type" = filter(<> Description)); //B2BSCM27SEP2023

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    Vendor: Record Vendor;
                    Users: Record User;
                    PurchInvNo: Code[20];
                    VATAmount: Decimal;
                    DocumentTotals: Codeunit "Document Totals";
                    INVOICENO: Code[30];
                    INVOICEDate: Date;
                    SUPPLIERNAME: Text[50];
                    BasicAmount: Decimal;
                    BasePercent: Decimal;
                    ImporType: Text;



                begin
                    // SNo += 1;    //B2BSCM27SEP2023>>               
                    Clear(CGSTAmt);
                    Clear(SGSTAmt);
                    Clear(IGSSTAmt);
                    Clear(TotalAmount);    //B2BSCM27SEP2023<<
                    WindPa.Update(1, "Gate Entry No.");
                    if SourceNoGvar <> "Source No." then begin
                        SourceNoGvar := "Source No.";
                        //B2BSSD28Dec2022<<
                        PurchasRecpteHdr.Reset();
                        // PurchasRecpteHdr.SetRange("Document Type", PurchasRecpteHdr."Document Type"::Order);
                        PurchasRecpteHdr.SetRange("Order No.", "Posted Gate Entry Header_B2B"."Purchase Order No.");
                        if PurchasRecpteHdr.FindFirst() then begin
                            INVOICENO := PurchasRecpteHdr."Vendor Invoice No.";  //B2BSCM27SEP2023
                            INVOICEDate := PurchasRecpteHdr."Vendor Invoice Date";  //B2BSCM27SEP2023
                            SUPPLIERNAME := PurchasRecpteHdr."Buy-from Vendor Name";  //B2BSCM27SEP2023
                            if PurchasRecpteHdr."Import Type" = PurchasRecpteHdr."Import Type"::Import then
                                ImporType := 'Import';
                            if PurchasRecpteHdr."Import Type" = PurchasRecpteHdr."Import Type"::Indigenous then
                                ImporType := 'Indigenous';

                            GSTSetup.get();  //B2BSCM27SEP2023
                            PurchRecptLine.Reset();
                            PurchRecptLine.SetRange("Document No.", PurchasRecpteHdr."No.");
                            //   PurchRecptLine.SetRange("Document Type", PurchasRecpteHdr."Document Type"::Order);
                            //   PurchRecptLine.SetFilter("No.", '<>%1', '');
                            PurchRecptLine.setrange("Line No.", "Posted Gate Entry Line_B2B"."Line No.");
                            if PurchRecptLine.FindSet() then begin
                                //GetGSTAmounts(TaxTransactionValue, PurchRecptLine, GSTSetup);


                                BasicAmount := PurchRecptLine."Direct Unit Cost" * "Posted Gate Entry Line_B2B".Quantity;
                                // if PurchRecptLine."Line Discount %" <> 0 then
                                //  BasePercent := (BasicAmount / 100) * PurchRecptLine."Line Discount %");
                                BasePercent := (BasicAmount / 100) * PurchRecptLine."Line Discount %";
                                TotalAmount := BasicAmount - BasePercent;



                            end;
                            // repeat
                            //Clear(IGSSTAmt);
                            // GetGSTAmounts(TaxTransactionValue, PurchRecptLine, GSTSetup);
                            // TotalAmount := BasicAmount - PurchRecptLine."Line Discount %";

                            //B2BSSD14APR2023
                            //  until PurchRecptLine.Next() = 0;
                        end;
                    end;
                    //B2BSSD03APR2023<<
                    if Item.Get("Source No.") then;
                    if PurchasRecpteHdr."No." = '' then
                        CurrReport.Skip()
                    else
                        SNo += 1;
                    //B2BSSD03APR2023>>
                    //B2BSSD28Dec2022>>

                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Gate Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    //B2BSSD03APR2023<<
                    TempExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Receipt Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(SUPPLIERNAME, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Challan No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Header_B2B"."Challan Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD03APR2023
                    TempExcelBuffer.AddColumn("Posted Gate Entry Line_B2B"."Source No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Line_B2B"."Source Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    //B2BSSD03APR2023>>
                    TempExcelBuffer.AddColumn("Posted Gate Entry Line_B2B"."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Posted Gate Entry Line_B2B".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchRecptLine."Direct Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(BasePercent, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(BasicAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(TotalAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(PurchRecptLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchasRecpteHdr."Import Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchasRecpteHdr."EPCG Scheme", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(PurchasRecpteHdr."Order No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
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
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = all;
                        Caption = 'END Date';
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
        TempExcelBuffer.AddColumn('DISCOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BASIC AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TOTAL AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('NARRATION', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IMPORT STATUS', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EPCG SHEME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('REFERENCE NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure GetGSTAmounts(TaxTransactionValue: Record "Tax Transaction Value";
    PurchaseLine: Record "Purch. Rcpt. Line";
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

    local procedure GetComponentName(PurchaseLine: Record "Purch. Rcpt. Line";
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

    /*   local procedure GetGSTPercents(PurchaseLine: Record "Purchase Line")
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
       end;*/

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
        PurchRecptLineGST: Record "Purch. Rcpt. Line";
        GSTGroupCode: Code[10];
        NextLoop: Boolean;
        TotalAmount: Decimal;
        SourceNoGvar: Text;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        WindPa: Dialog;
        SNo: Integer;
        PurchRecptLine: Record "Purch. Rcpt. Line";
        PurchasRecpteHdr: Record "Purch. Rcpt. Header";
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
}
