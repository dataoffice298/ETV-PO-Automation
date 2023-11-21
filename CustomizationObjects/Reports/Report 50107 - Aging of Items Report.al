report 50107 "Aging of Items Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Aging of Items Report_50107';


    dataset
    {
        dataitem(Item; Item)
        {


            DataItemTableView = sorting("Item Category Code") ORDER(Ascending);
            RequestFilterFields = "Item Category Code", "No.";

            trigger OnAfterGetRecord()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                AgingDays: Integer;
                PostedPurchReceipt: Record "Purch. Rcpt. Header";
                PostedPurchReceiptLine: Record "Purch. Rcpt. Line";
                ValueEntry: Record "Value Entry";
                Location: Code[20];
                UnitCostRec: Decimal;

            begin
                CalcFields(Inventory);
                Clear(UnitCostRec);
                if Item.Inventory = 0 then //B2BSCM25SCM2023
                    CurrReport.Skip();//B2BSCM25SCM2023

                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey("Posting Date");
                // ItemLedgerEntry.SetAscending("Posting Date", true);
                ItemLedgerEntry.SetRange("Item No.", "No.");
                ItemLedgerEntry.SetFilter("Entry Type", '%1|%2|%3', ItemLedgerEntry."Entry Type"::Purchase, ItemLedgerEntry."Entry Type"::"Positive Adjmt.", ItemLedgerEntry."Entry Type"::Transfer);
                ItemLedgerEntry.SetFilter("Document Type", '%1|%2|%3', ItemLedgerEntry."Document Type"::"Purchase Receipt", ItemLedgerEntry."Document Type"::" ", ItemLedgerEntry."Document Type"::"Transfer Receipt");
                ItemLedgerEntry.SetFilter("Remaining Quantity", '<>%1', 0); //B2BVCOn25Oct2023
                                                                            // ItemLedgerEntry.SetFilter("Entry Type", '%1', ItemLedgerEntry."Entry Type"::Transfer);
                                                                            // ItemLedgerEntry.SetFilter("Document Type", '%1', ItemLedgerEntry."Document Type"::"Transfer Receipt");
                                                                            // ItemLedgerEntry.SetFilter("Entry Type", '%1', ItemLedgerEntry."Entry Type"::Transfer);
                                                                            // ItemLedgerEntry.SetFilter("Document Type", '%1', ItemLedgerEntry."Document Type"::" ");

                if ItemLedgerEntry.FindSet() then begin
                    ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                    repeat //B2BSCM25SEP2023
                        Clear(AgingDays);
                        Clear(Location);
                        AgingDays := StartDate - ItemLedgerEntry."Posting Date";
                        //B2BVCOn25Oct2023 //Commented >>
                        //if ItemLedgerEntry."Remaining Quantity" = 0 then 
                        //CurrReport.Skip();
                        //B2BVCOn25Oct2023 //Commented <<
                        ValueEntry.Reset();
                        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                        if ValueEntry.FindSet() then begin
                            repeat
                                ValueEntry.CalcSums("Cost per Unit");
                                UnitCostRec := ValueEntry."Cost per Unit";
                            until ValueEntry.Next() = 0;
                        end;

                        SNo += 1;
                        WindPa.Update(1, "No.");
                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD04AUG2023
                        TempExcelBuffer.AddColumn(ItemLedgerEntry."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(ItemLedgerEntry."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(ItemLedgerEntry."Remaining Quantity", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                        //TempExcelBuffer.AddColumn(UnitCostRec, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number); //B2BVCOn25Oct2023 //commented
                        TempExcelBuffer.AddColumn(ItemLedgerEntry."Cost Amount (Actual)", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number); //B2BVCOn25Oct2023
                        TempExcelBuffer.AddColumn(Round(ItemLedgerEntry."Remaining Quantity" * UnitCostRec, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn(ItemLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(AgingDays, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn(ItemLedgerEntry."Location Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);

                    until ItemLedgerEntry.Next() = 0;//B2BSCM25SEP2023
                end;

            end;

            trigger OnPreDataItem()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
            begin
                if StartDate = 0D then
                    Error('Start Date must have a value.');
                Clear(SNo);
                MakeExcelHeaders();
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
                        Caption = 'Ending Date';
                        ApplicationArea = all;
                    }

                }
            }
        }

    }

    trigger OnPreReport()
    begin
        TempExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin
        WindPa.CLOSE();
        TempExcelBuffer.CreateBookAndOpenExcel('', 'Aging of Items', '', COMPANYNAME, USERID);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        WindPa: Dialog;
        SNo: Integer;

    procedure MakeExcelHeaders()
    begin
        WindPa.OPEN('Processing #1###############');
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Aging of Items Report', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('Aging Report on' + Format(StartDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('S.No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD04AUG2023
        TempExcelBuffer.AddColumn('ITEM CATG', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('POSTING DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('AGING DAYS', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('LOCATION', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;
}