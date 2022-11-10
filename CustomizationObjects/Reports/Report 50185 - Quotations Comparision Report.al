report 50185 "Comparitive Statement"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Comparitive Statement Report_50185';
    RDLCLayout = './QuotesCompare.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(QuotCompHdr; QuotCompHdr)
        {
            column(No_; "No.")
            { }
            column(ComparitiveStatementCapLbl; ComparitiveStatementCapLbl)
            { }
            column(IndentNoCapLbl; IndentNoCapLbl)
            { }
            column(PurposeCapLbl; PurposeCapLbl)
            { }
            column(NameoftheIndentorCapLbl; NameoftheIndentorCapLbl)
            { }
            column(DateCapLbl; DateCapLbl)
            { }



            dataitem("Quotation Comparison Test"; "Quotation Comparison Test")
            {
                DataItemLink = "Quot Comp No." = field("No.");
                DataItemTableView = where("Item No." =

                column(Quot_Comp_No_;
                "Quot Comp No.")
                { }
            column(SNoCapLbl; SNoCapLbl)
            { }
            column(DescriptionCapLbl; DescriptionCapLbl)
            { }
            column(HSNCodeCapLbl; HSNCodeCapLbl)
            { }
            column(QtyCapLabl; QtyCapLabl)
            { }
            column(UnitsCapLbl; UnitsCapLbl)
            { }
            column(UnitRateCapLbl; UnitRateCapLbl)
            { }
            column(RSCapLbl; RSCapLbl)
            { }
            column(UnitRateCapLbl1; UnitRateCapLbl1)
            { }
            column(RSCapLbl1; RSCapLbl1)
            { }
            Column(ModelCapLbl; ModelCapLbl)
            { }
            column(MRPCapLbl; MRPCapLbl)
            { }
            column(TermsCondCapLbl; TermsCondCapLbl)
            { }
            column(QtnNoDateCapLbl; QtnNoDateCapLbl)
            { }
            column(RatesCapLbl; RatesCapLbl)
            { }
            column(GSTCapLbl; GSTCapLbl)
            { }
            column(TransportationCapLbl; TransportationCapLbl)
            { }
            column(DeliveryCapLbl; DeliveryCapLbl)
            { }
            column(PaymentCapLbl; PaymentCapLbl)
            { }
            column(WarrantyCapLbl; WarrantyCapLbl)
            { }
            column(ContactPersonCapLbl; ContactPersonCapLbl)
            { }
            column(PhoneNoCapLbl; PhoneNoCapLbl)
            { }
            column(Item_No_; "Item No.")
            { }
            column(Description; Description)
            { }
            column(Quantity; Quantity)
            { }
            column(HSNCode; HSNCode)
            { }
            column(Vendor_Name; "Vendor Name")
            { }
            column(UOM; UOM)
            { }
            column(UnitPrice; UnitPrice)
            { }
            column(Indent_No_; "Indent No.")
            { }
            column(Document_Date; "Document Date")
            { }
            column(Indentor; IndentHdr.Indentor)
            { }


            trigger OnAfterGetRecord()

            begin

                PurchLine.Reset();
                PurchLine.setrange("Document No.", PurchHdr."No.");
                If PurchLine.FindSet() then
                    HSNCode := PurchLine."HSN/SAC Code";
                UOM := PurchLine."Unit of Measure Code";

                QuoComp.Reset();
                QuoComp.SetRange("Quot Comp No.", "Quot Comp No.");
                If QuoComp.Findset() then
                    UnitPrice := QuoComp.Rate;

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
        IndentHdr: Record "Indent Header";
        PurchHdr: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        HSNCode: Code[20];
        UOM: Code[20];
        UnitPrice: Decimal;
        ComparitiveStatementCapLbl: Label 'Comparitive Statement of';
        IndentNoCapLbl: Label 'Indent No.:';
        PurposeCapLbl: Label 'Purpose:';
        NameoftheIndentorCapLbl: Label 'Name of the Indentor:';
        DateCapLbl: Label 'Date:';
        SNoCapLbl: Label 'S.No.';
        DescriptionCapLbl: Label 'Description';
        HSNCodeCapLbl: Label 'HSN Code';
        QtyCapLabl: Label 'Qty.';
        UnitsCapLbl: Label 'Units';
        ApvisionTechCapLbl: Label 'Apvision Technologies';
        UnitRateCapLbl: Label 'Unit Rate';
        RSCapLbl: Label '(Rs.)';
        ConquerTechCapLbl: Label 'Conquer Technologies';
        UnitRateCapLbl1: Label 'Unit Rate';
        RSCapLbl1: Label '(Rs.)';
        ApplemakeCapLbl: Label 'Apple Make:';
        ModelCapLbl: Label 'Model:';
        MRPCapLbl: Label 'MRP:';
        TermsCondCapLbl: Label 'Terms & Conditions:';
        QtnNoDateCapLbl: Label 'Qtn.No. & Dt.:';
        RatesCapLbl: Label 'Rates:';
        GSTCapLbl: Label 'GST:';
        TransportationCapLbl: Label 'Transportation:';
        DeliveryCapLbl: Label 'Delivery:';
        PaymentCapLbl: Label 'Payment:';
        WarrantyCapLbl: Label 'Warranty:';
        ContactPersonCapLbl: Label 'Contact Person:';
        PhoneNoCapLbl: Label 'Phone No.:';
        Item: Record Item;
        QuoComp: Record "Quotation Comparison Test";



}