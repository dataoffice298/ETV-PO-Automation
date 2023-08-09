report 50196 "Fixed Assets Register New"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './FixedAssetsRegisterNew.rdl';
    Caption = 'Fixed Assets Register Report New';

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.";
            column(StartDateEndDate; 'From  ' + Format(StartDate) + '  To  ' + Format(EndDate))
            {
            }
            column(grecCompInfo_Name; grecCompInfo.Name)
            {
            }
            column(TodayDate; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            column(PageNo; CurrReport.PageNo)
            {
            }
            column(StartDate; CalcDate('-1D', StartDate))
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(ABS_TotalGrossValueUptoYear; Abs(TotalGrossValueUptoYear))
            {
            }
            column(ABS_TotalAditionDuringYear; Abs(TotalAditionDuringYear))
            {
            }
            column(ABS_TotalGrossValueatYearEnd; Abs(TotalGrossValueatYearEnd))
            {
            }
            column(ABS_TotalAcctdDepratPeriodBegin; Abs(TotalAcctdDepratPeriodBegin))
            {
            }
            column(ABS_TotalDeprForPeriod; Abs(TotalDeprForPeriod))
            {
            }
            column(ABS_TotalAcctdDepratPeriodEnd; Abs(TotalAcctdDepratPeriodEnd))
            {
            }
            column(TotalNetClassAsOnEndDate; (TotalNetClassAsOnEndDate))
            {
            }
            column(ABS_TotalDeletionDuringYear; Abs(TotalDeletionDuringYear))
            {
            }
            column(TotalNetClassUptoStartDate; (TotalNetClassUptoStartDate))
            {
            }
            column(ABS_TotalDeprForPeriod2; Abs(TotalDeprForPeriod))
            {
            }
            column(ResponsibleCaption; ResponsibleCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(SNoCaption; SNoCaptionLbl)
            {
            }
            column(AdditionCaption; AdditionCaptionLbl)
            {
            }
            column(AccumulatedBeginCaption; AccumulatedBeginCaptionLbl)
            {
            }
            column(AccumulatedEndCaption; AccumulatedEndCaptionLbl)
            {
            }
            column(DepreCaption; DepreCaptionLbl)
            {
            }
            column(GrossValueEndCaption; GrossValueEndCaptionLbl)
            {
            }
            column(GrossValueBeginCaption; GrossValueBeginCaptionLbl)
            {
            }
            column(AssetClassCaption; AssetClassCaptionLbl)
            {
            }
            column(GrossCalssCaption; GrossCalssCaptionLbl)
            {
            }
            column(DepreciationCaption; DepreciationCaptionLbl)
            {
            }
            column(FixedAsstCaption; FixedAsstCaptionLbl)
            {
            }
            column(CurrReportCaption; CurrReportCaptionLbl)
            {
            }
            column(AsserSubClassCaption; AsserSubClassCaptionLbl)
            {
            }
            column(DeletnCaption; DeletnCaptionLbl)
            {
            }
            column(RsCaption; RsCaptionLbl)
            {
            }
            column(RsControlCaption; RsControlCaptionLbl)
            {
            }
            column(AssetCodeCaption; AssetCodeCaptionLbl)
            {
            }
            column(CapitalizationDateCaption; CapitalizationDateCaptionLbl)
            {
            }
            column(FALocationCaption; FALocationCaptionLbl)
            {
            }
            column(SerialNoCaption; SerialNoCaptionLbl)
            {
            }
            column(AcquisitionDateCaption; AcquisitionDateCaptionLbl)
            {
            }
            column(AccDepreciationCaption; AccDepreciationCaptionLbl)
            {
            }
            column(GrandTotalCaption; GrandTotalCaptionLbl)
            {
            }
            column(Fixed_Asset_No_; "No.")
            {
            }
            dataitem("FA Ledger Entry"; "FA Ledger Entry")
            {
                DataItemLink = "FA No." = FIELD("No.");
                DataItemTableView = SORTING("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date", "Part of Book Value", "Reclassification Entry") ORDER(Ascending);
                column(SrNum; SrNum)
                {
                }
                column(FixedAsset_FAClassCode; "Fixed Asset"."FA Class Code")
                {
                }
                column(ABS_GrossValueUptoYear; Abs(GrossValueUptoYear))
                {
                }
                column(ABS_AditionDuringYear; Abs(AditionDuringYear))
                {
                }
                column(ABS_GrossValueatYearEnd; Abs(GrossValueatYearEnd))
                {
                }
                column(ABS_AcctdDepratPeriodBegin; Abs(AcctdDepratPeriodBegin))
                {
                }
                column(ABS_DeprForPeriod; Abs(DeprForPeriod))
                {
                }
                column(ABS_AcctdDepratPeriodEnd; Abs(AcctdDepratPeriodEnd))
                {
                }
                column(NetClassAsOnEndDate; (NetClassAsOnEndDate))
                {
                }
                column(FixedAsset_FASubclassCode; "Fixed Asset"."FA Subclass Code")
                {
                }
                column(ABS_DeletionDuringYear; Abs(DeletionDuringYear))
                {
                }
                column(NetClassUptoStartDate; (NetClassUptoStartDate))
                {
                }
                column(FixedAsset_Description; "Fixed Asset".Description)
                {
                }
                column(FixedAsset_No; "Fixed Asset"."No.")
                {
                }
                column(grecFADeprBook_AcquisitionDate; grecFADeprBook."Acquisition Date")
                {
                }
                column(grecFADeprBook_DepreciationStartingDate; grecFADeprBook."Depreciation Starting Date")
                {
                }
                column(gtxtEmployeeName; gtxtEmployeeName)
                {
                }
                column(FixedAsset_SerialNo; "Fixed Asset"."Serial No.")
                {
                }
                column(grecFALocation_Name; grecFALocation.Name)
                {
                }
                column(ABS_DeprDisposedAssests; Abs(DeprDisposedAssests))
                {
                }
                column(FALedgerEntry_EntryNo; "Entry No.")
                {
                }
                column(FALedgerEntry_FANo; "FA No.")
                {
                }

                trigger OnPostDataItem()
                begin
                    if gboolPrintInExcel then
                        MakeExcelDataBody;
                    MakeExcelDataFooter;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //**VIAON1.00.16**CUSTMISC**002**210710**NR [Begin]
                if not FADeprBook.Get("No.", 'COMPANY') then
                    CurrReport.Skip;
                if SkipRecord then
                    CurrReport.Skip;
                //**VIAON1.00.16**CUSTMISC**002**210710**NR [End]

                SrNum += 1;
                FALedgerEntry.Reset;
                FALedgerEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date",
                              "Part of Book Value", "Reclassification Entry");
                FALedgerEntry.SetRange("FA No.", "No.");
                FALedgerEntry.SetRange("Depreciation Book Code", 'COMPANY');
                FALedgerEntry.SetFilter("FA Posting Date", '<%1', StartDate);
                FALedgerEntry.SetRange("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
                FALedgerEntry.SetFilter("FA Posting Type", '%1|%2|%3',
                  FALedgerEntry."FA Posting Type"::"Acquisition Cost",
                  FALedgerEntry."FA Posting Type"::Appreciation,
                  FALedgerEntry."FA Posting Type"::"Write-Down");

                FALedgerEntry.CalcSums(Amount);
                GrossValueUptoYear := FALedgerEntry.Amount;
                TotalGrossValueUptoYear += GrossValueUptoYear;



                FALedgerEntry.SetRange("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
                FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::Depreciation);
                FALedgerEntry.CalcSums(Amount);
                AcctdDepratPeriodBegin := Abs(FALedgerEntry.Amount);
                TotalAcctdDepratPeriodBegin += AcctdDepratPeriodBegin;

                FALedgerEntry.SetRange("FA Posting Date", StartDate, EndDate);
                FALedgerEntry.CalcSums(Amount);
                DeprForPeriod := Abs(FALedgerEntry.Amount);
                TotalDeprForPeriod += DeprForPeriod;

                FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::"Acquisition Cost");
                FALedgerEntry.CalcSums(Amount);
                AditionDuringYear := FALedgerEntry.Amount;
                TotalAditionDuringYear += AditionDuringYear;


                FALedgerEntry.SetFilter("FA Posting Category", '<>%1', FALedgerEntry."FA Posting Category"::" ");
                FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::"Acquisition Cost");
                FALedgerEntry.CalcSums(Amount);
                DeletionDuringYear := FALedgerEntry.Amount;
                TotalDeletionDuringYear += DeletionDuringYear;

                FALedgerEntry.SetRange("FA Posting Category", FALedgerEntry."FA Posting Category"::" ");
                FALedgerEntry.SetFilter("FA Posting Type", '%1|%2',
                  FALedgerEntry."FA Posting Type"::Appreciation,
                  FALedgerEntry."FA Posting Type"::"Write-Down");
                FALedgerEntry.CalcSums(Amount);
                Adjustment := FALedgerEntry.Amount;
                TotalAdjustment += Adjustment;


                FALedgerEntry.Reset;
                FALedgerEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "FA Posting Date",
                              "Part of Book Value", "Reclassification Entry");
                FALedgerEntry.SetRange("FA No.", "No.");
                FALedgerEntry.SetRange("Depreciation Book Code", 'COMPANY');
                FALedgerEntry.SetRange("FA Posting Date", StartDate, EndDate);
                FALedgerEntry.SetRange("FA Posting Category", FALedgerEntry."FA Posting Category"::Disposal);
                FALedgerEntry.SetFilter("FA Posting Type", '%1', FALedgerEntry."FA Posting Type"::Depreciation);
                FALedgerEntry.CalcSums(Amount);
                DeprDisposedAssests := FALedgerEntry.Amount;
                TotalDeprDisposedAssests += DeprDisposedAssests;


                GrossValueatYearEnd := GrossValueUptoYear + AditionDuringYear - Abs(DeletionDuringYear);
                TotalGrossValueatYearEnd += GrossValueatYearEnd;
                AcctdDepratPeriodEnd := AcctdDepratPeriodBegin + Abs(DeprForPeriod) - Abs(DeprDisposedAssests);
                TotalAcctdDepratPeriodEnd += AcctdDepratPeriodEnd;
                NetClassAsOnEndDate := GrossValueatYearEnd - Abs(AcctdDepratPeriodEnd);
                TotalNetClassAsOnEndDate += NetClassAsOnEndDate;
                NetClassUptoStartDate := GrossValueUptoYear - Abs(AcctdDepratPeriodBegin);
                TotalNetClassUptoStartDate += NetClassUptoStartDate;

                //B2BSSD05JUN2023>>
                FALedgerEntry1.Reset();
                FALedgerEntry1.SetRange("FA No.", "Fixed Asset"."No.");
                FALedgerEntry1.SetRange("Document Type", FALedgerEntry."Document Type"::Invoice);
                if FALedgerEntry1.FindFirst() then
                    FALedgerEntry1.CalcFields("Vendor No.", "Vendor Name");
                VendorNo := FALedgerEntry1."Vendor No.";
                VendorName := FALedgerEntry1."Vendor Name";
                INVDocumentNO := FALedgerEntry1."Document No.";
                NetAssetValuebeforeDepreciaton := FALedgerEntry1.Amount;
                //B2BSSD05JUN2023<<


                // NewStartDate := CalcDate('-1D', StartDate);
                // FALedgerEntry1.Reset();
                // FALedgerEntry1.SetRange("FA No.", "Fixed Asset"."No.");
                // FALedgerEntry1.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::Depreciation);
                // FALedgerEntry1.SetFilter("Posting Date", '..1%', StartDate);
                // if FALedgerEntry1.FindSet() then begin
                //     repeat
                //         TotalNetClassUptoStartDate := FALedgerEntry1."Credit Amount";
                //     until FALedgerEntry1.next() = 0;
                // end;

                PostedPurchaseInvGrec.Reset();
                PostedPurchaseInvGrec.SetRange("No.", FALedgerEntry1."Document No.");
                if PostedPurchaseInvGrec.FindFirst() then begin
                    PostedPurchaseRecGrec.Reset();
                    PostedPurchaseRecGrec.SetRange("Order No.", PostedPurchaseInvGrec."Order No.");
                    if PostedPurchaseRecGrec.FindFirst() then
                        GRNNOGVar := PostedPurchaseRecGrec."No.";
                    GRNDateGvar := PostedPurchaseRecGrec."Document Date";
                    OrderNoGVar := PostedPurchaseRecGrec."Order No.";
                end;


                gtxtEmployeeName := '';
                grecEmployee.Reset;
                if grecEmployee.Get("Fixed Asset"."Responsible Employee") then begin
                    if grecEmployee."Middle Name" = '' then
                        gtxtEmployeeName := grecEmployee."First Name" + ' ' + grecEmployee."Last Name"
                    else
                        gtxtEmployeeName := grecEmployee."First Name" + ' ' + grecEmployee."Middle Name" + ' ' + grecEmployee."Last Name";
                end;

                Clear(grecFALocation);
                if grecFALocation.Get("FA Location Code") then;

                Clear(grecFADeprBook);
                if grecFADeprBook.Get("No.", 'COMPANY') then;


            end;

            trigger OnPreDataItem()
            begin
                if EndDate < StartDate then
                    Error(Text16501);

                if gboolPrintInExcel then
                    MakeExcelDataHeader;
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
                    field(gboolPrintInExcel; gboolPrintInExcel)
                    {
                        ApplicationArea = All;
                        Caption = 'Print To Excel';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        if gboolPrintInExcel then
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        if (StartDate = 0D) and (EndDate = 0D) then
            Error(Text16500);

        grecCompInfo.Get;
    end;

    procedure MakeExcelDataHeader()
    begin
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn(Format(Text003), false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(CompanyName, false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn(Format(Text004), false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Fixed Asset Detail', false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn(Format(Text005), false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(UserId, false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn(Format(Text006), false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Today, false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn(Format(Text007), false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(StartDate, false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn(Format(Text008), false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(EndDate, false, '', false, false, false, '', grecExcelBuffer."Cell Type");

        grecExcelBuffer.NewRow;
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn('Asset Class', false, '', true, false, true, '@', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Asset Sub Class', false, '', true, false, true, '@', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Asset Code', false, '', true, false, true, '@', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Description', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Make', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Model No.', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Serial No.', false, '', true, false, true, '@', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Acquisition Date', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Capitalization Date', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('FA Location', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('FA Sub Location', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JU2023
        grecExcelBuffer.AddColumn('Depreciation Starting Date', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JU2023
        grecExcelBuffer.AddColumn('Depreciation End Date', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JU2023
        grecExcelBuffer.AddColumn('Vendor No', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD07JUL2023
        grecExcelBuffer.AddColumn('Vendor Name', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Invoice No.', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Method of Depreciation', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Net Asset Value before Depreciaton', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Net Asset Value After Depreciation as on ' + Format(EndDate), false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('GRN No.', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('GRN Date.', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Order No.', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023 
        grecExcelBuffer.AddColumn('Salvage Value', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Life', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023<<
        grecExcelBuffer.AddColumn('Responsible Employee', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Gross Value at the Begining of the year (Rs.)', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Addition During the year (Rs.)', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Deletion During the year (Rs.)', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Gross Value at the end of year (Rs.)', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Accumulated Depreciation as on the beginning of the Year (Rs.)', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Depreciation for the period (Rs.)', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Acc. Depreciation on disposed assets', false, '', true, false, true, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('Accummulated Depreciation as on', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Accumulated Depreciation as on the end of the year (Rs.)', false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Net Class as on ' + Format(EndDate), false, '', true, false, true, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Net Class as on ' + Format(CalcDate('-1D', StartDate)), false, '', true, false, true, '', grecExcelBuffer."Cell Type");
    end;

    procedure MakeExcelDataBody()
    begin
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn("Fixed Asset"."FA Class Code", false, '', false, false, false, '@', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn("Fixed Asset"."FA Subclass Code", false, '', false, false, false, '@', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn("Fixed Asset"."No.", false, '', false, false, false, '@', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn("Fixed Asset".Description, false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn("Fixed Asset".Make_B2B, false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD07JUL2023
        grecExcelBuffer.AddColumn("Fixed Asset"."Model No.", false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD07JUL2023
        grecExcelBuffer.AddColumn("Fixed Asset"."Serial No.", false, '', false, false, false, '@', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(grecFADeprBook."Acquisition Date", false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(grecFADeprBook."Depreciation Starting Date", false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn("Fixed Asset"."FA Location Code", false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn("Fixed Asset"."FA Sub Location", false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD052023
        grecExcelBuffer.AddColumn(grecFADeprBook."Depreciation Starting Date", false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD07JUL2023
        grecExcelBuffer.AddColumn(grecFADeprBook."Depreciation Ending Date", false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD07JUL2023
        grecExcelBuffer.AddColumn(VendorNo, false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD07JUL2023
        grecExcelBuffer.AddColumn(VendorName, false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(INVDocumentNO, false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn(FADeprBook."Depreciation Method", false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn(NetAssetValuebeforeDepreciaton, false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecFADeprBook.CalcFields("Book Value");
        grecExcelBuffer.AddColumn(grecFADeprBook."Book Value", false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn(GRNNOGVar, false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn(GRNDateGvar, false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn(OrderNoGVar, false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn('', false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn(grecFADeprBook."No. of Depreciation Years", false, '', false, false, false, '', grecExcelBuffer."Cell Type");//B2BSSD05JUL2023
        grecExcelBuffer.AddColumn(gtxtEmployeeName, false, '', false, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(GrossValueUptoYear), false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(AditionDuringYear), false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(DeletionDuringYear), false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(GrossValueatYearEnd), false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(AcctdDepratPeriodBegin), false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(DeprForPeriod), false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(DeprDisposedAssests), false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(AcctdDepratPeriodEnd), false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(NetClassAsOnEndDate, false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(NetClassUptoStartDate, false, '', false, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
    end;

    procedure MakeExcelDataFooter()
    begin
        grecExcelBuffer.NewRow;
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn('Grand Total', false, '', true, false, false, '', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(TotalGrossValueUptoYear), false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(TotalAditionDuringYear), false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(TotalDeletionDuringYear), false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(TotalGrossValueatYearEnd), false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(TotalAcctdDepratPeriodBegin), false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(TotalDeprForPeriod), false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(TotalDeprDisposedAssests), false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(Abs(TotalAcctdDepratPeriodEnd), false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(TotalNetClassAsOnEndDate, false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
        grecExcelBuffer.AddColumn(TotalNetClassUptoStartDate, false, '', true, false, false, '#,##0.00', grecExcelBuffer."Cell Type");
    end;

    procedure CreateExcelbook()
    begin
        grecExcelBuffer.CreateBookAndOpenExcel('', Text001, Text002, CompanyName, UserId);
        //grecExcelBuffer.UpdateBookStream;// B2BUPG
        Error('');
    end;

    local procedure SkipRecord(): Boolean
    begin
        AcquisitionDate := FADeprBook."Acquisition Date";
        DisposalDate := FADeprBook."Disposal Date";
        exit(
          "Fixed Asset".Inactive or
          (AcquisitionDate = 0D) or
          (AcquisitionDate > EndDate) and (EndDate > 0D) or
          (DisposalDate > 0D) and (DisposalDate < StartDate))
    end;

    var
        FALedgerEntry: Record "FA Ledger Entry";
        FALedgerEntry1: Record "FA Ledger Entry";
        GrossValueUptoYear: Decimal;
        AditionDuringYear: Decimal;
        DeletionDuringYear: Decimal;
        Adjustment: Decimal;
        GrossValueatYearEnd: Decimal;
        AcctdDepratPeriodBegin: Decimal;
        StartDate: Date;
        EndDate: Date;
        DeprForPeriod: Decimal;
        AcctdDepratPeriodEnd: Decimal;
        NetClassAsOnEndDate: Decimal;
        NetClassUptoStartDate: Decimal;
        SrNum: Integer;
        Text16500: Label 'Start Date and End Date must be filled in.';
        TotalGrossValueUptoYear: Decimal;
        TotalAditionDuringYear: Decimal;
        TotalDeletionDuringYear: Decimal;
        TotalAdjustment: Decimal;
        TotalGrossValueatYearEnd: Decimal;
        TotalAcctdDepratPeriodBegin: Decimal;
        TotalDeprForPeriod: Decimal;
        TotalAcctdDepratPeriodEnd: Decimal;
        TotalNetClassAsOnEndDate: Decimal;
        TotalNetClassUptoStartDate: Decimal;
        Text16501: Label 'End Date should not be less than Start Date.';
        Text003: Label 'Company Name';
        Text004: Label 'Report Name';
        Text005: Label 'User ID';
        Text006: Label 'Date';
        Text007: Label 'Start Date';
        Text008: Label 'End Date';
        Text002: Label 'Fixed Asset Detail';
        Text001: Label 'Data';
        grecExcelBuffer: Record "Excel Buffer" temporary;
        gboolPrintInExcel: Boolean;
        grecCompInfo: Record "Company Information";
        grecFALocation: Record "FA Location";
        grecEmployee: Record Employee;
        gtxtEmployeeName: Text[100];
        grecFADeprBook: Record "FA Depreciation Book";
        DeprDisposedAssests: Decimal;
        TotalDeprDisposedAssests: Decimal;
        AcquisitionDate: Date;
        DisposalDate: Date;
        FADeprBook: Record "FA Depreciation Book";
        ResponsibleCaptionLbl: Label 'Responsible Employee';
        DescriptionCaptionLbl: Label 'Description';
        SNoCaptionLbl: Label 'S.No.';
        AdditionCaptionLbl: Label 'Addition During the year (Rs.)';
        AccumulatedBeginCaptionLbl: Label 'Accumulated Depreciation as on the beginning of the Year (Rs.)';
        AccumulatedEndCaptionLbl: Label 'Accumulated Depreciation as on the end of the year (Rs.)';
        DepreCaptionLbl: Label 'Depreciation for the period (Rs.)';
        GrossValueEndCaptionLbl: Label 'Gross Value at the end of year (Rs.)';
        GrossValueBeginCaptionLbl: Label 'Gross Value at the Begining of the year (Rs.)';
        AssetClassCaptionLbl: Label 'Asset Class';
        GrossCalssCaptionLbl: Label 'Gross value of Class of Assets';
        DepreciationCaptionLbl: Label 'Depreciation';
        NetClassCaptionLbl: Label 'Net Class as on ';
        FixedAsstCaptionLbl: Label 'Fixed Asset Detail';
        CurrReportCaptionLbl: Label 'Page';
        AsserSubClassCaptionLbl: Label 'Asset Sub Class';
        DeletnCaptionLbl: Label 'Deletion During the year (Rs.)';
        RsCaptionLbl: Label '(Rs.)';
        RsControlCaptionLbl: Label '(Rs.)';
        AssetCodeCaptionLbl: Label 'Asset Code';
        CapitalizationDateCaptionLbl: Label 'Capitalization Date';
        FALocationCaptionLbl: Label 'FA Location';
        SerialNoCaptionLbl: Label 'Serial No.';
        AcquisitionDateCaptionLbl: Label 'Acquisition Date';
        AccDepreciationCaptionLbl: Label 'Acc. Depreciation on disposed assets';
        GrandTotalCaptionLbl: Label 'Grand Total';
        VendorNo: Code[20];
        VendorName: Text[100];
        INVDocumentNO: Code[30];
        NetAssetValuebeforeDepreciaton: Decimal;
        PostedPurchaseInvGrec: Record "Purch. Inv. Header";
        PostedPurchaseRecGrec: Record "Purch. Rcpt. Header";
        GRNNOGVar: Code[30];
        GRNDateGvar: Date;
        OrderNoGVar: Code[30];
        v: Report "Fixed Asset Register Report";
        NewStartDate: Date;
}