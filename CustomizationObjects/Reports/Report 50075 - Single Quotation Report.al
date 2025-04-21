report 50075 "Single Quotation Report"
{
    Caption = 'Single Quotation Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './SingleQuotation.rdl';

    dataset
    {
        dataitem(QuotCompHdr; QuotCompHdr)
        {
            RequestFilterFields = "No.";

            column(Desc; DescCapLbl)
            { }
            column(HSNC; HSNCapLbl)
            { }
            column(QtyCapLbl; QtyCapLbl)
            { }
            column(TaxCatCapLbl; TaxCatCapLbl)
            { }
            column(UOMCapLbl; UOMCapLbl)
            { }
            column(UnitPriceCapLbl; UnitPriceCapLbl)
            { }
            column(GSTAmtCapLbl; GSTAmtCapLbl)
            { }
            column(TotalCapLbl; TotalCapLbl)
            { }
            column(TermsCondCap; TermsCondCapLbl)
            { }
            column(Purpose; Purpose)
            { }
            column(Created_By; "Created By")
            { }
            column(Quot_Comparitive; "Quot Comparitive")
            { }

            dataitem(QuotComparisonTest; "Quotation Comparison Test")
            {
                DataItemLink = "Quot Comp No." = field("No.");
                DataItemTableView = SORTING("Item No.", "Variant Code")
                                    ORDER(Ascending);
                PrintOnlyIfDetail = false;

                column(Item_No_; "Item No.")
                { }
                column(Description; Description)
                { }
                column(Quantity; Quantity)
                { }
                column(HSNCode; HSNCode)
                { }
                column(UOM; UOM)
                { }
                column(UnitPrice; UnitPrice)
                { }
                column(Indent_No_; "Indent No.")
                { }
                column(VendorName; PurchHdr."Buy-from Vendor Name")
                { }
                column(Address; PurchHdr."Buy-from Address")
                { }
                column(Address_2; PurchHdr."Buy-from Address 2")
                { }
                column(Address_3; PurchHdr."Buy-from Address 3")
                { }
                column(PhoneNo; PhoneNo)
                { }
                column(ContactPerson; ContactPerson)
                { }
                column(UserID; Indent."User Id")
                { }
                column(GstTotal; GstTotal)
                { }
                column(GSTPercent1; GSTPercent1)
                { }
                column(TotalAmount; TotalAmount)
                { }
                column(SNo; SNo)
                { }

                dataitem("PO Terms And Conditions"; "PO Terms And Conditions")
                {
                    DataItemLink = DocumentNo = field("Parent Quote No.");
                    DataItemTableView = where(Type = filter("Terms & Conditions"));
                    column(LineType; LineType)
                    { }
                    column(DocumentNo_Terms; DocumentNo)
                    { }
                    column(Description11; Description)
                    { }
                    column(Line_Type; Line_Type)
                    { }
                    column(LineNo; LineNo)
                    { }
                    column(Type_Terms; Type)
                    { }
                    column(SNo_; "SNo.")
                    { }
                    trigger OnAfterGetRecord()
                    var
                        i: Integer;
                        MidString: array[2000] of Text;
                    begin
                        Clear(i);
                        Clear(Line_Type);
                        Clear(ListTypeNew);
                        ListTypeNew := "PO Terms And Conditions".LineType;
                        i := i + 1;
                        MidString[i] := SplitStrings(ListTypeNew, ' ');
                        Line_Type := Line_Type + ' ' + UPPERCASE(COPYSTR(MidString[i], 1, 1)) + LOWERCASE(COPYSTR(MidString[i], 2));
                    end;
                }
                dataitem("PO Specifications"; "PO Specifications")
                {
                    DataItemLink = DocumentNo = field("Parent Quote No.");
                    DataItemTableView = where(Type = filter(Specifications));
                    column(PO_LineType; LineType)
                    { }
                    column(PO_DocumentNo; DocumentNo)
                    { }
                    column(PO_Description11; Description)
                    {

                    }
                    column(PO_Line_Type; Line_Type)
                    {

                    }
                    column(PO_LineNo; LineNo)
                    { }
                    column(PO_Type; Type)
                    { }
                    trigger OnAfterGetRecord()
                    var
                        i: Integer;
                        MidString: array[2000] of Text;
                    begin
                        Clear(i);
                        Clear(Line_Type);
                        Clear(ListTypeNew);
                        ListTypeNew := "PO Specifications".LineType;
                        i := i + 1;
                        MidString[i] := SplitStrings(ListTypeNew, ' ');
                        Line_Type := Line_Type + ' ' + UPPERCASE(COPYSTR(MidString[i], 1, 1)) + LOWERCASE(COPYSTR(MidString[i], 2));
                    end;
                }

                dataitem("Purchase Line"; "Purchase Line")
                {
                    DataItemLink = "Document No." = field("Parent Quote No.");
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                    column(GSTPerc; GSTPerc)
                    { }
                }
                dataitem(GSTLoop; Integer)
                {
                    DataItemTableView = sorting(Number);
                    DataItemLinkReference = "Purchase Line";
                    column(Number_GSTLoop; Number)
                    { }
                    column(GSTGroupCode_PurchLineGST; PurchLineGST."GST Group Code")
                    { }
                    column(GSTPerText; GSTPerText)
                    { }
                    column(Gstamt; Gstamt)
                    { }
                    column(GSTPercent; GSTPercent)
                    { }
                    trigger OnPreDataItem()
                    begin
                        Clear(GSTGroupCode);
                        I := 1;
                        PurchLineGST.Reset();
                        PurchLineGST.SetCurrentKey("GST Group Code");
                        PurchLineGST.SetRange("Document No.", PurchHdr."No.");
                        PurchLineGST.SetFilter("GST Group Code", '<>%1', '');
                        PurchLineGST.SetFilter("No.", '<>%1', '');
                        if PurchLineGST.Findset() then;
                        PurchLineGST.SetAscending("GST Group Code", true);
                        SetRange(Number, 1, PurchLineGST.Count);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        Clear(GSTPerText);
                        Clear(GSTPercent);
                        Clear(Gstamt);
                        clear(GstTotalSum);
                        if GSTGroupCode <> "Purchase Line"."GST Group Code" then begin
                            GSTGroupCode := "Purchase Line"."GST Group Code";
                            PurchaseLine.Reset();
                            PurchaseLine.SetCurrentKey("GST Group Code");
                            PurchaseLine.SetRange("Document No.", "Purchase Line"."Document No.");
                            if PurchaseLine.FindSet() then begin
                                GetGSTPercents(PurchaseLine);
                                if GSTPercent <> 0 then begin
                                    I += 1;
                                    GSTPerText := StrSubstNo(GSTText, GSTPercent);
                                    repeat
                                        Clear(SGSTAmt);
                                        Clear(IGSTAmt);
                                        Clear(CGSTAmt);
                                        GetGSTAmounts(PurchaseLine);
                                        Gstamt += CGSTAmt + SGSTAmt + IGSTAmt;
                                    until PurchaseLine.Next() = 0;
                                end;
                            end;
                        end;
                        if PurchLineGST.Next() = 0 then;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    SetFilter("Item No.", '<>%1', '');
                    SetFilter(Quantity, '<>%1', 0);
                end;

                trigger OnAfterGetRecord()
                begin
                    Clear(HSNCode);
                    Clear(UOM);
                    Clear(UnitPrice);

                    if QuotComparisonTest."Item No." <> '' then begin
                        if ItemNo <> QuotComparisonTest."Item No." then begin
                            ItemNo := QuotComparisonTest."Item No.";
                            SNo += 1;
                        end;
                    end;

                    if Indent.Get("Indent No.") then;

                    PurchHdr.Reset();
                    PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Quote);
                    PurchHdr.SetRange("No.", QuotComparisonTest."Parent Quote No.");
                    if PurchHdr.FindFirst() then;
                    if VendorRec.Get(PurchHdr."Buy-from Vendor No.") then begin
                        OrderAddressRec.Reset();
                        OrderAddressRec.setrange("Vendor No.", VendorRec."No.");
                        OrderAddressRec.SetRange("Mail Alert", true);
                        Clear(ContactPerson);
                        clear(PhoneNo);
                        if OrderAddressRec.FindSet() then begin
                            repeat
                                if OrderAddressRec."Contact Name" <> '' then
                                    ContactPerson := ContactPerson + OrderAddressRec."Contact Name" + ',';
                                if OrderAddressRec."Phone No." <> '' then
                                    PhoneNo := PhoneNo + OrderAddressRec."Phone No." + ',';
                            until OrderAddressRec.next() = 0;
                        end;
                        ContactPerson := DelChr(ContactPerson, '<>', ',');
                        PhoneNo := DelChr(PhoneNo, '<>', ',');
                    end;

                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Quote);
                    PurchaseLine.SetRange("Document No.", "Parent Quote No.");
                    PurchaseLine.SetRange("Line No.", "Parent Quote Line No");
                    if PurchaseLine.FindFirst() then begin
                        HSNCode := PurchaseLine."HSN/SAC Code";
                        UOM := PurchaseLine."Unit of Measure";
                        UnitPrice := PurchaseLine."Unit Cost";
                    end;
                    PurchLine1.Reset;
                    PurchLine1.Setrange("Document No.", QuotComparisonTest."Parent Quote No.");
                    PurchLine1.SetRange("Line No.", QuotComparisonTest."Parent Quote Line No");
                    PurchLine1.SetRange("No.", QuotComparisonTest."Item No.");
                    if PurchLine1.FindFirst() then begin
                        Clear(CGSTAmt);
                        clear(SGSTAmt);
                        clear(IGSTAmt);
                        Clear(GSTPercent1);
                        Clear(TotalAmount);
                        GetGSTAmounts(PurchLine1);
                        GstTotal := CGSTAmt + SGSTAmt + IGSTAmt;
                        GSTPercent1 += SGSTPer + CGSTPer + IGSTPer;
                        TotalAmount := (PurchLine1.Quantity * UnitPrice) + GstTotal;
                    end;
                end;

            }
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


    var
        TermsCondCapLbl: Label 'All the terms and conditions are as  per Comparative Statement.';
        SNo: Integer;
        DescCapLbl: Label 'Description';
        HSNCapLbl: Label 'HSN Code';
        TaxCatCapLbl: Label 'Tax Category';
        QtyCapLbl: Label 'Quantity';
        UOMCapLbl: Label 'UOM';
        UnitPriceCapLbl: Label 'Unit Price';
        GSTAmtCapLbl: Label 'GST Amount';
        TotalCapLbl: Label 'Total';
        PurchaseLine: Record "Purchase Line";
        HSNCode: Code[10];
        UOM: Code[10];
        UnitPrice: Decimal;
        CGSTLbl: Label 'CGST';
        PurchLineGST: Record "Purchase Line";
        I: Integer;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        Gstamt: Decimal;
        SGSTPer: Decimal;
        IGSTPer: Decimal;
        CGSTPer: Decimal;
        GSTPercent: Decimal;
        GSTPerc: Decimal;
        Line_Type, ListTypeNew : Text;
        GSTPerText: Text;
        GSTGroupCode: Code[50];

        PurchHdr: Record "Purchase Header";
        GstTotalSum: Decimal;
        GSTLbl: Label 'GST';
        IGSTLbl: Label 'IGST';
        GSTText: Label 'GST @%1%';
        VendorRec: Record Vendor;
        OrderAddressRec: Record "Order Address";
        ContactPerson: Text;
        PhoneNo: Text;
        Indent: Record "Indent Header";
        UserSetup: Record "User Setup";
        ItemNo: Code[20];
        PurchLine1: Record "Purchase Line";
        GstTotal: Decimal;
        GSTPercent1: Decimal;
        TotalAmount: Decimal;



    local procedure GetGSTAmounts(PurchaseLine: Record "Purchase Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        Clear(SGSTPer);
        Clear(CGSTPer);
        Clear(IGSTPer);
        Clear(GSTPerc);
        GSTSetup.Get();

        ComponentName := GetComponentName("Purchase Line", GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                SGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                SGSTPer := TaxTransactionValue.Percent;
                            end;

                        2:
                            begin
                                CGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;

                        3:
                            begin
                                IGSTAmt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;

                    end;
                    GSTPerc := SGSTPer + CGSTPer + CGSTPer;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl;
        exit(ComponentName)
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
        GSTSetup.TestField("GST Tax Type");

        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;

    local procedure GetGSTPercents(PurchaseLine: Record "Purchase Line")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        GSTSetup.Get();
        ComponentName := GetComponentName("Purchase Line", GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    GSTPercent += TaxTransactionValue.Percent;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    procedure SplitStrings(VAR String: Text[1024]; Separator: Text[1]) SplitedString: Text[1024]
    var
        Pos: Integer;
    begin
        Clear(Pos);
        Pos := STRPOS(String, Separator);
        if Pos > 0 then begin //Whether there is a separator
            SplitedString := COPYSTR(String, 1, Pos - 1);//Copy the string before the separator
            if Pos + 1 <= STRLEN(String) then //Is it all
                String := COPYSTR(String, Pos + 1)//Copy the string after the separator
            else
                Clear(String);
        end else begin
            SplitedString := String;
            Clear(String);
        end;
    end;

}