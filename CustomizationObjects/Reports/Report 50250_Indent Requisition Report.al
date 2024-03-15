report 50250 "Indent Requisition Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Indent Requisition Detailed Status_50250';
    ProcessingOnly = true;

    dataset
    {
        dataitem(IndentReqHeader; "Indent Req Header")
        {
            dataitem(IndentReqLine; "Indent Requisitions")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = IndentReqHeader;
                trigger OnAfterGetRecord()
                begin
                    if IndentHeader.Get(IndentReqLine."Indent No.") then;
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(IndentReqHeader."No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Format(IndentReqHeader."Document Date", 0, '<Day,2>-<Month,2>-<Year4>'), FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn(IndentReqHeader."Resposibility Center", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Requisition Type", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine.Department, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Indent No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Format(IndentHeader."Document Date", 0, '<Day,2>-<Month,2>-<Year4>'), FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn(IndentReqLine."Line No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IndentReqLine."Item No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine.Description, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Variant Code", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Indentor Description", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Spec Id", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Unit of Measure", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Indent Quantity", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IndentReqLine."Qty. Ordered", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IndentReqLine."Received Quantity", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IndentReqLine."Remaining Quantity", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IndentReqLine."Purch Order No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Vendor No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Vendor Name", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Unit Cost", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                end;
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Document Date", '%1..%2', StartDate, EndDate);
                MakeIndentExcelDataHeader();
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
                        ApplicationArea = All;
                        Caption = 'From Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                }
            }


        }

    }
    trigger OnPreReport()
    begin
        ExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin
        ExcelBuffer.CreateBookAndOpenExcel('', 'Indent Requisition Detailed Status', '', COMPANYNAME, USERID);
    end;

    PROCEDURE MakeIndentExcelDataHeader()
    BEGIN

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('INDENT REQUISITION DETAILED STATUS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            ExcelBuffer.AddColumn('INDENT REQUISITION DETAILED STATUS FROM  ' + Format(StartDate, 0, '<Day,2>-<Month,2>-<Year4>') + '  TO  ' + Format(EndDate, 0, '<Day,2>-<Month,2>-<Year4>'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Indent Requisition No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Requision Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Responsibility Center', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Requisition Status', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Dept Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Line No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Variant', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indentor Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Spec ID', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Unit of Measurement', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Qty Ordered', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Received Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Remaining Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PO Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Unit Cost', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);

    END;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        IndentHeader: Record "Indent Header";

}