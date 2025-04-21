report 50001 "Indent Requestion Lines"
{

    ProcessingOnly = true;

    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending) WHERE("Released Status" = FILTER(Released));
            RequestFilterFields = "No.", "Delivery Location";
            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE("Indent Status" = CONST(Indent), Select = const(true),//B2BSCM29AUG2023
                                          "Indent Req No" = FILTER(''));

                trigger OnAfterGetRecord();
                begin
                    //B2BSSD01MAR2023<<
                    CalcFields("Qty Issued");
                    if "Req.Quantity" - Abs("Qty Issued") = 0 then
                        CurrReport.Skip();
                    if Acquired = true then
                        CurrReport.Skip();
                    //B2BSSD01MAR2023<<
                    IndentRequisitions.RESET;
                    IndentRequisitions.SETRANGE("Item No.", "No.");
                    IndentRequisitions.SETRANGE("Variant Code", "Variant Code");
                    IndentRequisitions.SETRANGE("Location Code", "Delivery Location");
                    IndentRequisitions.SETRANGE("Vendor No.", "Vendor No.");
                    IndentRequisitions.SetRange("Line No.", "Indent Req Line No");//B2BSSD20Feb2023
                    IndentRequisitions.SETRANGE("Document No.", IndentReqHeader."No.");
                    IF IndentRequisitions.FIND('-') THEN BEGIN
                        //B2BMSOn14Nov2022>>
                        //IndentRequisitions.Quantity += "Quantity (Base)";
                        //IndentRequisitions."Qty. To Order" += "Quantity (Base)";
                        //IndentRequisitions."Remaining Quantity" += "Quantity (Base)";
                        CalcFields("Qty Issued");
                        IndentRequisitions.Quantity += "Req.Quantity" - Abs("Qty Issued");
                        IndentRequisitions."Qty. To Order" += "Req.Quantity" - Abs("Qty Issued");
                        IndentRequisitions."Remaining Quantity" += "Req.Quantity" - Abs("Qty Issued");
                        //B2BMSOn14Nov2022<<
                        ItemVendorGvar.RESET;
                        ItemVendorGvar.SETRANGE("Item No.", IndentRequisitions."Item No.");
                        ItemVendorGvar.SETRANGE("Vendor No.", IndentRequisitions."Manufacturer Code");
                        IF ItemVendorGvar.FINDFIRST THEN;
                        IndentRequisitions.MODIFY;
                    END
                    ELSE BEGIN
                        //B2BVCOn13Jun2024 >>
                        if (IndentReqHeader."Shortcut Dimension 1 Code" <> '') then begin
                            if (IndentReqHeader."Shortcut Dimension 1 Code" <> "Indent Header"."Shortcut Dimension 1 Code") OR (IndentReqHeader."Shortcut Dimension 2 Code" <> "Indent Header"."Shortcut Dimension 2 Code") OR
                                (IndentReqHeader."Shortcut Dimension 3 Code" <> "Indent Header"."Shortcut Dimension 3 Code") OR (IndentReqHeader."Shortcut Dimension 9 Code" <> "Indent Header"."Shortcut Dimension 9 Code") then
                                Error(Text001, "Indent Header"."Shortcut Dimension 1 Code", "Indent Header"."Shortcut Dimension 2 Code", "Indent Header"."Shortcut Dimension 9 Code", "Indent Header"."Shortcut Dimension 3 Code");
                        end;
                        //B2BVCOn13Jun2024 <<
                        IndentRequisitions.INIT;
                        IndentRequisitions."Document No." := IndentReqHeader."No.";
                        IndentRequisitions."Line No." := TempLineNo;
                        IndentRequisitions."Line Type" := Type;
                        IndentRequisitions."Item No." := "No.";
                        IndentRequisitions."Indentor Description" := "Indentor Description";//B2BSSD02Feb2023
                        IndentRequisitions.Description := Description;
                        IF RecItem.GET(IndentRequisitions."Item No.") THEN
                            IndentRequisitions."Unit of Measure" := RecItem."Base Unit of Measure";
                        IndentRequisitions."Vendor No." := "Vendor No.";
                        ItemVendorGvar.RESET;
                        ItemVendorGvar.SETRANGE("Item No.", IndentRequisitions."Item No.");
                        ItemVendorGvar.SETRANGE("Vendor No.", IndentRequisitions."Manufacturer Code");
                        IF ItemVendorGvar.FINDFIRST THEN
                            IndentRequisitions.Department := Department;
                        IndentRequisitions."Variant Code" := "Variant Code";
                        IndentRequisitions."Variant Description" := "Variant Description"; //B2BSCM11JAN2024
                        IndentRequisitions."Indent No." := "Document No.";
                        IndentRequisitions."Indent Line No." := "Line No.";
                        IndentRequisitions."Indent Status" := "Indent Status";

                        //B2BMSOn14Nov2022>>
                        //IndentRequisitions.Quantity += "Quantity (Base)";
                        //IndentRequisitions."Remaining Quantity" := "Quantity (Base)";
                        IndentRequisitions.Quantity += "Req.Quantity" - Abs("Qty Issued");
                        IndentRequisitions."Remaining Quantity" := "Req.Quantity" - Abs("Qty Issued");
                        //B2BMSOn14Nov2022<<
                        IndentRequisitions.VALIDATE(IndentRequisitions.Quantity);
                        IndentRequisitions."Unit Cost" := "Unit Cost";  //Divya
                        IndentRequisitions.Validate(Amount, Amount);//B2BSSD20FEB2023
                        IndentRequisitions."Location Code" := "Delivery Location";
                        IndentRequisitions."Indent Quantity" := "Req.Quantity";//B2B1.1                                                //    IndentRequisitions."Manufacturer Ref. No." := "Manufacturer Ref. No.";
                        IndentRequisitions."Due Date" := "Due Date";
                        //IndentRequisitions."Payment Method Code" := "Indent Line"."Payment Meathod Code";//Divya
                        IndentRequisitions."Carry out Action" := TRUE;
                        IndentRequisitions.Validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");//B2BPAV
                        IndentRequisitions.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");//B2BPAV
                        IndentRequisitions."Shortcut Dimension 9 Code" := "Indent Line"."Shortcut Dimension 9 Code";//B2BSSD20FEB2023
                        IndentRequisitions.Validate("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code"); //B2BVCOn02April2024
                        IndentRequisitions."Sub Location Code" := "Issue Sub Location";
                        IndentRequisitions."Unit of Measure" := "Unit of Measure";//B2BSSD14MAR2023
                        IndentRequisitions."Spec Id" := "Spec Id";
                        PurchRcptLine.Reset();
                        PurchRcptLine.SetCurrentKey("No.");
                        PurchRcptLine.SetRange("No.", IndentRequisitions."Item No.");
                        if PurchRcptLine.FindLast() then begin
                            IndentRequisitions."Last Purchase Price" := PurchRcptLine."Direct Unit Cost";
                            if RecVendor.Get(PurchRcptLine."Buy-from Vendor No.") then
                                IndentRequisitions."PO Vendor Name" := RecVendor.Name;
                        end;

                        DtldGSTLedgerEntry.Reset();
                        DtldGSTLedgerEntry.SetCurrentKey("Entry No.");
                        DtldGSTLedgerEntry.SetRange("No.", IndentRequisitions."Item No.");
                        DtldGSTLedgerEntry.SetRange("Transaction Type", DtldGSTLedgerEntry."Transaction Type"::Purchase);
                        if DtldGSTLedgerEntry.FindLast() then begin
                            DtldGSTLedgerEntry2.Reset();
                            DtldGSTLedgerEntry2.SetRange("Document No.", DtldGSTLedgerEntry."Document No.");
                            DtldGSTLedgerEntry2.SetRange("No.", DtldGSTLedgerEntry."No.");
                            if DtldGSTLedgerEntry2.FindSet() then
                                repeat
                                    IndentRequisitions."Gst %" += DtldGSTLedgerEntry2."GST %";
                                until DtldGSTLedgerEntry2.Next() = 0;
                        end;

                        IndentRequisitions.INSERT();
                        TempLineNo += 10000;
                    END;
                    "Indent Req No" := IndentRequisitions."Document No.";
                    "Indent Req Line No" := IndentRequisitions."Line No.";
                    MODIFY;
                    if not BoolGvar then begin
                        BoolGvar := true;
                        if IndentReqHeaderGRec.Get(IndentReqHeader."No.") then begin
                            IndentReqHeaderGRec.Validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");//B2BPAV
                            IndentReqHeaderGRec.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");//B2BPAV
                            IndentReqHeaderGRec.Validate("Shortcut Dimension 9 Code", "Shortcut Dimension 9 Code");//B2BSSD21Feb2023
                            IndentReqHeaderGRec.Validate("Shortcut Dimension 3 Code", "Shortcut Dimension 3 Code"); //B2BVCOn02April2024
                            IndentReqHeaderGRec."programme Name" := "Indent Header"."programme Name";//B2BSSD20MAR2023
                            IndentReqHeaderGRec.Purpose := "Indent Header".Purpose;//B2BSSD21MAR2023
                            //B2BVCOn13Jun2024 >>
                            if IndentReqHeaderGRec."Indent No." <> '' then begin
                                IndentNo := IndentReqHeaderGRec."Indent No.";
                                IndentNo := IndentNo + '|' + IndentRequisitions."Indent No.";
                                IndentReqHeaderGRec."Indent No." := IndentNo;
                            end else      //B2BVCOn13Jun2024 <<
                                IndentReqHeaderGRec."Indent No." := IndentRequisitions."Indent No.";
                            IndentReqHeaderGRec.Modify();  //B2BPAV
                        end;
                    end;
                end;

                trigger OnPreDataItem();
                begin
                    IndentReqHeader.RESET;
                    IF IndentReqHeader.GET(RequestNo) THEN;
                    IndentRequisitions.RESET;
                    IndentRequisitions.SETRANGE("Document No.", IndentReqHeader."No.");
                    IF IndentRequisitions.FINDLAST THEN
                        TempLineNo := IndentRequisitions."Line No." + 10000
                    ELSE
                        TempLineNo := 10000;
                end;
            }

            trigger OnPreDataItem()
            begin

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
    }

    var
        IndentRequisitions: Record "Indent Requisitions";
        RecItem: Record 27;
        RecVendor: Record 23;
        RecLocation: Record 14;
        TempLineNo: Integer;
        QtyNotAvailable: Boolean;
        BoolGvar: Boolean;
        IndentReqHeader: Record "Indent Req Header";
        IndentReqHeaderGRec: Record "Indent Req Header";
        RequestNo: Code[20];
        ResponsibilityCenter: Code[20];
        Count1: Integer;
        ItemVendorGvar: Record 99;
        IndentNo: Text;

        PurchRcptLine: Record "Purch. Rcpt. Line";
        DtldGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        DtldGSTLedgerEntry2: Record "Detailed GST Ledger Entry";
        Text001: Label 'Dimensions should be same. Channel Code-%1, Dept Code-%2, Branch Code-%3, Project Code-%4.';

    procedure GetValue(var HeaderNo: Code[20]; var RespCenter: Code[20]);
    begin
        RequestNo := HeaderNo;
        ResponsibilityCenter := RespCenter;
    end;
}

