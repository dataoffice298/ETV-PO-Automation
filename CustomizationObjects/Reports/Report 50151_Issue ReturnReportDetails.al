report 50151 "Issue Return Report Details"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Issue Return Report Details';

    dataset
    {
        dataitem(IndentHeader; "Indent Header")
        {
            dataitem(IndentLine; "Indent Line")
            {
                CalcFields = "Qty Issued", "Qty Returned";
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = IndentHeader;
                trigger OnPreDataItem()
                begin
                    IndentLine.SetRange(Type, IndentLine.Type::Item);
                end;

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                    ItemGRec.Get(IndentLine."No.");
                    ItemLedgerEntry.Reset();
                    ItemLedgerEntry.SetRange("Indent No.", IndentLine."Document No.");
                    ItemLedgerEntry.SetRange("Indent Line No.", IndentLine."Line No.");
                    ItemLedgerEntry.SetFilter(Quantity, '>%1', 0);
                    if ItemLedgerEntry.FindSet() then begin
                        repeat
                            ExcelBuffer.NewRow;
                            ExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentLine."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentLine."Delivery Location", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentLine."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentHeader."programme Name", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(ItemGRec."Item Category Code", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentHeader.Indentor, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentHeader."No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentHeader."Document Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                            ExcelBuffer.AddColumn(ItemLedgerEntry."Document No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(ItemLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                            ExcelBuffer.AddColumn(IndentLine."No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentLine.Description, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(IndentLine."Qty Issued", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(IndentLine."Unit of Measure", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(ItemLedgerEntry.Quantity, FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                            ValueEntry.SetRange("Document No.", ItemLedgerEntry."Document No.");
                            ValueEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
                            if ValueEntry.FindFirst() then
                                ExcelBuffer.AddColumn(ValueEntry."Cost per Unit", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(ItemLedgerEntry.Quantity * ValueEntry."Cost per Unit", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(ItemLedgerEntry."Entry No.", FALSE, '', FALSE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        until ItemLedgerEntry.Next = 0;
                    end;
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

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

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
        ExcelBuffer.CreateBookAndOpenExcel('', 'Issue Return Report Details', '', COMPANYNAME, USERID);
    end;


    PROCEDURE MakeIndentExcelDataHeader()
    BEGIN

        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Issue Return Report Details', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            ExcelBuffer.AddColumn('Issue Return Report Details FROM  ' + Format(StartDate, 0, '<Day,2>-<Month,2>-<Year4>') + '  TO  ' + Format(EndDate, 0, '<Day,2>-<Month,2>-<Year4>'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('S. No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Dept. Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Channel', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Programme', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Category', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indentror Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Issue Return No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Return Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Item Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Issue Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Return Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Return Rate', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Entry No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
    END;



    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        SNo: Integer;
        ItemGRec: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
}