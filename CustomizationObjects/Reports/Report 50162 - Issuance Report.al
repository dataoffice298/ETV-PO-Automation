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
                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    Users: Record User;
                    PurchLine: Record "Purchase Line";
                    PostGateEntryLine: Record "Posted Gate Entry Line_B2B";
                    PostedGateEntryHed: Record "Posted Gate Entry Header_B2B";
                    ItemLedgerEntries: Record "Item Ledger Entry";
                    indetno: Integer;
                    i: Integer;
                    ValueEntryLVar: Record "Value Entry";
                    TempItemLedgerEntry: Record "Item Ledger Entry" temporary;

                begin
                    Clear(TotalAmount);
                    Clear(InwardRefNumber);
                    Clear(ItemLedgerQty);
                    ItemLedgerEntries.Reset();
                    ItemLedgerEntries.SetRange("Indent No.", "Indent Line"."Document No.");
                    ItemLedgerEntries.SetRange("Indent Line No.", "Indent Line"."Line No.");
                    ItemLedgerEntries.SetRange("Entry Type", ItemLedgerEntries."Entry Type"::"Negative Adjmt.");//B2BSCM14SEP2023
                    if ItemLedgerEntries.FindSet() then
                        repeat
                            //B2BSSD24APR2023<<
                            Users.Reset();
                            Users.SetRange("User Name", "Indent Header".Indentor);
                            if Users.FindFirst() then;
                            if Item.Get("Indent Line"."No.") then;
                            "Indent Line".CalcFields("Qty Issued");
                            PostedGateEntryHed.Reset();
                            PostedGateEntryHed.SetRange("Indent Document No", "Indent Line"."Document No.");
                            PostedGateEntryHed.SetRange("Indent Line No", "Indent Line"."Line No.");
                            if PostedGateEntryHed.FindSet() then begin
                                repeat
                                    InwardRefNumber := PostedGateEntryHed."No.";
                                until PostedGateEntryHed.Next() = 0;
                            end;
                            // if ItemLedgerEntries.Get('5368') then
                            Clear(No2);
                            FindAppliedEntries(ItemLedgerEntries, TempItemLedgerEntry);


                            Users.Reset();
                            Users.SetRange("User Name", UserId);
                            if Users.FindFirst() then
                                username := Users."Full Name";

                            ValueEntryLVar.Reset();
                            ValueEntryLVar.SetRange("Item Ledger Entry No.", ItemLedgerEntries."Entry No.");
                            if ValueEntryLVar.FindFirst() then;

                            TotalAmount := ItemLedgerEntries.Quantity * ValueEntryLVar."Cost per Unit"; //B2BSCM30MAY2024
                            WindPa.Update(1, "Document No.");

                            TempExcelBuffer.NewRow();
                            SNo += 1;
                            TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn("Indent Header"."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Header"."Delivery Location", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Header"."Shortcut Dimension 1 Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn("Indent Header"."programme Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Header".Indentor, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text); //B2BKM14MAY2024
                            TempExcelBuffer.AddColumn("Indent Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                            TempExcelBuffer.AddColumn(ItemLedgerEntries."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(ItemLedgerEntries."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Line"."Quantity (Base)", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn("Indent Line"."Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            //TempExcelBuffer.AddColumn(ItemLedgerQty, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(ItemLedgerEntries.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(ValueEntryLVar."Cost per Unit", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(ABS(TotalAmount), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(No2, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(ItemLedgerEntries."Entry No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn("Indent Header".Purpose, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text); //B2BSCM30MAY2024
                        until ItemLedgerEntries.Next() = 0;
                end;
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
        InwardRefNumber: Code[100];//B2BSSD28MAR2023
        username: Text[50];//B2BSSD28MAR2023
        ILE: Record "Item Ledger Entry";
        DocumentNoVar: Code[50];
        ItemLedgerQty: Decimal;//B2BSCM31AUG2023

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
        TempExcelBuffer.AddColumn('Entry No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSCM30MAY2024
    end;

    procedure FindAppliedEntries(ItemLedgEntry: Record "Item Ledger Entry"; var TempItemLedgerEntry: Record "Item Ledger Entry" temporary)
    var
        ItemApplnEntry: Record "Item Application Entry";
    begin
        with ItemLedgEntry do
            if Positive then begin
                ItemApplnEntry.Reset();
                ItemApplnEntry.SetCurrentKey("Inbound Item Entry No.", "Outbound Item Entry No.", "Cost Application");
                ItemApplnEntry.SetRange("Inbound Item Entry No.", "Entry No.");
                ItemApplnEntry.SetFilter("Outbound Item Entry No.", '<>%1', 0);
                ItemApplnEntry.SetRange("Cost Application", true);
                if ItemApplnEntry.Find('-') then
                    repeat
                        InsertTempEntry(TempItemLedgerEntry, ItemApplnEntry."Outbound Item Entry No.", ItemApplnEntry.Quantity);
                    until ItemApplnEntry.Next() = 0;
            end else begin
                ItemApplnEntry.Reset();
                ItemApplnEntry.SetCurrentKey("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
                ItemApplnEntry.SetRange("Outbound Item Entry No.", "Entry No.");
                ItemApplnEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                ItemApplnEntry.SetRange("Cost Application", true);

                if ItemApplnEntry.Find('-') then
                    repeat
                        InsertTempEntry(TempItemLedgerEntry, ItemApplnEntry."Inbound Item Entry No.", -ItemApplnEntry.Quantity);
                        //DocumentGVAr := TempItemLedgerEntry."Document No.";
                        if PurchaseReceiptHeader.Get(TempItemLedgerEntry."Document No.") then begin
                            // if purchaseHeader.Get(PurchaseReceiptHeader."Order No.") then begin
                            GateEntryHeader_B2B.Reset();
                            GateEntryHeader_B2B.SetRange("Purchase Order No.", PurchaseReceiptHeader."Order No.");
                            GateEntryHeader_B2B.SetRange("Entry Type", GateEntryHeader_B2B."Entry Type"::Inward);
                            GateEntryHeader_B2B.SetRange(Type, GateEntryHeader_B2B.Type::RGP);
                            if GateEntryHeader_B2B.FindFirst() then
                                No2 := GateEntryHeader_B2B."No.";
                            // End;
                        End;

                    until ItemApplnEntry.Next() = 0;
            End;

    end;

    local procedure InsertTempEntry(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary; EntryNo: Integer; AppliedQty: Decimal)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        IsHandled: Boolean;
    begin
        ItemLedgEntry.Get(EntryNo);

        IsHandled := false;
        if IsHandled then
            exit;

        if AppliedQty * ItemLedgEntry.Quantity < 0 then
            exit;

        if not TempItemLedgerEntry.Get(EntryNo) then begin
            TempItemLedgerEntry.Init();
            TempItemLedgerEntry := ItemLedgEntry;
            TempItemLedgerEntry.Quantity := AppliedQty;
            TempItemLedgerEntry.Insert();
        end else begin
            TempItemLedgerEntry.Quantity := TempItemLedgerEntry.Quantity + AppliedQty;
            TempItemLedgerEntry.Modify();
        end;
    end;

    var
        DocumentGVAr: Code[20];
        PurchaseReceiptHeader: Record "Purch. Rcpt. Header";
        purchaseHeader: Record "Purchase Header";
        GateEntryHeader_B2B: Record "Posted Gate Entry Header_B2B";
        No2: Code[20];
        TotalAmount: Decimal;
}