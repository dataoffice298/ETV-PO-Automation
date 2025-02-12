report 50148 "ETPL Indent Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'ETPL Indent Report';
    ProcessingOnly = true;

    dataset
    {
        dataitem(IndentReqHeader; "Indent Req Header")
        {
            RequestFilterFields = "No.";
            dataitem(IndentReqLine; "Indent Requisitions")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = IndentReqHeader;
                trigger OnAfterGetRecord()
                begin
                    if IndentHead.Get(IndentReqLine."Indent No.") then;
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(IndentReqLine."Line No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IndentReqHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqHeader."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn(IndentReqLine."Due Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
                    ExcelBuffer.AddColumn(LastApprovalDateTime, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Indent No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if IndentReqLine."Indent No." <> '' then
                        ExcelBuffer.AddColumn(IndentHead."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date)
                    else
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Variant Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Indentor Description", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Spec Id", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(IndentReqLine."Indent Quantity", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(IndentReqHeader.Purpose, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                Clear(LastApprovalDateTime);
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Table ID", Database::"Indent Req Header");
                ApprovalEntry.SetRange("Document No.", IndentReqHeader."No.");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.FindLast() then begin
                    if IndentReqHeader.Status = IndentReqHeader.Status::Release then
                        LastApprovalDateTime := ApprovalEntry."Last Date-Time Modified";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (StartDate <> 0D) and (EndDate <> 0D) then
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
        ExcelBuffer.AddColumn('Line No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Requision No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Requision Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Due Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Last Approved Date and Time', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Dept Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent No.', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Variant', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indentor Description', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Spec ID', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Unit of Measurement', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Qty', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

    END;




    var
        StartDate: Date;
        EndDate: Date;
        ExcelBuffer: Record "Excel Buffer" temporary;
        ApprovalEntry: Record "Approval Entry";
        LastApprovalDateTime: DateTime;
        IndentHead: Record "Indent Header";
}