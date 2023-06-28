report 50162 "Issuance Report"
{
    Caption = 'Issuance Report(Consumption)_50162';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Quantity (Base)" = filter(<> 0), "Qty Issued" = FILTER(<> 0));
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLinkReference = "Indent Line";
                    DataItemLink = "Indent No." = field("Document No."), "Indent Line No." = field("Line No.");
                    trigger OnPreDataItem()
                    begin
                        SetCurrentKey("Document No.");
                        SetFilter("Indent No.", '<>%1', '');
                        SetFilter("Indent Line No.", '<>%1', 0);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        Item: Record Item;
                        Users: Record User;
                        PurchLine: Record "Purchase Line";
                        PostGateEntryLine: Record "Posted Gate Entry Line_B2B";
                        PostedGateEntryHed: Record "Posted Gate Entry Header_B2B";
                        ItemLedgerEntries: Record "Item Ledger Entry";
                    begin
                        Clear(InwardRefNumber);
                        //B2BSSD24APR2023>>
                        if DocumentNoVar <> "Item Ledger Entry"."Document No." then begin
                            DocumentNoVar := "Item Ledger Entry"."Document No.";
                            Clear(ItemLedgerQty);
                            ItemLedgerEntries.Reset();
                            ItemLedgerEntries.SetRange("Document No.", "Item Ledger Entry"."Document No.");
                            if ItemLedgerEntries.FindSet() then
                                repeat
                                    ItemLedgerQty += "Item Ledger Entry".Quantity;
                                until ItemLedgerEntries.Next() = 0;
                            //B2BSSD24APR2023<<
                            SNo += 1;
                            Users.Reset();
                            Users.SetRange("User Name", "Indent Header".Indentor);
                            if Users.FindFirst() then;
                            if Item.Get("Indent Line"."No.") then;
                            //CalcFields("Qty Issued");
                            "Indent Line".CalcFields("Qty Issued");


                            PurchLine.Reset();
                            PurchLine.SetRange("Indent No.", "Indent Line"."Document No.");
                            PurchLine.SetRange("Indent Line No.", "Indent Line"."Line No.");
                            if PurchLine.FindFirst() then begin
                                //B2BSSD21Dec2022<<
                                PostedGateEntryHed.Reset();
                                PostedGateEntryHed.SetRange("Purchase Order No.", PurchLine."Document No.");
                                PostedGateEntryHed.SetRange("Purchase Order Line No.", PurchLine."Line No.");
                                if PostedGateEntryHed.FindFirst() then
                                    InwardRefNumber := PostedGateEntryHed."No.";//B2BSSD28MAR2023
                                //B2BSSD21Dec2022>>
                            end;

                            //B2BSSD28MAR2023<<
                            Users.Reset();
                            Users.SetRange("User Name", UserId);
                            if Users.FindFirst() then
                                username := Users."Full Name";
                            //B2BSSD28MAR2023>>
                            WindPa.Update(1, "Document No.");
                            TempExcelBuffer.NewRow();
                            TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn("Indent Header"."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Header"."Delivery Location", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Header"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn("Indent Header"."programme Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD28MAR2023
                            TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(username, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD28MAR2023
                            TempExcelBuffer.AddColumn("Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                            TempExcelBuffer.AddColumn("Item Ledger Entry"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Item Ledger Entry"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Line"."Quantity (Base)", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn("Indent Line"."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(ItemLedgerQty, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD24APR2023
                            TempExcelBuffer.AddColumn("Indent Line"."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(ABS(Round("Indent Line"."Qty Issued" * "Indent Line"."Unit Cost")), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);//B2BSSD19Jan2023
                            TempExcelBuffer.AddColumn(InwardRefNumber, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD28MAR2023
                        end;
                    end;
                }
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Document Date", '%1..%2', StartDate, EndDate);
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
                        ApplicationArea = all;
                    }
                    field(EndDate; EndDate)
                    {
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
        TempExcelBuffer.CreateBookAndOpenExcel('', 'Consumption Details', '', COMPANYNAME, USERID);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        WindPa: Dialog;
        SNo: Integer;
        InwardRefNumber: Code[20];//B2BSSD28MAR2023
        username: Text[50];//B2BSSD28MAR2023
        ILE: Record "Item Ledger Entry";
        DocumentNoVar: Code[50];
        ItemLedgerQty: Integer;

    procedure MakeExcelHeaders()
    begin
        WindPa.OPEN('Processing #1###############');
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Consumption Report Details', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('Consumption Deatils: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('S. No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Dept. Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Channel', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Programme', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Category', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('User Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Issue No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Issue Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Order Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Issue Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Issue Rate', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Total Amount', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Inward Ref.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;
}