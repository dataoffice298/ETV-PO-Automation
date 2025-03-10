reportextension 50002 "Purchase Order Report Ext" extends "Standard Purchase - Order"
{
    //BNaveenB2B25092024 >>
    dataset
    {
        add("Purchase Header")
        {
            column(ApproverId; '')
            {
            }
            column(ContactPersonDetLbl3; ContactPersonDetLbl3)
            {
            }
            column(DearSirMadamLbl1; DearSirMadamLbl1)
            {
            }
            column(LicenceKey; LicenceKey)
            {
            }
            column(RegardsLbl5; RegardsLbl5)
            {
            }
            column(POTxt001; POTxt001)
            {
            }
            column(POTxt002; POTxt002)
            {
            }
            column(ARPOtxt001; ARPOtxt001)
            {
            }
            column(ARPOtxt002; ARPOtxt002)
            {
            }
            column(RPOTxt001; RPOTxt001)
            {
            }
            column(RPOTxt002; RPOTxt002)
            {
            }
            column(Canceltxt001; Canceltxt001)
            {
            }
            column(Canceltxt002; Canceltxt002)
            {
            }
            column(APOTxt001; APOTxt001)
            {
            }
            column(APOTxt002; APOTxt002)
            {
            }
            column(UserName; UserName)
            { }
            column(Signature; '')
            { }
            column(Designation; Designation)
            { }
            column(PhoneNo; PhoneNo)
            { }
        }
        modify("Purchase Header")
        {
            trigger OnAfterAfterGetRecord()
            begin
                ApprovalEntryRec.Reset();
                ApprovalEntryRec.SetRange("Document Type", "Purchase Header"."Document Type"::Order);
                ApprovalEntryRec.SetRange("Document No.", "Purchase Header"."No.");
                ApprovalEntryRec.Setfilter(Status, '<>%1', ApprovalEntryRec.Status::Approved);
                if ApprovalEntryRec.Findfirst() then
                    exit
                else begin
                    ApprovalEntryRec.Reset();
                    ApprovalEntryRec.SetRange("Document Type", "Purchase Header"."Document Type"::Order);
                    ApprovalEntryRec.SetRange("Document No.", "Purchase Header"."No.");
                    ApprovalEntryRec.Setfilter(Status, '=%1', ApprovalEntryRec.Status::Approved);
                    ApprovalEntryRec.SetCurrentKey("Sequence No.");
                    if ApprovalEntryRec.Findlast() then
                        ApproverId := ApprovalEntryRec."Approver ID";

                    UserRec.Reset();
                    UserRec.SetRange("User Name", ApproverId);
                    if UserRec.FindFirst() then begin
                        UserName := UserRec."Full Name";
                        if UserSetup.Get(UserRec."User Name") then begin
                            Designation := UserSetup.Designation;
                            PhoneNo := UserSetup."Phone No.";
                            //UserSetup.CalcFields("User Signature");
                        end;
                    end;


                end;

                if not "Purchase Header".Amendment and not "Purchase Header".Regularization and not "Purchase Header"."Cancelled Order" then begin
                    POTxt001 := 'Please find the purchase order ref no: ' + "Purchase Header"."No." + ' Dated ' + format("Purchase Header"."Order Date") + ' of ' + "Purchase Header"."Responsibility Center" + 'EENADU TELIVISON PRIVATE LIMITED division which is system generated and valid with digital signature.';
                    POTxt002 := 'Please acknowledge the receipt and arrange to deliver the ordered material as per terms and conditions mentioned on purchase order.';
                end
                else
                    if "Purchase Header".Amendment and not "Purchase Header".Regularization then begin
                        APOTxt001 := 'We are amending the purchase order ref No: ' + "Purchase Header"."No." + ' Dated ' + Format("Purchase Header"."Order Date") + ' of ' + "Purchase Header"."Responsibility Center" + 'EENADU TELIVISON PRIVATE LIMITED division which is system generated and valid with digital signature.';
                        APOTxt002 := 'Please acknowledge the receipt and arrange to deliver the ordered material as per terms and conditions mentioned on Amendment purchase order.';
                    end
                    else
                        if "Purchase Header".Regularization and not "Purchase Header".Amendment then begin
                            RPOTxt001 := 'We are regularizing the stocks been delivered vide your invoice No: ' + "Purchase Header"."Vendor Invoice No." + ' Dated ' + Format("Purchase Header"."Order Date") + ' and releasing regularization purchase order ref No: ' + "Purchase Header"."No." + ' Dated ' + Format("Purchase Header"."Order Date") + ' of ' + "Purchase Header"."Responsibility Center" + 'EENADU TELIVISON PRIVATE LIMITED division. Find the attachment which is system generated and valid with digital signature.';
                            RPOTxt002 := 'Please acknowledge the receipt.';
                        end
                        else
                            if "Purchase Header".Regularization and "Purchase Header".Amendment then begin
                                ARPOtxt001 := 'We are regularizing the stocks been delivered vide your invoice No ' + "Purchase Header"."Vendor Invoice No." + ' Dated ' + Format("Purchase Header"."Order Date") + ' and releasing amendment cum regularization purchase order ref No: ' + "Purchase Header"."No." + ' Dated ' + Format("Purchase Header"."Order Date") + ' Of ' + "Purchase Header"."Responsibility Center" + 'EENADU TELIVISON PRIVATE LIMITED division. Find the attachment which is system generated and valid with digital signature.';
                                ARPOtxt002 := 'Please acknowledge the receipt.';
                            end
                            else
                                if "Purchase Header"."Cancelled Order" then begin
                                    Canceltxt001 := 'We regret to inform you that, we are cancelling the purchase order ref. no: ' + "Purchase Header"."No." + ' Dated ' + Format("Purchase Header"."Order Date") + ' Of ' + "Purchase Header"."Responsibility Center" + 'EENADU TELIVISON PRIVATE LIMITED division, due to the reason ';
                                    Canceltxt002 := 'Please acknowledge the receipt of order cancellation.';
                                end;
            end;
        }
    }
    rendering
    {
        layout(CustomLayout)
        {
            LayoutFile = 'Report Extensions\Layouts\StandardPurchaseOrderEmail.docx';
            Type = Word;
        }
    }
    var
        DearSirMadamLbl1: Label 'Dear Sir/Madam,';
        ContactPersonDetLbl3: Label 'Contact person’s details are provided on the Purchase Order for clarifications/co-ordination.';
        RegardsLbl5: Label 'Regards,';
        DateLbl21: Label ' Dated ';
        OfLbl22: Label ' of ';
        ApproverId: Code[50];
        LicenceKey: Text;
        POTxt001: Text;
        POTxt002: Text;
        APOTxt001: Text;
        APOTxt002: Text;
        RPOTxt001: Text;
        RPOTxt002: Text;
        ARPOtxt001: Text;
        ARPOtxt002: Text;
        Canceltxt001: Text;
        Canceltxt002: Text;
        ApprovalEntryRec: Record "Approval Entry";
        UserSetup: Record "User Setup";
        UserRec: Record User;
        UserName: Text;
        Designation: Text;
        Signature: Text;
        PhoneNo: Text;


    //BNaveenB2B25092024 <<

}
