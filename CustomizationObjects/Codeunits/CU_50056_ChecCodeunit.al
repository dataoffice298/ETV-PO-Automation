codeunit 50056 "Check Codeunit"
{

    trigger OnRun();
    begin
    end;
    //B2BBaluOnAUG29>> Check Report
    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text1280000;
        ExponentText[4] := Text1280001;
    end;


    procedure FormatNoText(var NoText: array[2] of Text[180]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        Clear(Currency);
        if Currency.get(CurrencyCode) then;
        //  if CurrencyCode = '' then
        NoText[1] := 'RUPEES';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                IF No > 99999 THEN BEGIN
                    Ones := No DIV (POWER(100, Exponent - 1) * 10);
                    Hundreds := 0;
                END ELSE BEGIN
                    Ones := No DIV POWER(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                END;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                IF No > 99999 THEN
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(100, Exponent - 1) * 10
                ELSE
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        //IF CurrencyCode <> '' THEN BEGIN
        //   Currency.GET(CurrencyCode);
        //   AddToNoText(NoText, NoTextIndex, PrintExponent, Currency."Currency Numeric Description");
        //END ELSE
        //   AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        // AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := ROUND(((No * 100) MOD 10), 1);
        IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            IF OnesDec > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text026);
        /* IF (CurrencyCode <> '') THEN
             AddToNoText(NoText, NoTextIndex, PrintExponent, Currency."Currency Decimal Description" + ' ONLY')
         ELSE*/
        AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;


    local procedure AddToNoText(var NoText: array[2] of Text[180]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    local procedure GetAmtDecimalPosition(): Decimal
    var
        Currency: Record Currency;
    begin
        if GenJnlLine."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            Currency.Get(GenJnlLine."Currency Code");
            Currency.TestField("Amount Rounding Precision");
        end;
        exit(1 / Currency."Amount Rounding Precision");
    end;











    var
        Text16526: Label 'ZERO';
        GenJnlLine: Record "Gen. Journal Line";
        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\must not be activated when Applies-to ID is specified in the journal lines.';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text1280000: Label 'LAKH';
        Text1280001: Label 'CRORE';
        CompanyInfo: Record "Company Information";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        Employee: Record Employee;
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        CompanyAddr: array[8] of Text[100];
        CheckToAddr: array[8] of Text[100];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        BalancingType: Enum "Gen. Journal Account Type";
        BalancingNo: Code[20];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[80];
        DocNo: Text[30];
        ExtDocNo: Text[35];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        AddedRemainingAmount: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        JournalPostingDate: Date;
        i: Integer;
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account,,,Employee';
        CurrencyCode2: Code[10];
        NetAmount: Text[30];
        LineAmount2: Decimal;
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        Text065: Label 'Subtotal';
        CheckNoTextCaptionLbl: Label 'Check No.';
        LineAmountCaptionLbl: Label 'Net Amount';
        LineDiscountCaptionLbl: Label 'Discount';
        AmountCaptionLbl: Label 'Amount';
        DocNoCaptionLbl: Label 'Document No.';
        DocDateCaptionLbl: Label 'Document Date';
        CurrencyCodeCaptionLbl: Label 'Currency Code';
        YourDocNoCaptionLbl: Label 'Your Doc. No.';
        TransportCaptionLbl: Label 'Transport';
        BlockedEmplForCheckErr: Label 'You cannot print check because employee %1 is blocked due to privacy.', Comment = '%1 - Employee no.';
        AlreadyAppliedToEmployeeErr: Label ' is already applied to %1 %2 for employee %3.', Comment = '%1 = Document type, %2 = Document No., %3 = Employee No.';
    //B2BBaluOnAUG29<< Check Report

}

