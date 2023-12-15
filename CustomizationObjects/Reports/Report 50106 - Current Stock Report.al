report 50106 "Current Stock Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Category Wise Stock Summary_50106';

    dataset
    {

        dataitem(item; Item)
        {
            DataItemTableView = sorting("Item Category Code");
            RequestFilterFields = "Item Category Code", "No.";
            trigger OnAfterGetRecord()
            var

            begin

                clear(Itemnumber);
                NewStartDate := CALCDATE('-1D', StartDate);
                //B2BSSD23MAY2023>>

                // ItemVariant.Reset();
                //  ItemVariant.SetRange("Item No.", Item."No.");
                //if ItemVariant.FindFirst() then begin
                // repeat
                //B2BSDec152023
                ItemLedgerEntry1.Reset();
                ItemLedgerEntry1.SetRange("Item No.", "No.");
                ItemLedgerEntry1.SetRange("Location Code", LocationGvar);
                ItemLedgerEntry1.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                ItemLedgerEntry1.SetCurrentKey("Item No.", "Variant Code");
                if ItemLedgerEntry1.FindSet() then begin
                    Clear(Openingstock);
                    Clear(InwardStock);
                    Clear(OutwardStock);
                    Clear(ClosingStock);
                    Clear(Unitrate);
                    Clear(variantcode);
                    Clear(UnitRateNew);
                    Clear(UnitRateInwardStock);
                    Clear(UnitRateInwardStockNew);
                    Clear(UnitRateOutWardStock);
                    Clear(UnitRateOutWardStockNew);
                    Clear(unitRateClosingStocNew);
                    Clear(unitRateClosingStoc);
                    if (PrevItemNo <> ItemLedgerEntry1."Item No.") or (PrevVariantCode <> ItemLedgerEntry1."Variant Code") then begin
                        variantcode := ItemLedgerEntry1."Variant Code";
                        Itemnumber := ItemLedgerEntry1."Item No.";
                        //B2BSSD23MAY2023<<
                        Clear(ItemLedgerEntryCount);
                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);
                        ItemLedgerEntry.SetRange("Variant Code", ItemLedgerEntry1."Variant Code");
                        ItemLedgerEntry.SETFILTER("Posting Date", '..%1', NewStartDate);
                        //ItemLedgerEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);//B2BSSD08JUN2023

                        IF ItemLedgerEntry.FINDSET THEN begin
                            ItemLedgerEntryCount := ItemLedgerEntry.Count;
                            ItemLedgerEntry.CalcSums("Remaining Quantity");
                            Openingstock := ItemLedgerEntry."Remaining Quantity";
                            repeat
                                ValueEntryGrec.Reset();
                                ValueEntryGrec.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                                if ValueEntryGrec.FindFirst() then begin
                                    Unitrate += ValueEntryGrec."Cost per Unit";
                                end;
                            until ItemLedgerEntry.Next() = 0;
                            UnitRateNew := Unitrate / ItemLedgerEntryCount;
                        end;

                        //if Openingstock = 0 then
                        //    CurrReport.Skip();
                        Clear(ItemLedgerEntryCount);
                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETRANGE("Item No.", ItemLedgerEntry1."Item No.");
                        ItemLedgerEntry.SetRange("Variant Code", ItemLedgerEntry1."Variant Code");
                        ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);//B2BSSD16MAY2023
                        ItemLedgerEntry.FilterGroup(-1);
                        ItemLedgerEntry.SetFilter("Document Type", '%1', ItemLedgerEntry."Document Type"::"Purchase Receipt");
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::"Positive Adjmt.");
                        IF ItemLedgerEntry.FINDSET THEN begin
                            ItemLedgerEntry.CalcSums(Quantity);
                            InwardStock := ItemLedgerEntry.Quantity;
                            ItemLedgerEntryCount := ItemLedgerEntry.Count;
                            repeat
                                ValueEntryGrec.Reset();
                                ValueEntryGrec.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                                if ValueEntryGrec.FindFirst() then begin
                                    UnitRateInwardStock += ValueEntryGrec."Cost per Unit";
                                end;
                            until ItemLedgerEntry.Next() = 0;
                            UnitRateInwardStockNew := Unitrate / ItemLedgerEntryCount;
                        end;
                        //B2BSDec152023
                        /* ItemLedgerEntry.RESET;
                         ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                         ItemLedgerEntry.SetRange("Variant Code", variantcode);
                         ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                         ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);//B2BSSD16MAY2023
                         ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::"Positive Adjmt.",
                                                                          ItemLedgerEntry."Entry Type"::Output);
                         IF ItemLedgerEntry.FINDSET THEN begin
                             ItemLedgerEntry.CalcSums(Quantity);
                             InwardStock := ItemLedgerEntry.Quantity;
                         end;*/
                        //B2BSDec152023
                        Clear(ItemLedgerEntryCount);
                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETRANGE("Item No.", ItemLedgerEntry1."Item No.");
                        ItemLedgerEntry.SetRange("Variant Code", ItemLedgerEntry1."Variant Code");
                        ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                        ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);//B2BSSD16MAY2023
                        ItemLedgerEntry.SetFilter("Entry Type", '%1', ItemLedgerEntry."Entry Type"::"Negative Adjmt.");
                        IF ItemLedgerEntry.FINDSET THEN begin
                            ItemLedgerEntry.CalcSums(Quantity);
                            OutwardStock := ABS(ItemLedgerEntry.Quantity);
                            ItemLedgerEntryCount := ItemLedgerEntry.Count;
                            repeat
                                ValueEntryGrec.Reset();
                                ValueEntryGrec.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                                if ValueEntryGrec.FindFirst() then begin
                                    UnitRateOutWardStock += ValueEntryGrec."Cost per Unit";
                                end;
                            until ItemLedgerEntry.Next() = 0;
                            UnitRateInwardStockNew := Unitrate / ItemLedgerEntryCount;
                        end;
                        //B2BSDec152023
                        /* ItemLedgerEntry.RESET;
                         ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                         ItemLedgerEntry.SetRange("Variant Code", variantcode);
                         ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                         ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);//B2BSSD16MAY2023
                         ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::"Negative Adjmt.",
                                                                          ItemLedgerEntry."Entry Type"::Consumption);
                         IF ItemLedgerEntry.FINDSET THEN begin
                             repeat
                                 OutwardStock += ABS(ItemLedgerEntry.Quantity);
                             until ItemLedgerEntry.Next() = 0;
                         end;*/
                        if ItemVariant.Get(ItemLedgerEntry1."Variant Code") then
                            Make := ItemVariant.Description;

                        ClosingStock := (Openingstock + InwardStock) - OutwardStock;
                        unitRateClosingStocNew := (Round(Openingstock * UnitRateNew, 0.01) + Round(InwardStock * UnitRateInwardStockNew, 0.01)) - Round(OutwardStock * UnitRateOutWardStockNew, 0.01);
                        if ClosingStock <> 0 then
                            unitRateClosingStoc := ((Round(Openingstock * UnitRateNew, 0.01) + Round(InwardStock * UnitRateInwardStockNew, 0.01)) - Round(OutwardStock * UnitRateOutWardStockNew, 0.01)) / ClosingStock
                        else
                            unitRateClosingStoc := 0;
                        if ((Openingstock = 0) AND (InwardStock = 0) AND (OutwardStock = 0) AND (ClosingStock = 0)) then
                            CurrReport.Skip()
                        else
                            SNo += 1;
                        WindPa.Update(1, Item."No.");
                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Make, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSS19Jan2023
                        TempExcelBuffer.AddColumn(Item."Base Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                        TempExcelBuffer.AddColumn(Openingstock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(UnitRateNew, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD15MAY2023
                        TempExcelBuffer.AddColumn(Round(Openingstock * UnitRateNew, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD15MAY2023
                        TempExcelBuffer.AddColumn(InwardStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(UnitRateInwardStockNew, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD15MAY2023
                        TempExcelBuffer.AddColumn(Round(InwardStock * UnitRateInwardStockNew, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD15MAY2023
                        TempExcelBuffer.AddColumn(OutwardStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(UnitRateOutWardStockNew, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD15MAY2023
                        TempExcelBuffer.AddColumn(Round(OutwardStock * UnitRateOutWardStockNew, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD15MAY2023
                        TempExcelBuffer.AddColumn(ClosingStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(unitRateClosingStoc, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD15MAY2023
                        TempExcelBuffer.AddColumn(Round(unitRateClosingStocNew, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//b2bSSD15MAY2023
                        TempExcelBuffer.AddColumn(LocationGvar, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD16MAY2023
                    end;
                end;                                                                                                         //until ItemVariant.Next() = 0;

                /*  end else
                      //B2BSSD23MAY2023>>
                      if item."No." <> Itemnumber then begin
                          Itemnumber := item."No.";
                          ItemLedgerEntry1.Reset();
                          ItemLedgerEntry1.SetRange("Item No.", Itemnumber);
                          ItemLedgerEntry1.SetRange("Location Code", LocationGvar);
                          ItemLedgerEntry1.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                          if ItemLedgerEntry1.FindSet() then begin
                              repeat
                                  Clear(Openingstock);
                                  Clear(InwardStock);
                                  Clear(OutwardStock);
                                  Clear(ClosingStock);
                                  Clear(Unitrate);
                                  Clear(variantcode);
                                  Clear(EntryNumber);
                                  ItemLedgerEntry.RESET;
                                  ItemLedgerEntry.SETRANGE("Item No.", ItemLedgerEntry1."Item No.");
                                  ItemLedgerEntry.SetRange("Entry No.", ItemLedgerEntry1."Entry No.");
                                  ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);
                                  //ItemLedgerEntry.SetFilter("Posting Date", '<%1', StartDate);
                                  ItemLedgerEntry.SetFilter("Posting Date", '%1..%2', StartDate, EndDate);//B2BSSD08JUN2023
                                  IF ItemLedgerEntry.FINDSET THEN begin
                                      //ItemLedgerEntry.CalcSums(Quantity);
                                      Openingstock := ItemLedgerEntry.Quantity;
                                      ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                                      Unitrate := Round(ItemLedgerEntry."Cost Amount (Actual)" / ItemLedgerEntry.Quantity, 0.001);
                                      EntryNumber := ItemLedgerEntry."Entry No.";
                                  end;
                                  ItemLedgerEntry.RESET;
                                  ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                                  ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                                  ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);
                                  ItemLedgerEntry.SetFilter("Document Type", '%1|%2|%3|%4|%5', ItemLedgerEntry."Document Type"::"Purchase Invoice",
                                                                                               ItemLedgerEntry."Document Type"::"Purchase Receipt",
                                                                                               ItemLedgerEntry."Document Type"::"Sales Credit Memo",
                                                                                               ItemLedgerEntry."Document Type"::"Sales Return Receipt",
                                                                                               ItemLedgerEntry."Document Type"::"Transfer Receipt");
                                  IF ItemLedgerEntry.FINDSET THEN begin
                                      ItemLedgerEntry.CalcSums(Quantity);
                                      InwardStock += ItemLedgerEntry.Quantity;
                                  end;
                                  ItemLedgerEntry.RESET;
                                  ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                                  ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                                  ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);
                                  ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::"Positive Adjmt.",
                                                                                   ItemLedgerEntry."Entry Type"::Output);
                                  IF ItemLedgerEntry.FINDSET THEN begin
                                      ItemLedgerEntry.CalcSums(Quantity);
                                      InwardStock += ItemLedgerEntry.Quantity;
                                  end;
                                  ItemLedgerEntry.RESET;
                                  ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                                  ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                                  ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);//B2BSSD16MAY2023
                                  ItemLedgerEntry.SetFilter("Document Type", '%1|%2|%3|%4|%5', ItemLedgerEntry."Document Type"::"Sales Invoice",
                                                                                               ItemLedgerEntry."Document Type"::"Sales Shipment",
                                                                                               ItemLedgerEntry."Document Type"::"Purchase Return Shipment",
                                                                                               ItemLedgerEntry."Document Type"::"Purchase Credit Memo",
                                                                                               ItemLedgerEntry."Document Type"::"Transfer Shipment");
                                  IF ItemLedgerEntry.FINDSET THEN begin
                                      repeat
                                          OutwardStock += ABS(ItemLedgerEntry.Quantity);
                                      until ItemLedgerEntry.Next() = 0;
                                  end;
                                  ItemLedgerEntry.RESET;
                                  ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                                  ItemLedgerEntry.SETFILTER("Posting Date", '%1..%2', StartDate, EndDate);
                                  ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", LocationGvar);//B2BSSD16MAY2023
                                  ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::"Negative Adjmt.",
                                                                                   ItemLedgerEntry."Entry Type"::Consumption);
                                  IF ItemLedgerEntry.FINDSET THEN begin
                                      repeat
                                          OutwardStock += ABS(ItemLedgerEntry.Quantity);
                                      until ItemLedgerEntry.Next() = 0;
                                  end;

                                  Make := ItemVariant.Description;

                                  ClosingStock := (Openingstock + InwardStock) - OutwardStock;

                                  if ((Openingstock = 0) AND (InwardStock = 0) AND (OutwardStock = 0) AND (ClosingStock = 0)) then
                                      CurrReport.Skip()
                                  else
                                      SNo += 1;
                                  WindPa.Update(1, Item."No.");
                                  TempExcelBuffer.NewRow();
                                  TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                  TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Make, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Item."Base Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                  TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                  TempExcelBuffer.AddColumn(Openingstock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Unitrate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Round(Openingstock * Unitrate, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(InwardStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Unitrate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Round(InwardStock * Unitrate, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(OutwardStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Unitrate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Round(OutwardStock * Unitrate, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(ClosingStock, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Unitrate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(Round(ClosingStock * Unitrate, 0.01), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                  TempExcelBuffer.AddColumn(LocationGvar, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                              //TempExcelBuffer.AddColumn(EntryNumber, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                              until ItemLedgerEntry1.Next() = 0;
                          end;
                      end;*/
                //B2BSSD23MAY2023<<
            end;

            trigger OnPreDataItem()
            var
            begin
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
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = all;
                        Caption = 'End Date';
                    }
                    field(LocationGvar; LocationGvar)
                    {
                        ApplicationArea = All;
                        TableRelation = Location;
                        Caption = 'Location';
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
        TempExcelBuffer.CreateBookAndOpenExcel('', 'Category Wise Stock', '', COMPANYNAME, USERID);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        WindPa: Dialog;
        SNo: Integer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntry1: Record "Item Ledger Entry";
        variantcode: code[20];
        ItemVariant: Record "Item Variant";
        Itemnumber: Code[20];
        EntryNumber: Integer;
        PrevItemNo: Text;
        PrevVariantCode: Text;
        IndentHeader: Record "Indent Header";
        Users: Record User;
        FixedAsset: Record "Fixed Asset";
        NewStartDate: Date;
        Openingstock: Decimal;
        InwardStock: Decimal;
        OutwardStock: Decimal;
        ClosingStock: Decimal;
        ValuEntryLRec: Record "Value Entry";
        Make: Code[50];
        LocationGvar: Code[10];//B2BSSD16MAY2023
        Unitrate: Decimal;
        UnitRateInwardStock: Decimal;
        UnitRateOutWardStock: Decimal;
        UnitRateInwardStockNew: Decimal;
        UnitRateOutWardStockNew: Decimal;
        unitRateClosingStocNew: Decimal;
        unitRateClosingStoc: Decimal;
        Count: Integer;
        ItemLedgerEntryCount: Integer;
        ValueEntryGrec: Record "Value Entry";
        UnitRateNew: Decimal;

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
        TempExcelBuffer.AddColumn('Category Wise Stock Summary', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('Stock Summary: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Particulars', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Opening Stock', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Inwards', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Outwards', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Closing Stock', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNo.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CATEGORY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('MAKE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CATEGORY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('STOCK VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('STOCK VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('STOCK VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QUANTITY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UNIT RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('STOCK VALUE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD16MAY2023
        //TempExcelBuffer.AddColumn('Entry No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;



}