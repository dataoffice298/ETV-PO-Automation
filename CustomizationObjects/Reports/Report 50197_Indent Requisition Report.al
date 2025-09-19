report 50197 "Indent Requisition Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Indent Requisition Detailed Status_50197';
    ProcessingOnly = true;

    dataset
    {

        dataitem(IndentReqHeader; "Indent Req Header")
        {
            dataitem(IndentReqLine; "Indent Requisitions")
            {
                CalcFields = "Received Quantity";
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = IndentReqHeader;

                trigger OnAfterGetRecord()
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Table ID", Database::"Indent Req Header");
                    ApprovalEntry.SetRange("Document No.", IndentReqHeader."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                    ApprovalEntry.SetFilter("Last Date-Time Modified", '%1..%2', StartDate, EndDate);
                    if ApprovalEntry.FindLast() then begin
                        Clear(IndentSatus);
                        if (IndentReqLine."Qty. Ordered" = IndentReqLine."Received Quantity") And (IndentReqLine."Remaining Quantity" = 0) then
                            IndentSatus := IndentSatus::Completed
                        else
                            if (IndentReqLine."Qty. Ordered" > IndentReqLine."Received Quantity") And (IndentReqLine."Received Quantity" <> 0) then
                                IndentSatus := IndentSatus::"Order placed material partially received"
                            else
                                if (IndentReqLine."Received Quantity" = 0) And (IndentReqLine."Qty. Ordered" <> 0) then
                                    IndentSatus := IndentSatus::"Order placed meterial not yet to received"
                                else
                                    if (IndentReqLine."Qty. Ordered" = 0) then
                                        IndentSatus := IndentSatus::"Yet to Intiate";

                        PurchLine.Reset();
                        PurchLine.SetRange("Indent Req No", IndentReqLine."Document No.");
                        PurchLine.SetRange("Indent Req Line No", IndentReqLine."Line No.");
                        if PurchLine.FindSet() then begin
                            repeat
                                if PurchHead.GET(PurchLine."Document Type", PurchLine."Document No.") then;
                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn(IndentReqHeader."No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqHeader."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                                ExcelBuffer.AddColumn(IndentReqHeader."Resposibility Center", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine."Requisition Type", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine."Indent No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentHeader."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                                ExcelBuffer.AddColumn(IndentReqLine."Line No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(IndentReqLine."Item No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine.Description, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine."Variant Description", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine."Indentor Description", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine."Spec Id", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine."Unit of Measure", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqLine.Quantity, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(IndentReqLine."Qty. Ordered", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(IndentReqLine."Received Quantity", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                                //ExcelBuffer.AddColumn(PurchaseLine."Quantity Received", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(IndentReqLine."Remaining Quantity", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn((IndentReqLine."Qty. Ordered") - (IndentReqLine."Received Quantity"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(PurchLine."Document No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(PurchHead."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                                ExcelBuffer.AddColumn(PurchLine."Buy-from Vendor No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(PurchHead."Buy-from Vendor Name", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(ApprovalEntry."Last Date-Time Modified", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentReqHeader.Purpose, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                                ExcelBuffer.AddColumn(IndentSatus, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            until PurchLine.Next() = 0;
                        end;
                        if IndentReqLine."Qty. Ordered" = 0 then begin
                            ExcelBuffer.NewRow;
                            ExcelBuffer.AddColumn(IndentReqHeader."No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqHeader."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                            ExcelBuffer.AddColumn(IndentReqHeader."Resposibility Center", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine."Requisition Type", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine."Indent No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentHeader."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                            ExcelBuffer.AddColumn(IndentReqLine."Line No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentReqLine."Item No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine.Description, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine."Variant Description", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine."Indentor Description", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine."Spec Id", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine."Unit of Measure", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqLine.Quantity, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentReqLine."Qty. Ordered", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentReqLine."Received Quantity", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            //ExcelBuffer.AddColumn(PurchaseLine."Quantity Received", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentReqLine."Remaining Quantity", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn((IndentReqLine."Qty. Ordered") - (IndentReqLine."Received Quantity"), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('', FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(ApprovalEntry."Last Date-Time Modified", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentReqHeader.Purpose, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentSatus, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        end;
                    end;
                end;
            }
            trigger OnPreDataItem()
            begin
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
        IF (StartDate <> 0DT) or (EndDate <> 0DT) THEN
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
        ExcelBuffer.AddColumn('PO Balanced Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PO Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PO Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Last Approval Date&Time', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Status of Indent', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);

    END;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: DateTime;
        EndDate: DateTime;
        IndentHeader: Record "Indent Header";
        PurchHead: Record "Purchase Header";
        //IndentReqHeader: Record "Indent Req Header";
        //IndentReqLine: Record "Indent Requisitions";
        VendorNo: Code[20];
        VendorName: Text;
        ApprovalEntry: Record "Approval Entry";
        LastApprovalDateTime: DateTime;
        LastApprovalDate: Date;
        PODate: Date;
        IndentSatus: Option "Order placed meterial not yet to received",Completed,"Yet to Intiate","Order placed material partially received";
        PurchLine: Record "Purchase Line";

}