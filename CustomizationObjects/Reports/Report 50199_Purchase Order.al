report 50199 "Purchase Order Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'PurchaseOrderReport.rdl';
    Caption = 'Staff Purchase Indent Report';
    dataset
    {
        dataitem(IndentRequisitions; "Indent Requisitions")
        {
            DataItemTableView = SORTING("Document No.", "Line No.") order(ascending);
            //DataItemTableView = SORTING("No.") ORDER(Ascending);
            // column(Responsibility_Center; "Responsibility Center") { }
            column(RegularVAr; RegularVAr) { }
            column(PurposeNameVar; PurposeNameVar) { }
            column(SNoLbl; SNoLbl) { }
            column(RegularizationLbl; RegularizationLbl) { }
            column(IndentNoDateLbl; IndentNoDateLbl) { }
            column(DescriptionLbl; DescriptionLbl) { }
            column(UserPreferencesLbl; UserPreferencesLbl) { }
            column(ReqQtyLbl; ReqQtyLbl) { }
            column(DIvisionLbl; DIvisionLbl) { }
            column(PurchposeLbl; PurchposeLbl) { }
            column(RemarksLbl; RemarksLbl) { }

            column(Description; Description) { }
            column(Purchaser_Code; "Purchaser Code") { }
            column(Quantity; Quantity) { }
            //B2Banusha25NOV2024>>
            //column(IndentNoVar; IndentNoVar) { }
            column(UsersPreferencesVar; UsersPreferencesVar) { }
            //column(DocumentDateVar; DocumentDateVar) { }
            column(SalesPurchasercode; SalesPurchasercode) { }
            column(IndentNoVar; "Document No.") { }
            column(DocumentDate; DocumentDate) { }
            trigger OnAfterGetRecord()
            var
                PrefNo: Text;
            begin
                Clear(RegularVAr);
                Clear(PurposeNameVar);
                SNo += 1;
                if PurchaseCodeRec.get(IndentRequisitions."Purchaser Code") then
                    PurposeNameVar := PurchaseCodeRec.Name;

                Clear(DocumentDate);
                if IndentReqHeader.Get("Document No.") then
                    DocumentDate := IndentReqHeader."Document Date";

                if ("Spec Id" = '') and ("Variant Description" = '') and ("Indentor Description" = '') then
                    UsersPreferencesVar := ''
                else
                    if ("Spec Id" <> '') and ("Variant Description" = '') and ("Indentor Description" = '') then
                        UsersPreferencesVar := "Spec Id"
                    else
                        if ("Spec Id" = '') and ("Variant Description" <> '') and ("Indentor Description" = '') then
                            UsersPreferencesVar := '' + "Variant Description" + ''
                        else
                            if ("Spec Id" = '') and ("Variant Description" = '') and ("Indentor Description" <> '') then
                                UsersPreferencesVar := "Indentor Description"
                            else
                                if ("Spec Id" <> '') and ("Variant Description" <> '') and ("Indentor Description" = '') then
                                    UsersPreferencesVar := "Spec Id" + '/' + "Variant Description"
                                else
                                    if ("Spec Id" = '') and ("Variant Description" <> '') and ("Indentor Description" <> '') then
                                        UsersPreferencesVar := "Variant Description" + '/' + "Indentor Description"
                                    else
                                        if ("Spec Id" <> '') and ("Variant Description" = '') and ("Indentor Description" <> '') then
                                            UsersPreferencesVar := "Spec Id" + '/' + "Indentor Description"
                                        else
                                            if ("Spec Id" <> '') and ("Variant Description" <> '') and ("Indentor Description" <> '') then
                                                UsersPreferencesVar := "Spec Id" + '/' + "Variant Description" + '/' + "Indentor Description";
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Document No.", IndentNoVar);
                if PurchaserCodeVar <> '' then
                    SetFilter("Purchaser Code", PurchaserCodeVar);
            end;

            //B2Banusha25NOV2024<<

            // trigger OnAfterGetRecord()
            // var
            //     PrefNo: Text;
            // begin
            //     Clear(RegularVAr);
            //     Clear(PurposeNameVar);
            //     SNo += 1;
            //     if PurchaseCodeRec.get(IndentRequisitions."Purchaser Code") then
            //         PurposeNameVar := PurchaseCodeRec.Name;
            //     if not IndentRequisitions.Regularization then
            //         RegularVAr := 'N'
            //     else
            //         RegularVAr := 'Y';
            // end;
            //B2Banusha25NOV2024>>
            // trigger OnPreDataItem()
            // begin
            //     if PurchaserCodeVar <> '' then
            //         SetFilter("Purchaser Code", PurchaserCodeVar);
            // end;
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
                    field(PurchaserCodeVar; PurchaserCodeVar)
                    {
                        ApplicationArea = all;
                        Caption = 'Purchaser Code';
                    }
                }
            }
        }
    }
    procedure Setpurchasercode(PurchaserCode: Text)
    begin
        PurchaserCodeVar := PurchaserCode;
    end;

    Procedure SetDocumentDate(Documentdate: Date; IndentNumber: Code[30])
    begin
        DocumentDateVar := Documentdate;
        IndentNoVar := IndentNumber;
    end;
    //B2Banusha25NOV2024<<

    var
        PurchaseCode: Code[20];
        PurchaseCodeRec: Record "Salesperson/Purchaser";
        SNoLbl: Label 'SNo.';
        SNo: Integer;
        DIvisionLbl: Label 'Division';
        IndentNoDateLbl: Label 'Indent No.& Date';
        DescriptionLbl: Label 'Description';
        UserPreferencesLbl: Label 'User Preferences';
        ReqQtyLbl: Label 'Req. Qty';
        RegularizationLbl: Label 'Regularization';
        PurchposeLbl: Label 'Purchaser Code';
        RemarksLbl: Label 'Remarks';
        PurposeNameVar: Text[250];
        RegularVAr: Text[30];
        //B2Banusha25NOV2024>>
        PurchaserCodeVar: Text;
        SalesPurchasercode: Code[40];
        UsersPreferencesVar: Text;
        DocumentDateVar: Date;
        DocumentDate: Date;
        IndentNoVar: Code[30];
        //B2Banusha25NOV2024<<
        IndentReqHeader: Record "Indent Req Header";

}