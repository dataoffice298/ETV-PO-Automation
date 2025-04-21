report 50185 "RFQ Response Report"
{
    Caption = 'RFQ Response Report';
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

                RFQNumRec.Reset();
                if RFQNoVar <> '' then
                    RFQNumRec.SetRange("RFQ No.", RFQNoVar);
                if RFQNumRec.FindSet() then
                    repeat
                        RFQNo := RFQNumRec."RFQ No.";
                        QuotCmpHdrRec.Reset();
                        QuotCmpHdrRec.SetRange(RFQNumber, RFQNo);
                        if (FromDate <> 0D) or (ToDate <> 0D) then
                            QuotCmpHdrRec.SetFilter("Document Date", '%1..%2', FromDate, ToDate);
                        if QuotNoVar <> '' then
                            QuotCmpHdrRec.SetRange("No.", QuotNoVar);
                        if QuotCmpHdrRec.FindSet() then
                            repeat
                                ApprovalEntries.Reset();
                                ApprovalEntries.SetRange("Table ID", Database::QuotCompHdr);
                                ApprovalEntries.SetRange("Document No.", QuotCmpHdrRec."No.");
                                ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                                if ApprovalEntries.findlast() then begin
                                    if QuotCmpHdrRec.Status = QuotCmpHdrRec.Status::Released then
                                        ApprovalDate := ApprovalEntries."Last Date-Time Modified";
                                end;

                                QuotCmpTestRec.Reset();
                                QuotCmpTestRec.SetRange("RFQ No.", QuotCmpHdrRec.RFQNumber);
                                if VNNO <> '' then
                                    QuotCmpTestRec.SetRange("Vendor No.", VNNO);
                                QuotCmpTestRec.SetRange(Type, QuotCmpTestRec.Type::Item);
                                QuotCmpTestRec.SetFilter("Item No.", '<>%1', '');
                                if QuotCmpTestRec.FindSet() then
                                    repeat
                                        VNNOVar := QuotCmpTestRec."Vendor No.";
                                        IndentHdrRec.Reset();
                                        if IndentHdrRec.Get(QuotCmpTestRec."Indent No.") then
                                            IndentDateVar := IndentHdrRec."Document Date";
                                        if (QuotCmpTestRec."Carry Out Action") then begin
                                            PurchHdrRec.SetRange("No.", QuotCmpTestRec."Parent Quote No.");
                                            if PurchHdrRec.FindFirst() then begin
                                                ApprvdVendName := PurchHdrRec."Buy-from Vendor Name";
                                                PONO := PurchHdrRec."No.";
                                                PODate := PurchHdrRec."Document Date";
                                                EnqNoVar := PurchHdrRec."Enquiry No.";
                                                SuppResponse := 'Yes';
                                            end;
                                        end
                                        else
                                            if not (QuotCmpTestRec."Carry Out Action") then begin
                                                ApprvdVendName := '';
                                                PONO := '';
                                                PODate := 0D;
                                                EnqNoVar := '';
                                                SuppResponse := 'No';
                                            end;
                                        SNO += 1;
                                        TempExcelBuffer.NewRow();
                                        TempExcelBuffer.AddColumn(SNO, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                                        TempExcelBuffer.AddColumn('ETPL', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(QuotCmpTestRec."Indent No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(IndentDateVar, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(QuotCmpHdrRec.Purpose, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(QuotCmpTestRec.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(RFQNo, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(QuotCmpHdrRec."Document Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(QuotCmpTestRec."Vendor Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(SuppResponse, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(QuotCmpHdrRec.Status, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(ApprovalDate, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                                        TempExcelBuffer.AddColumn(ApprvdVendName, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(PONO, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(PODate, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(EnqNoVar, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                        TempExcelBuffer.AddColumn(QuotCmpTestRec."Parent Quote No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                                    until QuotCmpTestRec.Next() = 0;
                            until QuotCmpHdrRec.Next() = 0;
                    until RFQNumRec.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                if (FromDate = 0D) OR (ToDate = 0D) then
                    Error('Start Date and End Date Must have a value');
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
                    field(RFQNoVar; RFQNoVar)
                    {
                        ApplicationArea = All;
                        Caption = 'RFQ No.';
                        TableRelation = "RFQ Numbers"."RFQ No.";
                    }
                    field(QuotNoVar; QuotNoVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Quote No.';
                        TableRelation = QuotCompHdr."No.";
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
        HdrLblVar := ReportNameLbl + '   ' + Format(FromDate) + ' ' + ' to ' + '   ' + Format(ToDate);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(HdrLblVar, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(' ', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Division', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Product', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RFQ No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RFQ Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Suppliers', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Suppliers Response', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Comparision Status', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Date of Comparision Approval', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Approved Supplier', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Enquiry No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Quotaion No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    var
        FromDate, ToDate, IndentDateVar, PODate : Date;
        ApprovalDate: DateTime;
        SNO: Integer;
        RFQNoVar, QuotNoVar, VNNO : code[60];
        RFQNo, VNNOVar, ApprvdVendName, PONO, SuppResponse, HdrLblVar, EnqNoVar : Text;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PurchHdrRec: Record "Purchase Header";
        PurchLineRec: Record "Purchase Line";
        IndentHdrRec: Record "Indent Header";
        RFQNumRec: Record "RFQ Numbers";
        QuotCmpHdrRec: Record QuotCompHdr;
        QuotCmpTestRec: Record "Quotation Comparison Test";
        ApprovalEntries: Record "Approval Entry";
        ReportNameLbl: Label 'RFQ Response Report';
}