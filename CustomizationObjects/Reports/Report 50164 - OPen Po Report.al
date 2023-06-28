
report 50164 "OPen Po Report"//>>CH15SEP2022
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Open Po Report_50164';//B2BSSD29DEC2022
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
                //B2BSSD29Dec2022<<
                group("Date Filter")
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;

                    }
                }
            }
            //B2BSSD29Dec2022>>
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
        ExcelBuffer1.AddColumn('Open PO Report', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.NewRow();
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            ExcelBuffer1.AddColumn('Open PO: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.NewRow;
        ExcelBuffer1.AddColumn('SL NO.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('INDENT NUMBER', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('INDENT DATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('PO NUMBER', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('PO DATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('SUPPLIER NAME', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('UOM', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('QTY', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('AMOUNT', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Status', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
    END;

    PROCEDURE MakeOrderExcelDataBody()
    var
        IndentRequsition: Record "Indent Req Header";
        PurchaseHeader: Record "Purchase Header";
        PurchaseOrderLine: Record "Purchase Line";
        indentHeader: Record "Indent Header";
    BEGIN
        clear(SNo);
        PurchaseOrderLine.Reset();
        PurchaseOrderLine.SetRange("Document Type", PurchaseOrderLine."Document Type"::Order);
        PurchaseOrderLine.SetFilter("Qty. to Receive", '>%1', 0);//B2BSSD29MAR2023
        //PurchaseOrderLine.SetFilter("Indent No.", '<>%1', '');//B2BSSD29APR2023
        if PurchaseOrderLine.FindSet() then
            repeat
                PurchaseHeader.get(PurchaseOrderLine."Document Type", PurchaseOrderLine."Document No.");
                if PurchaseHeader.Status = purchaseHeader.Status::Released then begin//B2BSSD26APR2023
                    if (PurchaseHeader."Document Date" >= StartDate) and (PurchaseHeader."Document Date" <= EndDate) then begin
                        if indentHeader.Get(PurchaseOrderLine."Indent No.") then;//B2BSSD26APR2023
                        SNo += 1;
                        ExcelBuffer1.NewRow;
                        ExcelBuffer1.AddColumn(SNo, FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."Indent No.", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD30Dec2022
                        ExcelBuffer1.AddColumn(indentHeader."Document Date", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."Document No.", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseHeader."Posting Date", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseHeader."Buy-from Vendor Name", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."No.", FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine.Description, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."Unit of Measure Code", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD22MAY2023
                        ExcelBuffer1.AddColumn(PurchaseOrderLine."Qty. to Receive", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD29Dec2022
                        ExcelBuffer1.AddColumn(Abs(PurchaseOrderLine."Unit Cost"), FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(Round(Abs(PurchaseOrderLine."Unit Cost" * PurchaseOrderLine."Qty. to Receive (Base)")), FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
                        ExcelBuffer1.AddColumn(PurchaseHeader.Status, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);//B2BSSD26APR2023
                    end
                end;
            //end;
            until PurchaseOrderLine.Next() = 0;
    END;


    PROCEDURE CreateExcelbook()
    BEGIN
        ExcelBuffer1.CreateBookAndOpenExcel('', 'Open Po', '', COMPANYNAME, USERID);

    END;



}