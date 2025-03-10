report 50192 "FixedAssets&Item LocationWise" //B2BSSD09MAY2023
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Fixed Assets & Item Location Wise Tracking';

    dataset
    {

        dataitem(Integer; Integer)
        {
            MaxIteration = 1;
            trigger OnAfterGetRecord()
            begin
                Clear(RemainingQty);
                if DocumentType = DocumentType::FixedAsset then begin
                    //Clear(PostedRGPNo);
                    FixedAsset.Reset();
                    FixedAsset.SetRange("FA Location Code", FAlocationcode);//B2BSSD10AUG2023
                    FixedAsset.SetRange("available/Unavailable", "Avail&UnAvail");
                    if FixedAsset.FindSet() then begin
                        repeat
                            Clear(PostedRGPNo);
                            Clear(expectedReturnDate);
                            Clear(FromLocation);
                            Clear(ToLocation);
                            PostedRgpoutward.Reset();
                            PostedRgpoutward.SetRange(Type, PostedRgpoutward.type::RGP);
                            PostedRgpoutward.SetRange("Entry Type", PostedRgpoutward."Entry Type"::Outward);
                            PostedRgpoutward.SetRange("Source Type", PostedRgpoutward."Source Type"::"Fixed Asset");
                            PostedRgpoutward.SetRange("Source No.", FixedAsset."No.");
                            if PostedRgpoutward.FindFirst() then begin
                                PostedRGPNo := PostedRgpoutward."Gate Entry No.";
                                POstedRGpOutwardHeaderGVar.RESET();
                                postedRGpOutwardHeaderGVar.SETRANGE("No.", PostedRgpoutward."Gate Entry No.");
                                if POstedRGpOutwardHeaderGVar.FindFirst() then begin
                                    ExpectedReturnDate := POstedRGpOutwardHeaderGVar.ExpectedDateofReturn;
                                    FromLocation := POstedRGpOutwardHeaderGVar."Location Code";
                                    ToLocation := POstedRGpOutwardHeaderGVar."To Location";
                                end;
                                //B2BSSD18MAY2023<<
                            end;
                            SNo += 1;
                            WindPa.Update(1, FixedAsset."No.");
                            TempExcelBuffer.NewRow();
                            TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                            TempExcelBuffer.AddColumn(FixedAsset."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FixedAsset.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FixedAsset."FA Location Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FixedAsset."Model No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FixedAsset."Serial No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FixedAsset.Make_B2B, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                             if FixedAsset."available/Unavailable" = false then
                                status1 := 'Available'
                            else
                                if FixedAsset."available/Unavailable" = true then
                                    status1 := 'Unavailable'; 
                            TempExcelBuffer.AddColumn(status1, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(PostedRGPNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(ExpectedReturnDate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(FromLocation, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                            TempExcelBuffer.AddColumn(ToLocation, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                        //B2BSSD18MAY2023<<
                        until FixedAsset.Next() = 0;
                    end;
                end else
                    if DocumentType = DocumentType::Item then begin
                        Item.Reset();
                        Item.SetRange("Location Filter", LocationCode);
                        if ItemCategoryCode <> '' then
                            Item.SetRange("Item Category Code", ItemCategoryCode);
                        if Item.FindSet() then begin
                            repeat
                                Clear(TotalRemainingQty);
                                Clear(RemainingQty);
                                Clear(PostedRGPNo);
                                Clear(expectedReturnDate);
                                Clear(FromLocation);
                                Clear(ToLocation);
                                ItemLedgerEntryGVar.RESET;
                                ItemLedgerEntryGVar.SETRANGE("Item No.", Item."No.");
                                //ItemLedgerEntryGVar.SetRange("Location Code", LocationCode);
                                IF ItemLedgerEntryGVar.FINDSET THEN begin
                                    ItemLedgerEntryGVar.CalcSums(Quantity);
                                    TotalRemainingQty := ItemLedgerEntryGVar.Quantity;
                                end;

                                PostedRgpoutward.Reset();
                                PostedRgpoutward.SetRange(Type, PostedRgpoutward.type::RGP);
                                PostedRgpoutward.SetRange("Entry Type", PostedRgpoutward."Entry Type"::Outward);
                                PostedRgpoutward.SetRange("Source Type", PostedRgpoutward."Source Type"::Item);
                                PostedRgpoutward.SetRange("Source No.", Item."No.");
                                if PostedRgpoutward.FindFirst() then begin
                                    PostedRGPNo := PostedRgpoutward."Gate Entry No.";
                                    POstedRGpOutwardHeaderGVar.RESET();
                                    postedRGpOutwardHeaderGVar.SETRANGE("No.", PostedRgpoutward."Gate Entry No.");
                                    if POstedRGpOutwardHeaderGVar.FindFirst() then begin
                                        ExpectedReturnDate := POstedRGpOutwardHeaderGVar.ExpectedDateofReturn;
                                        FromLocation := POstedRGpOutwardHeaderGVar."Location Code";
                                        ToLocation := POstedRGpOutwardHeaderGVar."To Location";
                                    end;
                                end;

                                ItemLedgerEntryGVar.RESET;
                                ItemLedgerEntryGVar.SETRANGE("Item No.", Item."No.");
                                ItemLedgerEntryGVar.SetRange(ItemLedgerEntryGVar."Location Code", LocationCode);//B2BSSD16MAY2023
                                IF ItemLedgerEntryGVar.FINDSET THEN begin
                                    ItemLedgerEntryGVar.CalcSums(Quantity);
                                    RemainingQty := ItemLedgerEntryGVar.Quantity;
                                    SNo += 1;
                                    WindPa.Update(1, Item."No.");
                                    TempExcelBuffer.NewRow();
                                    TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(LocationCode, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(RemainingQty, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(TotalRemainingQty, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                                    TempExcelBuffer.AddColumn(PostedRGPNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(ExpectedReturnDate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(FromLocation, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                    TempExcelBuffer.AddColumn(ToLocation, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                                end;
                            until Item.Next() = 0;
                        end;
                    end;
            end;

            trigger OnPreDataItem()
            var
                Error1: TextConst ENN = 'Document type Must Be Have a Value';
            begin
                if DocumentType = DocumentType::" " then begin
                    Error(Error1);
                end;
                if DocumentType = DocumentType::FixedAsset then begin
                    FAMakeExcelHeader();
                end Else
                    if DocumentType = DocumentType::Item then begin
                        ItemMakeExcelHeader();
                    end;
            end;
        }
        //B2BSSD17MAY2023>>
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Avail&UnAvail"; "Avail&UnAvail")
                    {
                        ApplicationArea = All;
                        Caption = 'Available & UnAvaiulable';
                    }
                    //B2BSSD17MAY2023>>
                    field(DocumentType; DocumentType)
                    {
                        ApplicationArea = All;
                        Caption = 'Document Type';
                    }
                    field(FAlocationcode; FAlocationcode)
                    {
                        ApplicationArea = All;
                        Caption = 'FA Location';
                        TableRelation = "FA Location".Code;
                    }
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = All;
                        TableRelation = Location;
                        Caption = 'Location Code';
                    }
                    field(ItemCategoryCode; ItemCategoryCode)
                    {
                        ApplicationArea = All;
                        TableRelation = "Item Category";
                        Caption = 'Item Category Code';
                    }
                    //B2BSSD17MAY2023<<
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
        //B2BSSD17MAY2023>>
        if DocumentType = DocumentType::FixedAsset then begin
            TempExcelBuffer.CreateBookAndOpenExcel('', 'Fixed Assest', '', COMPANYNAME, USERID);
            WindPa.CLOSE();
            TempExcelBuffer.SetFriendlyFilename('Fixed Assest Location Wise Status Report');
            TempExcelBuffer.OpenExcel();
        end else
            if DocumentType = DocumentType::Item then begin
                TempExcelBuffer.CreateBookAndOpenExcel('', 'Items', '', COMPANYNAME, USERID);
                WindPa.CLOSE();
                TempExcelBuffer.SetFriendlyFilename('Item Location Wise Report');
                TempExcelBuffer.OpenExcel();
            end;
        //B2BSSD17MAY2023<<
    end;

    procedure FAMakeExcelHeader()
    begin
        if DocumentType = DocumentType::FixedAsset then begin
            WindPa.OPEN('Processing #1###############');
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('ASSET LOCATION WISE STATUS REPORT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('SNo.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Serial No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Make', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Model No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Status', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('NRGP/RGP OutWard No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Expected Date of Return', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('From Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('To Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        end;
    end;
    //B2BSSD17MAY2023>>
    procedure ItemMakeExcelHeader()
    begin
        if DocumentType = DocumentType::Item then begin
            WindPa.OPEN('Processing #1###############');
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Item Location Wise Report', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn('SNo.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Item Category Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Location Wise Quantity', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('TotalQuantity', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('RGP OutWard No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('Expected Date of Return', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('From Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn('To Location', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        end;
    end;
    //B2BSSD17MAY2023<<

    var
        RemainingQty: Integer;
        TotalRemainingQty: Decimal;
        ItemLedgerEntryGVar: Record "Item Ledger Entry";
        Available: Boolean;
        Unavailable: Boolean;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        WindPa: Dialog;
        SNo: Integer;
        LocationCode: Code[10];
        PostedRgpoutward: Record "Posted Gate Entry Line_B2B";
        POstedRGpOutwardHeaderGVar: Record "Posted Gate Entry Header_B2B";
        PostedRGPNo: Code[20];
        DocumentType: Option " ",FixedAsset,Item;
        ExpectedReturnDate: Date;
        FromLocation: Code[10];
        ToLocation: Code[10];
        Status: Option Available,UnAvailable;
        status1: Text[20];
        FixedAsset: Record "Fixed Asset";
        Item: Record Item;
        "Avail&UnAvail": Boolean;
        ItemCategoryCode: Code[20];
        FAlocationcode: Text[30];
}