report 50126 "PO Ratification"
{
    Caption = 'PO Ratification Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Order));
            trigger OnAfterGetRecord()
            begin
                PurchLineRec.Reset();
                PurchLineRec.SetRange("Document No.", "Purchase Header"."No.");
                PurchLineRec.SetRange("Document Type", "Purchase Header"."Document Type");
                PurchLineRec.SetRange(Type, PurchLineRec.Type::Item);
                if PurchLineRec.FindSet() then
                    repeat
                        SNO += 1;
                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn(SNO, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn('ETPL', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Purchase Header"."Buy-from Vendor Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(PurchLineRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn("Purchase Header"."Vendor Invoice No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn("Purchase Header"."Vendor Invoice Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn(PurchLineRec.Quantity, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn(PurchLineRec."Unit Cost (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn((PurchLineRec."Unit Cost (LCY)" * PurchLineRec.Quantity), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn("Purchase Header".Purpose, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                        TotalAmt += (PurchLineRec."Unit Cost (LCY)" * PurchLineRec.Quantity);
                    until PurchLineRec.Next() = 0;

                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('Total', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(' ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(TotalAmt, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Number);
            end;

            trigger OnPreDataItem()
            begin
                if PONO <> '' then
                    "Purchase Header".SetRange("No.", PONO);
                if VNNO <> '' then
                    "Purchase Header".SetRange("Buy-from Vendor No.", VNNO);
                if (FromDate <> 0D) or (ToDate <> 0D) then
                    "Purchase Header".Setfilter("Posting Date", '%1..%2', FromDate, ToDate);
                MakeExcelHeader();
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
                    field(VNNO; VNNO)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor No.';
                        TableRelation = Vendor."No.";
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
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Division', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Name of Supplier', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Material Description', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Bill No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Bill Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Quantity', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Unit Price', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    var
        FromDate, ToDate : Date;
        VNNO, PONO, HdrLblVar : Text;
        SNO: Integer;
        TotalAmt: Decimal;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PurchLineRec: Record "Purchase Line";
        ReportNameLbl: Label 'PO Ratification Report';

}