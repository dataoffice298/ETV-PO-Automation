report 50196 "Assets Register"
{
    Caption = 'Assets Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var
                GRNDateVar: Date;
                GRNNO, Vendorno, VendorName, Orderno, InvoiceNo, AvailUnavailVar : Text;
                FALedgerEntries1: Record "FA Ledger Entry";
            begin
                Clear(DateGvar);
                Clear(StartYear);
                Clear(EndYear);
                Clear(FinancialYear);
                Clear(Vendorno);
                Clear(VendorName);
                Clear(GRNNO);
                Clear(Orderno);
                Clear(GRNDateVar);
                Clear(InvoiceNo);
                Clear(AvailUnavailVar);
                Clear(CapitalisedAmt);

                if Date2DMY(FromDate, 3) = Date2DMY(ToDate, 3) then begin
                    DateGvar := CalcDate('-1Y', FromDate);
                    StartYear := Format(Date2DMY(DateGvar, 3));
                    EndYear := Format(FromDate, 0, '<Year,2>');
                    FinancialYear := 'FY.' + StartYear + '-' + EndYear;
                end;

                if DepreciationBookCode <> '' then
                    if DepBook.Get("No.", DepreciationBookCode) then;
                Window.Update(1, "No.");
                if DepBook."Disposal Date" <> 0D then
                    if DepBook."Disposal Date" < FromDate then
                        CurrReport.Skip();
                if (DepBook."FA Posting Group" = 'WIP') OR (DepBook."FA Posting Group" = 'WIP INTANG') then
                    CurrReport.Skip();

                FALedgerEntries.Reset();
                FALedgerEntries.SetRange("FA No.", "No.");
                //FALedgerEntries.SetFilter("FA Posting Category", '%1|%2', FALedgerEntries."FA Posting Category"::"Bal. Disposal", FALedgerEntries."FA Posting Category"::Disposal);
                if FALedgerEntries.FindFirst() then begin
                    if (FALedgerEntries."FA Posting Category" = FALedgerEntries."FA Posting Category"::"Bal. Disposal") OR (FALedgerEntries."FA Posting Category" = FALedgerEntries."FA Posting Category"::Disposal) then begin
                        CurrReport.Skip();
                    end else begin
                        CWIPLine.Reset();
                        CWIPLine.SetRange("Fixed Asset No.", FALedgerEntries."FA No.");
                        if CWIPLine.FindFirst() then begin
                            Vendorno := CWIPLine."Vendor No.";
                            VendorName := CWIPLine."Vendor Name";
                            GRNNO := CWIPLine."Receipt No.";
                            Orderno := CWIPLine."Order No.";

                            if PurchRcptHdr.Get(CWIPLine."Receipt No.") then
                                GRNDateVar := PurchRcptHdr."Document Date";

                            PurchInvLine.Reset();
                            PurchInvLine.SetRange("Order No.", CWIPLine."Order No.");
                            PurchInvLine.SetRange("Order Line No.", CWIPLine."Order Line No.");
                            if PurchInvLine.FindFirst() then
                                InvoiceNo := PurchInvLine."Document No.";
                        end;
                    end;
                end;
                if "Available/Unavailable" = true then
                    AvailUnavailVar := 'Unavailable'
                else
                    AvailUnavailVar := 'Available';

                FALedgerEntries.Reset();
                FALedgerEntries.SetRange("FA No.", "No.");
                FALedgerEntries.SetRange("FA Posting Type", FALedgerEntries."FA Posting Type"::"Acquisition Cost");
                if FALedgerEntries.FindSet() then
                    repeat
                        CapitalisedAmt += FALedgerEntries.Amount;
                    until FALedgerEntries.Next() = 0;

                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn("No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Make_B2B, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Model No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Serial No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("FA Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("FA Sub Location", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Physical-Location", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Vendorno, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(VendorName, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                if InvoiceNo <> '' then
                    TempExcelBuffer.AddColumn(InvoiceNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text)
                else
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(GRNNO, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                if GRNDateVar <> 0D then
                    TempExcelBuffer.AddColumn(GRNDateVar, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date)
                else
                    TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Orderno, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CapitalisedAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn("Responsible Employee", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(AvailUnavailVar, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Gate Entry No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Gate Entry Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn("Gate Entry Time", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Receipt No", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Receipt Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn("Receipt Time", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            end;

            trigger OnPreDataItem()
            begin
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
                        Caption = 'From Date';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                    }
                    field(DepreciationBookCode; DepreciationBookCode)
                    {
                        Caption = 'Depreciation Book Code';
                        TableRelation = "Depreciation Book".Code;
                        ApplicationArea = all;
                        ToolTip = 'Specifies the value of the Depreciation Book Code field.';
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    begin
        Window.Close();
        TempExcelBuffer.CreateNewBook('Assets Register');
        TempExcelBuffer.WriteSheet('Assets Register', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('Assets Register');
        TempExcelBuffer.OpenExcel();
    end;

    procedure MakeExcelHeader()
    begin
        Window.OPEN('Fixed Asset No. #1##################');
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.AddColumn('Company Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Report Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Fixed Asset Detail', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('User Id', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(UserId, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ToDate, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Start Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(FromDate, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('End Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(ToDate, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Asset Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Make', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Model No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Serial No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FA Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FA Sub Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Physical Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor No', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GRN No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GRN Date.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Order No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Capitalised Value', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Responsible Employee', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Avail / Unavail', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Gate Entry No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Gate Entry Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Gate Entry Time', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Receipt No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Receipt Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Receipt Time', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    var
        FALedgerEntries: Record "FA Ledger Entry";
        FromDate, ToDate, DateGvar : Date;
        DepreciationBookCode: Code[20];
        Window: Dialog;
        SNo: Integer;
        StartYear, EndYear, FinancialYear : Text;
        CWIPLine: Record "CWIP Line";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchHeader: Record "Purchase Header";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        DepBook: Record "FA Depreciation Book";
        PurchInvLine: Record "Purch. Inv. Line";
        CapitalisedAmt: Decimal;
}