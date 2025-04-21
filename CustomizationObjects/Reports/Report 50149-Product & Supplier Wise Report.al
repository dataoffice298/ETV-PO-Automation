report 50149 "Product & Supplier Wise Report"
{
    Caption = 'Product & Supplier Wise Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            MaxIteration = 1;
            trigger OnAfterGetRecord()
            begin
                MakeExcelHeader();

                PurchHdrRec.Reset();
                PurchHdrRec.SetRange("Document Type", PurchHdrRec."Document Type"::Order);
                if TypeGvar = TypeGvar::PO then
                    if PONO <> '' then
                        PurchHdrRec.SetRange("No.", PONO);

                if TypeGvar = TypeGvar::Supplier then
                    if VNNO <> '' then
                        PurchHdrRec.SetRange("Buy-from Vendor No.", VNNO);

                if (FromDate <> 0D) or (ToDate <> 0D) then
                    PurchHdrRec.SetRange("Document Date", FromDate, ToDate)
                else
                    if (FromDate <> 0D) and (ToDate = 0D) then
                        PurchHdrRec.SetFilter("Document Date", '>=%1', FromDate)
                    else
                        if (FromDate = 0D) and (ToDate <> 0D) then
                            PurchHdrRec.SetFilter("Document Date", '<=%1', ToDate);

                if PurchHdrRec.FindSet() then
                    repeat
                        PurchLineRec.Reset();
                        PurchLineRec.SetRange("Document No.", PurchHdrRec."No.");
                        PurchLineRec.SetRange("Document Type", PurchLineRec."Document Type"::Order);
                        if ItemNO <> '' then
                            PurchLineRec.SetRange("No.", ItemNO);

                        if PurchLineRec.FindSet() then
                            repeat
                                IndentHdrRec.Reset();
                                if IndentHdrRec.Get(PurchLineRec."Indent No.") then
                                    IndentDateVar := IndentHdrRec."Document Date";
                                GetGSTAmounts(PurchLineRec);
                                if PurchLineRec.CancelOrder then
                                    POStatusVar := 'Cancelled'
                                else
                                    if PurchLineRec.ShortClosed then
                                        POStatusVar := 'Short Closed';

                                SNO += 1;
                                TempExcelBuffer.NewRow();
                                TempExcelBuffer.AddColumn(SNO, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn('ETPL', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchLineRec."Indent No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(IndentDateVar, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec.Purpose, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchLineRec."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec.Status, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec."Buy-from Vendor Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchLineRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchLineRec.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn(PurchLineRec."Unit Cost", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn((PurchLineRec.Quantity * PurchLineRec."Unit Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(CGSTPercent, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(CGSTAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(SGSTPercent, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(SGSTAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(IGSTPercent, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(IGSSTAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(((PurchLineRec.Quantity * PurchLineRec."Unit Cost") + (CGSTAmt + SGSTAmt + IGSSTAmt)), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec."Vendor Invoice No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec."Vendor Invoice Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(POStatusVar, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                            until PurchLineRec.Next() = 0;
                    until PurchHdrRec.Next() = 0;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                    field(TypeGvar; TypeGvar)
                    {
                        ApplicationArea = All;
                        Caption = 'Type';
                        OptionCaption = ' ,PO,Supplier,Product';
                    }
                    field(PONO; PONO)
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Order No.';
                        TableRelation = "Purchase Header"."No." where("Document Type" = filter(Order));
                        Enabled = TypeGvar = TypeGvar::PO;
                    }
                    field(VNNO; VNNO)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor No.';
                        TableRelation = Vendor."No.";
                        Enabled = TypeGvar = TypeGvar::Supplier;
                    }
                    field(ItemNO; ItemNO)
                    {
                        ApplicationArea = All;
                        Caption = 'Item No.';
                        TableRelation = Item."No.";
                        Enabled = TypeGvar = TypeGvar::Product;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        TempExcelBuffer.CreateNewBook(ReportLbl);
        TempExcelBuffer.WriteSheet(ReportLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(ReportLbl);
        TempExcelBuffer.OpenExcel();
    end;

    procedure MakeExcelHeader()
    begin
        HdrLblVar := ReportNameLbl + ' ' + Format(FromDate) + ' ' + 'to' + ' ' + Format(ToDate);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HdrLblVar, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Division', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Draft/Final PO No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Draft/Final PO Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO Status', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Product', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Unit Rate', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('PO Basic Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('CGST %', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('CGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('SGST%', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('SGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IGST%', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('IGST Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Invoice No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO Status', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure GetGSTAmounts(PurchaseLine: Record "Purchase Line")
    begin
        GSTSetup.Get();
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
                                SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision('SGST'));
                                SGSTPercent := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision('CGST'));
                                CGSTPercent := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                IGSSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision('IGST'));
                                IGSTPercent := TaxTransactionValue.Percent;
                            end;
                    end;
                    TotalGStAmt := SGSTAmt + CGSTAmt + IGSSTAmt;
                until TaxTransactionValue.Next() = 0;
        end;
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

    var
        FromDate, ToDate, IndentDateVar : Date;
        TypeGvar: Option " ","PO","Supplier","Product";
        SNO: Integer;
        PONO, VNNO, ItemNO, ComponentName : Code[60];
        HdrLblVar, POStatusVar : Text;
        SGSTPercent, SGSTAmt, CGSTAmt, CGSTPercent, IGSSTAmt, IGSTPercent, TotalGStAmt : Decimal;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PurchHdrRec: Record "Purchase Header";
        PurchLineRec: Record "Purchase Line";
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ItemRec: Record Item;
        IndentHdrRec: Record "Indent Header";
        SGSTLbl: Label 'GST';
        ReportLbl: Label 'Product & Supplier Wise Report';
        ReportNameLbl: Label 'STATEMENT SHOWING THE PURCHASES MADE FROM VARIOUS SUPPLIERS WITHOUT QUOTATION FOR RATIFICATION';
}