report 50174 "PO Cancellation Report"
{
    Caption = 'PO Cancellation Report';
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
                if (FromDate <> 0D) or (ToDate <> 0D) then
                    PurchHdrRec.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
                if PONO <> '' then
                    PurchHdrRec.SetRange("No.", PONO);
                PurchHdrRec.SetRange("Cancelled Order", true);
                if PurchHdrRec.FindSet() then
                    repeat
                        PurchLineRec.Reset();
                        PurchLineRec.SetRange("Document No.", PurchHdrRec."No.");
                        PurchLineRec.SetRange("Document Type", PurchLineRec."Document Type"::Order);
                        if PurchLineRec.FindSet() then
                            repeat
                                IndentHdrRec.Reset();
                                if IndentHdrRec.Get(PurchLineRec."Indent No.") then
                                    IndentDateVar := IndentHdrRec."Document Date";
                                SNO += 1;
                                TempExcelBuffer.NewRow();
                                TempExcelBuffer.AddColumn(SNO, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                                TempExcelBuffer.AddColumn('ETPL', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchLineRec."Indent No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(IndentDateVar, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec.Purpose, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchLineRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec."Buy-from Vendor Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchLineRec."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn((PurchLineRec.Quantity * PurchLineRec."Unit Cost"), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                TempExcelBuffer.AddColumn(PurchHdrRec."Cancellation Reason", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
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
                    field(PONO; PONO)
                    {
                        ApplicationArea = All;
                        Caption = 'Purchase Order No.';
                        TableRelation = "Purchase Header"."No." where("Document Type" = filter(Order));
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    begin
        TempExcelBuffer.CreateNewBook(ReportNameLbl);
        TempExcelBuffer.WriteSheet('', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(ReportNameLbl);
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
        TempExcelBuffer.AddColumn(HdrLblVar, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Division', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Product', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Supplier', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn('Reason For Cancellation', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
    end;

    var
        FromDate, ToDate, IndentDateVar : Date;
        SNO: Integer;
        HdrLblVar, PONO : Text;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PurchHdrRec: Record "Purchase Header";
        PurchLineRec: Record "Purchase Line";
        IndentHdrRec: Record "Indent Header";
        ReportNameLbl: Label 'Purchase Orders Cancellation Report';
}