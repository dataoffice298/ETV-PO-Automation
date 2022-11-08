report 50182 "Regularization Order"
{
    Caption = 'Regularization Order';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './RegularizationOrder.rdl';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            { }
            column(Picture_CompanyInfo; CompanyInfo.Picture)
            { }
            column(Name_CompanyInfo; CompanyInfo.Name)
            { }
            column(GSTNo_CompanyInfo; CompanyInfo."GST Registration No.")
            { }
            column(StateName_CompanyInfo; StateGRec.Description)
            { }
            column(StateCodeGST_CompanyInfo; StateGRec."State Code (GST Reg. No.)")
            { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(Buy_from_Address; "Buy-from Address")
            { }
            column(Buy_from_Address_2; "Buy-from Address 2")
            { }
            column(Buy_from_City; "Buy-from City")
            { }
            column(Buy_from_Contact_No_; "Buy-from Contact No.")
            { }
            column(Buy_from_Email; VendorGRec."E-Mail")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Dear_CaptionLbl; Dear_CaptionLbl)
            { }
            column(Quote_No_; "Quote No.")
            { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Line_No_; "Line No.")
                { }
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);

                if StateGRec.Get(CompanyInfo."State Code") then;

                if VendorGRec.Get("Buy-from Vendor No.") then;

                if PurchaseHdr.Get(PurchaseHdr."Document Type"::Quote, "Quote No.") then;



                Subject := StrSubstNo(Subject1, "Quote No.", "Purchase Header"."Document Date");
                Subject := Subject + StrSubstNo(Subject2)
            end;
        }
    }




    var
        CompanyInfo: Record "Company Information";
        StateGRec: Record State;
        VendorGRec: Record Vendor;
        PurchaseHdr: Record "Purchase Header";
        IndentHdr: Record "Indent Header";
        Dear_CaptionLbl: Label 'Dear Sir,';
        Subject: Text;
        Subject1: Label 'With reference to your Quotation No. %1/dt. %2 and subsequent discussion we had with you, ';
        Subject2: Label 'We would like to place order on you for the following lines against the Indent No. %1/dt. %2';
}