report 50158 "Indent Req Detailed Report"
{
    Caption = 'Indent Requisition Detailed Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(IndentReqHeader; "Indent Req Header")
        {
            DataItemTableView = where(Status = filter(Release));
            RequestFilterFields = "No.";
            dataitem(IndentReqLine; "Indent Requisitions")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = IndentReqHeader;

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                    PurchRcptLine.Reset();
                    PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
                    PurchRcptLine.SetRange("No.", IndentReqLine."Item No.");
                    if PurchRcptLine.FindLast() then;
                    PurchRcptHeader.Reset();
                    PurchRcptHeader.SetRange("Order No.", IndentReqLine."Purch Order No.");
                    if PurchRcptHeader.FindSet() then begin
                        repeat
                            ExcelBuffer.NewRow;
                            ExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentReqLine."Document No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            //ExcelBuffer.AddColumn(IndentReqLine."Line No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentReqHeader."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(PurchRcptHeader."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                            ExcelBuffer.AddColumn(IndentReqLine.Description, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine."Unit of Measure", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine.Quantity, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentReqLine."Spec Id", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqHeader.Purpose, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(PurchRcptLine."Order No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(PurchRcptLine."Order Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(PurchRcptLine."Buy-from Vendor No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        until PurchRcptHeader.Next = 0;
                    end else begin
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(IndentReqLine."Document No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        //ExcelBuffer.AddColumn(IndentReqLine."Line No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(IndentReqHeader."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                        ExcelBuffer.AddColumn(IndentReqLine.Description, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(IndentReqLine."Unit of Measure", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(IndentReqLine.Quantity, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(IndentReqLine."Spec Id", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(IndentReqHeader.Purpose, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(PurchRcptLine."Order No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(PurchRcptLine."Order Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(PurchRcptLine."Buy-from Vendor No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Document Date", '%1..%2', StartDate, EndDate);
                Clear(SNo);
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
        ExcelBuffer.CreateBookAndOpenExcel('', 'Indent Requisition Detailed Report', '', COMPANYNAME, USERID);
    end;

    PROCEDURE MakeIndentExcelDataHeader()
    BEGIN
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('SNo', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Req No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        //ExcelBuffer.AddColumn('Line No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Req Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Regularization', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purchase Receive Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Product', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('User Reference', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Prevous PO No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Prevous PO date.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Previous Vendor', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
    END;


    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        SNo: integer;
        StartDate: Date;
        EndDate: Date;
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
}