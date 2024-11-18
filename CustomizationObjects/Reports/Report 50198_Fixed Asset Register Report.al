report 50198 "Fixed Asset Register New"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'FA Register New';
    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin
                Clear(OpeningBalance);
                Clear(DesposalOFtheMonth);
                Clear(AdditionDuringYear);
                Clear(DeperationAmount);
                Clear(DeperationOFtheMonth);
                Clear(DateGvar);
                Clear(StartYear);
                Clear(EndYear);
                Clear(FinancialYear);

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
                FALedgerEntries.SetCurrentKey("Entry No.");
                FALedgerEntries.SetRange("FA No.", "No.");
                FALedgerEntries.SetRange("Depreciation Book Code", DepreciationBookCode);
                //FALedgerEntries.SetFilter("Posting Date", '<=%1', FromDate);
                FALedgerEntries.SetRange("FA Posting Type", FALedgerEntries."FA Posting Type"::"Acquisition Cost");
                if FALedgerEntries.FindFirst() then begin
                    //FALedgerEntries.CalcSums(Amount);
                    OpeningBalance := FALedgerEntries.Amount;
                end;

                FALedgerEntries.Reset();
                FALedgerEntries.SetRange("FA No.", "No.");
                FALedgerEntries.SetRange("Depreciation Book Code", DepreciationBookCode);
                //FALedgerEntries.SetRange("Posting Date", FromDate, ToDate);
                FALedgerEntries.SetRange("FA Posting Type", FALedgerEntries."FA Posting Type"::"Acquisition Cost");
                FALedgerEntries.SetRange("FA Posting Category", FALedgerEntries."FA Posting Category"::Disposal);
                if FALedgerEntries.FindSet() then begin
                    FALedgerEntries.CalcSums(Amount);
                    DesposalOFtheMonth := FALedgerEntries.Amount;
                end;
                FALedgerEntries.Reset();
                FALedgerEntries.SetRange("FA No.", "No.");
                FALedgerEntries.SetRange("Depreciation Book Code", DepreciationBookCode);
                FALedgerEntries.SetFilter("Posting Date", '%1..%2', FromDate, ToDate);
                FALedgerEntries.SetFilter("FA Posting Type", '%1', FALedgerEntries."FA Posting Type"::"Acquisition Cost");
                FALedgerEntries.SetFilter("FA Posting Category", '%1', FALedgerEntries."FA Posting Category"::" ");
                if FALedgerEntries.FindSet() then begin
                    FALedgerEntries.CalcSums(Amount);
                    if OpeningBalance < FALedgerEntries.Amount then
                        AdditionDuringYear := FALedgerEntries.Amount - OpeningBalance
                    else
                        AdditionDuringYear := FALedgerEntries.Amount;
                end;
                FALedgerEntries.Reset();
                FALedgerEntries.SetRange("FA No.", "No.");
                FALedgerEntries.SetRange("Depreciation Book Code", DepreciationBookCode);
                FALedgerEntries.SetFilter("Posting Date", '<%1', FromDate);
                FALedgerEntries.SetRange("FA Posting Type", FALedgerEntries."FA Posting Type"::Depreciation);
                if FALedgerEntries.FindSet() then begin
                    FALedgerEntries.CalcSums(Amount);
                    DeperationAmount := Abs(FALedgerEntries.Amount);
                end;
                FALedgerEntries.Reset();
                FALedgerEntries.SetRange("FA No.", "No.");
                FALedgerEntries.SetRange("Depreciation Book Code", DepreciationBookCode);
                FALedgerEntries.SetRange("Posting Date", FromDate, ToDate);
                FALedgerEntries.SetRange("FA Posting Type", FALedgerEntries."FA Posting Type"::Depreciation);
                FALedgerEntries.SetFilter("FA Posting Category", '%1', FALedgerEntries."FA Posting Category"::" ");
                if FALedgerEntries.FindSet() then begin
                    FALedgerEntries.CalcSums(Amount);
                    DeperationOFtheMonth := Abs(FALedgerEntries.Amount);
                end;
                FALedgerEntries.Reset();
                FALedgerEntries.SetRange("FA No.", "No.");
                if FALedgerEntries.FindFirst() then begin
                    CWIPLine.Reset();
                    CWIPLine.SetRange("Document No.", FALedgerEntries."Document No.");
                    if CWIPLine.FindFirst() then;
                    PurchInvHeader.Reset();
                    PurchInvHeader.SetRange("Order No.", CWIPLine."Order No.");
                    if PurchInvHeader.FindFirst() then;
                    if PurchRcptHdr.Get(CWIPLine."Receipt No.") then;
                    if PurchHeader.Get(PurchHeader."Document Type"::Order, CWIPLine."Order No.") then;
                end;
                SNo += 1;
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(SNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn("No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(FinancialYear, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("FA Class Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("FA Subclass Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Make_B2B, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Model No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Serial No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CWIPLine."Vendor No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CWIPLine."Vendor Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchInvHeader."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchInvHeader."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(OpeningBalance, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(AdditionDuringYear, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(DesposalOFtheMonth, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn("Salvage Value", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(OpeningBalance, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(DepBook."No. of Depreciation Years", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(DepBook."Depreciation Method", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(DepBook."Depreciation Starting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(DepBook."Depreciation Ending Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(DeperationAmount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(DeperationOFtheMonth, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn((DeperationAmount + DeperationOFtheMonth), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn((OpeningBalance - (DeperationAmount + DeperationOFtheMonth)), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn("FA Location Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("FA Sub Location", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CWIPLine."Receipt No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchRcptHdr."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(CWIPLine."Order No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(PurchHeader."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
            end;



            trigger OnPreDataItem()
            begin
                MakeExcelHeader();
            end;
        }
    }


    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
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

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    trigger OnInitReport()
    begin
        DepreciationBookCode := 'COMPANY';
    end;


    trigger OnPreReport()
    begin
        if (FromDate = 0D) OR (ToDate = 0D) then
            Error('From Date & TO Date Must have a value');
    end;

    trigger OnPostReport()
    begin
        Window.Close();
        TempExcelBuffer.CreateNewBook('FA Report');
        TempExcelBuffer.WriteSheet('FA Report', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('FA Report');
        TempExcelBuffer.OpenExcel();
    end;

    var
        FromDate: Date;
        ToDate: Date;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Window: Dialog;
        FALedgerEntries: Record "FA Ledger Entry";
        FixedAsset: Record "Fixed Asset";
        SNo: Integer;
        CWIPLine: Record "CWIP Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        OpeningBalance: Decimal;
        DesposalOFtheMonth: Decimal;
        AccumDepreciationAmt: Decimal;
        PurchHeader: Record "Purchase Header";
        PurchRcptHdr: Record "Purch. Rcpt. Header";
        DepreciationPeriodAmt: Decimal;
        DepreciationBookCode: Code[20];
        DepBook: Record "FA Depreciation Book";
        AdditionDuringYear: Decimal;
        DeperationAmount: Decimal;
        DeperationOFtheMonth: Decimal;
        StartYear: Text;
        EndYear: Text;
        DateGvar: Date;
        FinancialYear: Text;


    procedure MakeExcelHeader()
    begin
        Window.OPEN('Fixed Asset No. #1##################');
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('FIXED ASSET REGISTER FROM ' + Format(FromDate) + ' TO ' + Format(ToDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNo.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FA Card No', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Fynancial Year Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FA Class Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FA Sub Class Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Make', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Model No', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Serial No', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor No', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice No', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invoice Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Asset Opening Value', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Additions During the Year', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Deletions', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Salvage Value', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Net Asset Value before Depreciaton', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Life', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Method of Depreciation', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Depreciation Starting Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Depreciation End Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Accummulated Depreciation as on ' + Format(FromDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Depreciation during the period ' + Format(FromDate) + ' TO ' + Format(ToDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Accummulated Depreciation as on ' + Format(ToDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Net Asset Value After Depreciation as on ' + Format(ToDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FA Location Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('FA Sub Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GRN Number', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GRN Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO No', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;
}