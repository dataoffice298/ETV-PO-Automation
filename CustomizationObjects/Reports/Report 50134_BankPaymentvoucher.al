report 50134 "Bank Payment voucher New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Bank Payment voucher Report.rdl';
    Caption = 'Vendor - Payment Receipt_50087';
    ApplicationArea = Suite;
    UsageCategory = Documents;
    WordMergeDataItem = "Vendor Ledger Entry";

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Document Type", "Vendor No.", "Posting Date", "Currency Code") where("Document Type" = filter(Payment | Refund));
            RequestFilterFields = "Vendor No.", "Posting Date", "Document No.";
            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(VendAddr6; VendAddr[6])
                {
                }
                column(VendAddr7; VendAddr[7])
                {
                }
                column(VendAddr8; VendAddr[8])
                {
                }
                column(VendAddr4; VendAddr[4])
                {
                }
                column(VendAddr5; VendAddr[5])
                {
                }
                column(VendAddr3; VendAddr[3])
                {
                }
                column(VendAddr1; VendAddr[1])
                {
                }
                column(VendAddr2; VendAddr[2])
                {
                }
                column(VendNo_VendLedgEntry; "Vendor Ledger Entry"."Vendor No.")
                {
                    IncludeCaption = true;
                }
                column(DocDate_VendLedgEntry; Format("Vendor Ledger Entry"."Document Date", 0, 4))
                {
                }
                column(CompanyAddr1; CompanyInfo.Name)//CompanyAddr[1]
                {
                }
                column(CompanyAddr2; CompanyInfo.Address)//CompanyAddr[2]
                {
                }
                column(CompanyAddr3; CompanyInfo."Address 2")//CompanyAddr[3]
                {
                }
                column(CompanyAddr4; CompanyInfo.City)//CompanyAddr[4]
                {
                }
                column(CompanyAddr5; CompanyInfo."Post Code")//CompanyAddr[5]
                {
                }
                //column(CompanyAddr6; CompanyAddr[6])
                // {
                // }
                // column(CompanyAddr7; CompanyAddr[7])
                // {
                // }
                // column(CompanyAddr8; CompanyAddr[8])
                // {
                // }
                column(PhoneNo; CompanyInfo."Phone No.")
                {
                }
                column(HomePage; CompanyInfo."Home Page")
                {
                }
                column(Email; CompanyInfo."E-Mail")
                {
                }
                column(VATRegistrationNo; CompanyInfo."VAT Registration No.")
                {
                }
                column(GiroNo; CompanyInfo."Giro No.")
                {
                }
                column(BankName; BankAccount.Name)
                {
                }
                column(BankAccountNo; BankAccount."Bank Account No.")
                {
                }
                // column(Location_GST_Reg__No_; "Vendor Ledger Entry"."Location GST Reg. No.")
                // {

                // }
                column(CompanyInfoLogo; CompanyInfo.Picture)
                {
                }
                column(ReportTitle; ReportTitle)
                {
                }
                // column(vendorno; "Vendor Ledger Entry"."Location GST Reg. No.") { }
                column(DocNo_VendLedgEntry; "Vendor Ledger Entry"."Document No.") // Recp
                {
                }
                column(PymtDiscTitle; PaymentDiscountTitle)
                {
                }
                column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                {
                }
                column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                {
                }

                column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                {
                }
                column(CompanyInfoBankAccNoCaption; CompanyInfoBankAccNoCaptionLbl)
                {
                }
                column(RcptNoCaption; RcptNoCaptionLbl)
                {
                }
                column(CompanyInfoVATRegNoCaptionLbl; CompanyInfoVATRegNoCaptionLbl)
                {
                }
                column(PostingDateCaption; PostingDateCaptionLbl)
                {
                }
                column(DocNoCaption; DocNoCaptionLbl)
                {

                }
                column(AmtCaption; AmtCaptionLbl)
                {
                }
                column(PymtAmtSpecCaption; PymtAmtSpecCaptionLbl)
                {
                }
                column(PymtTolInvCurrCaption; PymtTolInvCurrCaptionLbl)
                {
                }
                column(GSTAmountCaption; GSTAmountCaptionLbl) { }
                column(GrossAmountCaption; GrossAmountCaptionLbl) { }
                column(TDSAmountCaption; TDSAmountCaptionLbl) { }
                column(NetAmountCaption; NetAmountCaptionLbl) { }
                column(BankPaymentAmountCaption; BankPaymentAmountCaptionLbl) { }
                column(BankPAymentDateCaption; BankPAymentDateCaptionLbl) { }
                column(TransIdCaption; TransIdCaptionLbl) { }
                column(UTRNumberCaption; UTRNumberCaptionLbl) { }
                column(InstrumentIdCaption; InstrumentIdCaptionLbl) { }
                dataitem(DetailedVendorLedgEntry1; "Detailed Vendor Ledg. Entry")  // line1
                {
                    DataItemLink = "Applied Vend. Ledger Entry No." = field("Entry No.");
                    DataItemLinkReference = "Vendor Ledger Entry";
                    DataItemTableView = sorting("Applied Vend. Ledger Entry No.", "Entry Type") where(Unapplied = const(false));
                    PrintOnlyIfDetail = true;
                    column(AppliedVLENo_DtldVendLedgEntry; "Applied Vend. Ledger Entry No.")
                    {
                    }
                    dataitem(VendLedgEntry1; "Vendor Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Vendor Ledger Entry No.");
                        DataItemLinkReference = DetailedVendorLedgEntry1;
                        DataItemTableView = sorting("Entry No.");
                        // column(PostingDate_VendLedgEntry1; Format("Posting Date"))
                        // {
                        // }
                        column(PostingDate_VendLedgEntry1; Format(VendorInvoiceDate))
                        {
                        }
                        column(DocType_VendLedgEntry1; "Document Type")
                        {
                            IncludeCaption = true;
                        }
                        column(DocNo_VendLedgEntry1; "External Document No.")
                        {
                            IncludeCaption = true;
                        }
                        // column(DocNo_VendLedgEntry1; "Document No.")
                        // {
                        //     IncludeCaption = true;
                        // }

                        column(Description_VendLedgEntry1; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(NegShowAmountVendLedgEntry1; -NegShowAmountVendLedgEntry1)
                        {
                        }
                        column(CurrCode_VendLedgEntry1; CurrencyCode("Currency Code"))
                        {
                        }
                        column(vendorno; VendLedgEntry1."Location GST Reg. No.") { }
                        column(NegPmtDiscInvCurrVendLedgEntry1; -NegPmtDiscInvCurrVendLedgEntry1)
                        {
                        }
                        column(NegPmtTolInvCurrVendLedgEntry1; -NegPmtTolInvCurrVendLedgEntry1)
                        {
                        }
                        column(GSTAmount; GSTAmount) { }
                        column(TDSAmount; TDSAmount) { }
                        column(ChequeNo; ChequeNo) { }
                        column(BankPytAmount; BankPytAmount) { }
                        column(BankPostingDate; BankPostingDate) { }
                        column(TranscNo; TranscNo) { }
                        column(TranscMode; TranscMode) { }
                        column(Location_GST_Reg__No_; GSTReg_No.Code) { }
                        //    column(vendorno; vendorno) { }


                        trigger OnAfterGetRecord()
                        var
                            Vendor: Record Vendor;

                        begin
                            Clear(TDSAmount);
                            Clear(GSTAmount);
                            Clear(ChequeNo);
                            Clear(BankPytAmount);
                            Clear(BankPostingDate);
                            Clear(TranscNo);
                            Clear(TranscMode);

                            if "Entry No." = "Vendor Ledger Entry"."Entry No." then
                                CurrReport.Skip();

                            // Vendor.SetRange("No.", VendLedgEntry1."Vendor No.");
                            // if VendLedgEntry1."Location GST Reg. No." <> '' then begin
                            //vendorno := VendLedgEntry1."Location GST Reg. No.";
                            // Message('%1', vendorno);
                            // end;
                            NegPmtDiscInvCurrVendLedgEntry1 := 0;
                            NegPmtTolInvCurrVendLedgEntry1 := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            NegShowAmountVendLedgEntry1 := -DetailedVendorLedgEntry1.Amount;

                            if "Vendor Ledger Entry"."Currency Code" <> "Currency Code" then begin
                                NegPmtDiscInvCurrVendLedgEntry1 := Round("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                                NegPmtTolInvCurrVendLedgEntry1 := Round("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                                AppliedAmount :=
                                  Round(
                                    -DetailedVendorLedgEntry1.Amount / "Original Currency Factor" * "Vendor Ledger Entry"."Original Currency Factor",
                                    Currency."Amount Rounding Precision");
                            end else begin
                                NegPmtDiscInvCurrVendLedgEntry1 := Round("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                                NegPmtTolInvCurrVendLedgEntry1 := Round("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                                AppliedAmount := -DetailedVendorLedgEntry1.Amount;
                            end;

                            PmtDiscPmtCurr := Round("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");

                            PmtTolPmtCurr := Round("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");

                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;

                            GSTLedgerentry.Reset();
                            GSTLedgerentry.SetRange("Document No.", VendLedgEntry1."Document No.");
                            GSTLedgerentry.SetRange("Posting Date", VendLedgEntry1."Posting Date");
                            if GSTLedgerentry.FindSet() then
                                repeat
                                    GSTAmount += GSTLedgerentry."GST Amount";
                                until GSTLedgerentry.Next() = 0;
                            TDSentry.Reset();
                            TDSentry.SetRange("Document No.", VendLedgEntry1."Document No.");
                            if TDSentry.FindSet() then
                                repeat
                                    TDSAmount += TDSentry."TDS Amount";
                                until TDSentry.Next() = 0;

                            if GSTReg_No.Get(VendLedgEntry1."Location GST Reg. No.") then;

                            BankAccountLedgerEntry.Reset();
                            BankAccountLedgerEntry.SetRange("Document No.", DetailedVendorLedgEntry1."Document No.");
                            if BankAccountLedgerEntry.FindFirst() then begin
                                //ChequeNo := BankAccountLedgerEntry."Cheque No.";
                                BankPytAmount := BankAccountLedgerEntry.Amount;
                                BankPostingDate := BankAccountLedgerEntry."Posting Date";
                                TranscNo := BankAccountLedgerEntry."Transfer Reference No.";
                                TranscMode := Format(BankAccountLedgerEntry."Transfer Mode");
                                BankAccount.Get(BankAccountLedgerEntry."Bank Account No.")
                            end;
                            Clear(VendorInvoiceDate);
                            if PurchInvHeader.Get("Document No.") then
                                VendorInvoiceDate := PurchInvHeader."Vendor Invoice Date";
                        end;
                    }
                }
                dataitem(DetailedVendorLedgEntry2; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No." = field("Entry No.");
                    DataItemLinkReference = "Vendor Ledger Entry";
                    DataItemTableView = sorting("Vendor Ledger Entry No.", "Entry Type", "Posting Date") where(Unapplied = const(false));
                    column(VLENo_DtldVendLedgEntry; "Vendor Ledger Entry No.")
                    {
                    }
                    dataitem(VendLedgEntry2; "Vendor Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Applied Vend. Ledger Entry No.");
                        DataItemLinkReference = DetailedVendorLedgEntry2;
                        DataItemTableView = sorting("Entry No.");
                        column(NegAppliedAmt; -AppliedAmount) //Line2
                        {
                        }
                        column(Description_VendLedgEntry2; Description)
                        {
                        }
                        column(DocNo_VendLedgEntry2; "Document No.")
                        {
                        }
                        column(DocType_VendLedgEntry2; "Document Type")
                        {
                        }
                        column(PostingDate_VendLedgEntry2; Format("Posting Date"))
                        {
                        }
                        column(CurrCode_VendLedgEntry2; CurrencyCode("Currency Code"))
                        {
                        }
                        column(NegPmtDiscInvCurrVendLedgEntry2; -NegPmtDiscInvCurrVendLedgEntry1)
                        {
                        }
                        column(NegPmtTolInvCurr1VendLedgEntry2; -NegPmtTolInvCurrVendLedgEntry1)
                        {
                        }
                        // column(ChequeNo; ChequeNo) { }
                        // column(BankPytAmount; BankPytAmount) { }
                        // column(BankPostingDate; BankPostingDate) { }
                        // column(TranscNo; TranscNo) { }
                        trigger OnAfterGetRecord()
                        begin

                            // Clear(ChequeNo);
                            // Clear(BankPytAmount);
                            // Clear(BankPostingDate);
                            // Clear(TranscNo);
                            // BankAccountLedgerEntry.Reset();
                            // BankAccountLedgerEntry.SetRange("Document No.", VendLedgEntry1."Document No.");
                            // if BankAccountLedgerEntry.FindFirst() then begin
                            //     ChequeNo := BankAccountLedgerEntry."Cheque No.";
                            //     BankPytAmount := BankAccountLedgerEntry.Amount;
                            //     BankPostingDate := BankAccountLedgerEntry."Posting Date";
                            //     TranscNo := BankAccountLedgerEntry."Transfer Reference No.";
                            // end;

                            if "Entry No." = "Vendor Ledger Entry"."Entry No." then
                                CurrReport.Skip();

                            NegPmtDiscInvCurrVendLedgEntry1 := 0;
                            NegPmtTolInvCurrVendLedgEntry1 := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            NegShowAmountVendLedgEntry1 := DetailedVendorLedgEntry2.Amount;

                            if "Vendor Ledger Entry"."Currency Code" <> "Currency Code" then begin
                                NegPmtDiscInvCurrVendLedgEntry1 := Round("Pmt. Disc. Rcd.(LCY)" * "Original Currency Factor");
                                NegPmtTolInvCurrVendLedgEntry1 := Round("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                            end else begin
                                NegPmtDiscInvCurrVendLedgEntry1 := Round("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                                NegPmtTolInvCurrVendLedgEntry1 := Round("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                            end;

                            PmtDiscPmtCurr := Round("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");

                            PmtTolPmtCurr := Round("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");

                            AppliedAmount := DetailedVendorLedgEntry2.Amount;
                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                            // GSTLedgerentry.Reset();
                            // GSTLedgerentry.SetRange("Document No.", VendLedgEntry1."Document No.");
                            // GSTLedgerentry.SetRange("Posting Date", VendLedgEntry1."Posting Date");
                            // if GSTLedgerentry.FindSet() then
                            //     repeat
                            //         GSTAmount += GSTLedgerentry."GST Amount";
                            //     until GSTLedgerentry.Next() = 0;
                            // TDSentry.Reset();
                            // TDSentry.SetRange("Document No.", VendLedgEntry1."Document No.");
                            // if TDSentry.FindSet() then
                            //     repeat
                            //         TDSAmount += TDSentry."TDS Amount";
                            //     until TDSentry.Next() = 0;

                            // BankAccountLedgerEntry.Reset();
                            // BankAccountLedgerEntry.SetRange("Document No.", VendLedgEntry1."Document No.");
                            // if BankAccountLedgerEntry.FindFirst() then begin
                            //     ChequeNo := BankAccountLedgerEntry."Cheque No.";
                            //     BankPytAmount := BankAccountLedgerEntry.Amount;
                            //     BankPostingDate := BankAccountLedgerEntry."Posting Date";
                            //     TranscNo := BankAccountLedgerEntry."Transfer Reference No.";
                            // end;

                        end;
                    }
                }
                dataitem(Total; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(NegRemainingAmt; -RemainingAmount)
                    {
                    }
                    column(CurrCode_VendLedgEntry; CurrencyCode("Vendor Ledger Entry"."Currency Code"))
                    {
                    }
                    column(NegOriginalAmt_VendLedgEntry; -"Vendor Ledger Entry"."Original Amount")
                    {
                    }
                    column(ExtDocNo_VendLedgEntry; "Vendor Ledger Entry"."External Document No.")
                    {
                    }
                    column(PymtAmtNotAllocatedCaption; PymtAmtNotAllocatedCaptionLbl)
                    {
                    }
                    column(PymtAmtCaption; PymtAmtCaptionLbl)
                    {
                    }
                    column(ExternalDocNoCaption; ExternalDocNoCaptionLbl)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                Vend.Get("Vendor No.");
                FormatAddr.Vendor(VendAddr, Vend);
                if not Currency.Get("Currency Code") then
                    Currency.InitRoundingPrecision();

                if "Document Type" = "Document Type"::Payment then begin
                    ReportTitle := Text004;
                    PaymentDiscountTitle := Text007;
                end else begin
                    ReportTitle := Text003;
                    PaymentDiscountTitle := Text006;
                end;

                CalcFields("Original Amount");
                RemainingAmount := -"Original Amount";
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                GLSetup.Get();
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        CurrencyCodeCaption = 'Currency Code';
        PageCaption = 'Page';
        DocDateCaption = 'Recipet Date';
        EmailCaption = 'Email';
        HomePageCaption = 'Home Page';

    }

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Vend: Record Vendor;
        TDSentry: Record "TDS Entry";
        Currency: Record Currency;
        GSTLedgerentry: Record "GST Ledger Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccount: Record "Bank Account";
        FormatAddr: Codeunit "Format Address";
        GSTReg_No: Record "GST Registration Nos.";
        ReportTitle: Text[30];
        vendorno: Code[20];
        ChequeNo: Code[20];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array[8] of Text[100];
        VendAddr: array[8] of Text[100];
        TranscMode: Text;
        PurchInvHeader: Record "Purch. Inv. Header";
        RemainingAmount, GSTAmount : Decimal;
        AppliedAmount, TDSAmount : Decimal;
        NegPmtDiscInvCurrVendLedgEntry1: Decimal;
        NegPmtTolInvCurrVendLedgEntry1: Decimal;
        BankPytAmount: Decimal;
        PmtDiscPmtCurr: Decimal;
        BankPostingDate: Date;
        TranscNo: Code[20];
        Text003: Label 'Payment Receipt';
        Text004: Label 'Payment Voucher';
        Text006: Label 'Payment Discount Given';
        Text007: Label 'Payment Discount Received';
        PmtTolPmtCurr: Decimal;
        VendorInvoiceDate: Date;
        NegShowAmountVendLedgEntry1: Decimal;
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: Label 'Bank';
        CompanyInfoBankAccNoCaptionLbl: Label 'Account No.';
        RcptNoCaptionLbl: Label 'Receipt No.';
        CompanyInfoVATRegNoCaptionLbl: Label 'GST Registration No.';
        PostingDateCaptionLbl: Label 'Invoice Date';
        AmtCaptionLbl: Label 'Amount (A)';
        PymtAmtSpecCaptionLbl: Label 'Payment Amount Specification';
        PymtTolInvCurrCaptionLbl: Label 'Payment Tolerance';
        PymtAmtNotAllocatedCaptionLbl: Label 'Payment Amount Not Allocated';
        PymtAmtCaptionLbl: Label 'Payment Amount';
        ExternalDocNoCaptionLbl: Label 'External Document No.';
        GSTAmountCaptionLbl: Label 'GST Amount (B)';
        GrossAmountCaptionLbl: LAbel 'Gross Amount (C=A-B)';
        TDSAmountCaptionLbl: Label 'TDS Amount (D)';
        NetAmountCaptionLbl: Label 'Net Amount (E=C_D)';
        BankPaymentAmountCaptionLbl: Label 'Bank Payment Amount';
        BankPAymentDateCaptionLbl: Label 'Bank Payment Date';
        TransIdCaptionLbl: Label 'Trans Id';
        UTRNumberCaptionLbl: Label 'UTR Number';
        InstrumentIdCaptionLbl: Label 'Instrument Id';
        DocNoCaptionLbl: Label 'Invoice No.';

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
            exit(GLSetup."LCY Code");

        exit(SrcCurrCode);
    end;
}

