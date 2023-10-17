report 50194 "GRN Register"//B2BSSD14JUN2023
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'GRN Register_50194';

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {

            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Purch. Rcpt. Header";
                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    GRNno: Code[20];
                    GRNDate: Date;
                    RgpInwardNo: Code[20];
                    RgpInwardDate: Date;
                    RgpInwardRecieptDate: Date;
                    TotalAmount: Decimal;

                begin
                    PostedPurchRcptGRec.Reset();
                    PostedPurchRcptGRec.SetRange("Order No.", "Order No.");
                    if PostedPurchRcptGRec.FindSet() then begin
                        repeat
                            GRNno := PostedPurchRcptGRec."No.";
                            GRNDate := PostedPurchRcptGRec."Document Date";
                            GSTSetup.Get();
                            GetGSTAmounts("Purch. Rcpt. Line", GSTSetup);
                            TotalAmount := TotalGSTAmount + ("Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Direct Unit Cost");
                        until PostedPurchRcptGRec.Next() = 0;
                        PostedRGPInwardGRec.Reset();
                        PostedRGPInwardGRec.SetRange("Purchase Order No.", PostedPurchRcptGRec."Order No.");

                        if PostedRGPInwardGRec.findset() then begin
                            repeat
                                RgpInwardRecieptDate := PostedRGPInwardGRec."Receipt Date";
                                RgpInwardNo := PostedRGPInwardGRec."No.";
                                RgpInwardDate := PostedRGPInwardGRec."Document Date";
                            until PostedRGPInwardGRec.Next() = 0;

                        end;

                    end;


                    if Item.Get("No.") then;
                    SNo += 1;
                    TempExcelBuffer.NewRow();
                    TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(RgpInwardNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn(RgpInwardDate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);

                    TempExcelBuffer.AddColumn(RgpInwardRecieptDate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(GRNno, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(GRNDate, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Header"."Pay-to Name", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Header"."Vendor Invoice No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD03APR2023
                    TempExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    // TempExcelBuffer.AddColumn("Purch. Rcpt. Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSCM19SEP2023
                    // TempExcelBuffer.AddColumn("Purch. Rcpt. Line"."No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSCM19SEP2023
                    TempExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Line"."Direct Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Line"."Line Discount %", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(CGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(SGSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(IGSSTAmt, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(("Purch. Rcpt. Line".Quantity * "Purch. Rcpt. Line"."Direct Unit Cost"), FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn(TotalAmount, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Header"."Import Type", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Header"."EPCG Scheme", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Purch. Rcpt. Header"."Order No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                end;
            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
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
                group("Date Filter")
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
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
        TempExcelBuffer.CreateBookAndOpenExcel('', 'GRN Register', '', COMPANYNAME, USERID);
    end;

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
        TempExcelBuffer.AddColumn('GRN Register', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('GRN Register: ' + Format(StartDate) + ' to ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('SNO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INWARD NO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INWARD DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RECEIPT DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GRN NO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GRN Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SUPPLIER NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INVOICE NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INVOICE DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CATEGORY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM CODE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('ITEM NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('UOM', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('QTY', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('RATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('DISCOUNT %', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IGST', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('BASIC AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TOTAL AMOUNT', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('NARRATION', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IMPORT STATUS', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('EPCG SHEME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('REFERENCE NO', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
    end;

    var
        StartDate: Date;
        EndDate: Date;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        WindPa: Dialog;
        PurchaseLineGRec: Record "Purchase Line";
        PurchaseHeaderGRec: Record "Purchase Header";
        SNo: Integer;
        TotalAmount: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSSTAmt: Decimal;
        SourceNoGvar: Text;
        GRNNOGvar: Code[20];
        GRNDateGVar: Date;
        PostedPurchRcptGRec: Record "Purch. Rcpt. Header";
        PostedRGPInwardGRec: Record "Posted Gate Entry Header_B2B";
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        TotalGSTAmount: Decimal;
        GSTSetup: Record "GST Setup";
        CGSTBaseAmont: Decimal;
        SGSTBaseAmount: Decimal;
        IGSTBaseAmount: Decimal;

    procedure GetGSTAmounts(PurchInvLine: Record "Purch. Rcpt. Line";
    GSTSetup: Record "GST Setup")
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.setrange("Document No.", PurchInvLine."Document No.");
        DetailedGSTLedgerEntry.SetRange("Document Line No.", PurchInvLine."Line No.");
        if DetailedGSTLedgerEntry.FindSet() then begin
            repeat
                Clear(IGSSTAmt);
                Clear(SGSTAmt);
                Clear(CGSTAmt);
                case DetailedGSTLedgerEntry."GST Component Code" of
                    'CGST':
                        begin
                            CGSTAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
                            //CGSTPer += DetailedGSTLedgerEntry."GST %";
                            if abs(DetailedGSTLedgerEntry."GST Amount") <> 0 then
                                CGSTBaseAmont += Round(Abs(DetailedGSTLedgerEntry."GST Base Amount"), 0.01);
                        end;
                    'SGST':
                        begin
                            SGSTAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
                            //SGSTPer += DetailedGSTLedgerEntry."GST %";
                            if abs(DetailedGSTLedgerEntry."GST Amount") <> 0 then
                                SGSTBaseAmount += Round(Abs(DetailedGSTLedgerEntry."GST Base Amount"), 0.01);
                        end;
                    'IGST':
                        begin
                            IGSTAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
                            //IGSTPer += DetailedGSTLedgerEntry."GST %";
                            if abs(DetailedGSTLedgerEntry."GST Amount") <> 0 then
                                IGSTBaseAmount += Round(Abs(DetailedGSTLedgerEntry."GST Base Amount"), 0.01);
                        end;
                end;
            until DetailedGSTLedgerEntry.Next() = 0;
            TotalGSTAmount := CGSTAmount + SGSTAmount + IGSTAmount;
        end;
    end;
}