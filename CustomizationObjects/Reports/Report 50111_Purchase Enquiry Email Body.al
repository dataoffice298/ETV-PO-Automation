report 50111 "Purchase Enquiry EmailBody"
{
    //B2Bspon24Sep2024 Savarappa >>
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './PurchaseEnquiryReport.docx';
    Caption = 'Purchase Enquiry Email Body Report';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            column(DearsirmadamLbl; DearsirmadamLbl)
            { }
            column(Text001Lbl; Text001Lbl)
            { }
            column(Texto002Lbl; Texto002Lbl)
            { }
            column(RegardsLbl; RegardsLbl)
            { }
            column(DesignateVar; DesignateVar)
            { }
            column(UsersetupSig; Usersetup."User Signature")
            { }
            column(UserName; User."Full Name")
            { }
            column(PhoneNo; Usersetup."Phone No.")
            { }


            trigger OnAfterGetRecord()
            begin
                Clear(DesignateVar);
                //Clear();
                ApprovalEntryRec.Reset();
                ApprovalEntryRec.SetRange("Table ID", Database::"Purchase Header");
                ApprovalEntryRec.SetRange("Document No.", PurchaseHeader."No.");
                ApprovalEntryRec.SetRange(Status, ApprovalEntryRec.Status::Approved);
                if ApprovalEntryRec.FindLast() then begin
                    if Usersetup.Get(ApprovalEntryRec."Approver ID") then begin
                        DesignateVar := Usersetup.Designation;
                        //Usersetup.CalcFields("User Signature");
                        User.Reset();
                        User.SetRange("User Name", UserSetup."User ID");
                        if User.FindFirst() then;
                    end;
                end;

            end;
        }

    }


    var
        DearsirmadamLbl: Label 'Dear Sir/Madam.';
        Text001Lbl: Label 'Please find the attachment for our material requirement . Arrange to submit your offer with all terms and conditions.';
        Texto002Lbl: Label 'Contact person’s details are provided in the attachment for clarifications/co-ordination.';
        RegardsLbl: Label 'Regards';
        Usersetup: Record "User Setup";
        ApprovalEntryRec: Record "Approval Entry";
        DesignateVar: Text[250];
        Doc: Codeunit "Document-Mailing";
        User: Record User;
    //B2Bspon24Sep2024 Savarappa <<

}