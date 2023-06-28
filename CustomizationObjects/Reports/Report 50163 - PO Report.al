
report 50163 "Po Report"//B2BSSD29DEC2022
{
    //>>CH15SEP2022
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'PO Report_50163';//B2BSSD29DEC2022
    ProcessingOnly = true;

    dataset
    {

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

    var

        ExcelBuffer1: Record "Excel Buffer" temporary;
        SNo: integer;
        StartDate: Date;
        EndDate: Date;


    trigger OnPostReport()
    begin
        PurchaseOrderExport();
    end;
   

    procedure PurchaseOrderExport()
    begin

        ExcelBuffer1.DeleteAll();
        MakeOrderExcelDataHeader();

        MakeOrderExcelDataBody();
        CreateExcelbook();

    end;



    PROCEDURE MakeOrderExcelDataHeader()
    BEGIN

        ExcelBuffer1.NewRow();
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.NewRow();
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('PO Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD29Dec2022
        ExcelBuffer1.NewRow();
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            ExcelBuffer1.AddColumn('PO: ' + Format(StartDate) + ' to' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD26Dec2022
        ExcelBuffer1.NewRow;
        ExcelBuffer1.AddColumn('S. NO.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('INDENT NUMBER', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('INDENT DATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('PO NUMBER', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('PO DATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('SUPPLIER NAME', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('UOM', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('AMOUNT', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Status', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD26APR2023
    END;

    PROCEDURE MakeOrderExcelDataBody()
    var

    BEGIN
        clear(SNo);

        PurchaseOrderLine.Reset();
        PurchaseOrderLine.SetFilter(Quantity, '<>%1', 0);
        PurchaseOrderLine.SetRange("Document Type", PurchaseOrderLine."Document Type"::Order);
        if PurchaseOrderLine.FindSet() then
            repeat
                PurchaseHeader.get(PurchaseOrderLine."Document Type", PurchaseOrderLine."Document No.");
                if (PurchaseHeader."Document Date" >= StartDate) and (PurchaseHeader."Document Date" <= EndDate) then begin
                    IndentRequsition.Reset();
                    IndentRequsition.SetRange("No.", PurchaseHeader."Indent Requisition No");
                    if IndentRequsition.FindFirst() then;
                    if (PurchaseOrderLine."Indent No." <> '') then begin
                        SNo += 1;
                        ExcelBuffer1.NewRow;
                        ExcelBuffer1.AddColumn(SNo, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Number);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."Indent No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(IndentRequsition."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Date);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."Document No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseHeader."Posting Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Date);
                        ExcelBuffer1.AddColumn(PurchaseHeader."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine.Description, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."Unit of Measure Code", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD22MAY2023
                        ExcelBuffer1.AddColumn(PurchaseOrderLine.Quantity, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Number);//B2BSSD26APR2022
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."Unit Cost", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Number);
                        ExcelBuffer1.AddColumn(Round(PurchaseOrderLine."Unit Cost" * PurchaseOrderLine.Quantity), FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD26APR2023
                        ExcelBuffer1.AddColumn(PurchaseHeader.Status, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD26APR2023
                    end
                end;
            until PurchaseOrderLine.Next() = 0;


    END;

    PROCEDURE CreateExcelbook()
    BEGIN
        ExcelBuffer1.CreateBookAndOpenExcel('', 'Po Report', '', COMPANYNAME, USERID);
    END;

    var
        PurchaseHeader: Record "Purchase Header";
        IndentRequsition: Record "Indent Req Header";
        PurchaseOrderLine: Record "Purchase Line";
        Reqdatelvar: Date;
        IndentHeader: Record "Indent Header";
        IndentRequsitionLine: Record "Indent Requisitions";
        PoStatus: Option Open,Released,Receive,Invoice;//B2BSSD24MAY2023
}