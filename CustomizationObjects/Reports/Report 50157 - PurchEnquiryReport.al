report 50157 PurchEnquiryReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './PurchEnquiryReport.rdl';
    Caption = 'Purch Enquiry Report';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = filter(Enquiry));
            RequestFilterFields = "No.";
            column(Document_Date; "Document Date")
            { }
            column(StateName; StateGRec.Description)
            { }
            column(StateCodeGST; StateGRec."State Code (GST Reg. No.)")
            { }
            column(GSTNo; CompanyInfo."GST Registration No.")
            { }
            column(Picture; CompanyInfo.Picture)
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(Buy_from_Address; "Buy-from Address")
            { }
            column(Buy_from_Address_2; "Buy-from Address 2")
            { }
            column(City; VendorGRec.City)
            { }
            column(PostCode_Vendor; VendorGRec."Post Code")
            { }
            column(StateName_Vendor; StateGRec2.Description)
            { }
            column(StateCode_Vendor; StateGRec2."State Code (GST Reg. No.)")
            { }
            column(Courntry_Vendor; VendorGRec."Country/Region Code")
            { }
            column(PhNo_Vendor; VendorGRec."Mobile Phone No.")
            { }
            column(Email_Vendor; VendorGRec."E-Mail")
            { }
            column(GSTReg_Vendor; VendorGRec."GST Registration No.")
            { }
            column(ContactName; ContactName)
            { }
            column(ContactPhNo; ContactPhNo)
            { }
            column(ContactEmail; ContactEmail)
            { }
            column(Dear; DearCap)
            { }
            column(Requirement; RequirementCap)
            { }
            column(TO; TOCap)
            { }
            column(State; StateCap)
            { }
            column(StateCode; StateCodeCap)
            { }
            column(GST; GSTCap)
            { }
            column(PH; PHCap)
            { }
            column(Email; EmailCap)
            { }
            column(GSTIN; GSTINCap)
            { }
            column(KindAtt; KindAttCap)
            { }
            column(Mobile; MobileCap)
            { }
            column(Date; DateCap)
            { }
            column(SNo; SNoCap)
            { }
            column(Material; MaterialCap)
            { }
            column(UOM; UOMCap)
            { }
            column(QTY; QTYCap)
            { }
            column(Note; Note)
            { }
            column(Regards; RegardsCap)
            { }
            column(Contact; ContactCap)
            { }
            column(Payment_Terms_Code; "Payment Terms Code")
            { }
            column(Text001; Text001Cap)
            { }
            column(PurchName; PurchName)
            { }
            column(PhoneNo; PhoneNo)
            { }
            column(EmailId; EmailId)
            { }
            column(Signiture; UserSetup."User Signature")
            { }
            column(Designation; UserSetup.Designation)
            { }
            column(FullName; User."Full Name")
            { }


            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(Description; Description)
                { }
                column(Unit_of_Measure; "Unit of Measure")
                { }
                column(Quantity; Quantity)
                { }
                column(Make_B2B; Make_B2B)
                { }
            }
            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                if StateGRec.Get(CompanyInfo."State Code") then;
                if VendorGRec.Get("Buy-from Vendor No.") then;
                if StateGRec2.Get(VendorGRec."State Code") then;

                OrderAddress.Reset();
                OrderAddress.SetRange("Vendor No.", "Purchase Header"."Buy-from Vendor No.");
                if OrderAddress.FindSet() then begin
                    repeat
                        if OrderAddress.Name <> '' then
                            ContactName := ContactName + OrderAddress.Name + '/';
                        if OrderAddress."E-Mail" <> '' then
                            ContactEmail := ContactEmail + OrderAddress."E-Mail" + '/';
                        if OrderAddress."Phone No." <> '' then
                            ContactPhNo := ContactPhNo + OrderAddress."Phone No." + '/';
                    until OrderAddress.Next = 0;
                    ContactName := DelChr(ContactName, '<>', '/');
                    ContactEmail := DelChr(ContactEmail, '<>', '/');
                    ContactPhNo := DelChr(ContactPhNo, '<>', '/');
                end;
                PurchaseCode.Reset();
                PurchaseCode.setrange(Code, "Purchase Header"."Purchaser Code");
                if PurchaseCode.FindFirst() then begin
                    PurchName := PurchaseCode.Name;
                    EmailId := PurchaseCode."E-Mail";
                    PhoneNo := PurchaseCode."Phone No.";
                end;
                ApprovalEntries.Reset();
                ApprovalEntries.SetRange("Table ID", Database::"Purchase Header");
                ApprovalEntries.SetRange("Document No.", "Purchase Header"."No.");
                ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                if ApprovalEntries.findlast() then begin
                    if "Purchase Header".Status = "Purchase Header".Status::Released then begin
                        UserSetup.Get(ApprovalEntries."Approver ID");
                        User.Reset();
                        User.SetRange("User Name", UserSetup."User ID");
                        if User.FindFirst() then;
                    end;
                end;
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
                    /* field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    } */
                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        StateGRec: Record State;
        VendorGRec: Record Vendor;
        StateGRec2: Record State;
        PurchaseCode: Record "Salesperson/Purchaser";
        OrderAddress: Record "Order Address";
        ApprovalEntries: Record "Approval Entry";
        UserSetup: Record "User Setup";
        User: Record User;
        PurchName: Text;
        EmailId: Text;
        PhoneNo: Text;
        ContactName: Text;
        ContactEmail: Text;
        ContactPhNo: Text;
        DearCap: Label 'Dear Sir/Madam,';
        RequirementCap: Label 'We are having requirement of the following';
        KindAttCap: Label 'Kind Attn: ';
        StateCap: Label 'State: ';
        StateCodeCap: Label 'State Code: ';
        GSTCap: Label 'GST No. : ';
        DateCap: Label 'Date: ';
        TOCap: Label 'To';
        PHCap: Label 'PH: ';
        EmailCap: Label 'Email: ';
        GSTINCap: Label 'GSTIN: ';
        MobileCap: Label 'Mobile: ';
        SNoCap: Label 'Sl No';
        MaterialCap: Label 'Material Description';
        UOMCap: Label 'UOM';
        QTYCap: Label 'QTY';
        Text001Cap: Label 'Your immediate reply will be higly appreciated.';
        RegardsCap: Label 'Regards,';
        ContactCap: Label 'Contact Person for Clarification';
}