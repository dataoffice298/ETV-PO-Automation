report 50001 "Indent Requestion Lines"
{
    // version PO

    // PROJECT : WindlassHealthCare
    // *********************************************************************************************************************************************************
    // SIGN
    // *********************************************************************************************************************************************************
    // B2B : B2B Software Technologies
    // *********************************************************************************************************************************************************
    // VER       SIGN       USERID          DATE         DESCRIPTION
    // *********************************************************************************************************************************************************
    // 1.1       B2B        Srikar        12-May-15 -->  Added Code In Indent Line OnAfterGetRecord.

    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1102152001; "Indent Header")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending)
                                WHERE("Released Status" = FILTER(Released));
            RequestFilterFields = "No.", "Delivery Location";
            dataitem(DataItem1102152000; "Indent Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.")
                                    ORDER(Ascending)
                                    WHERE("Indent Status" = CONST(Indent),
                                          "Indent Req No" = FILTER(''));

                trigger OnAfterGetRecord();
                begin

                    IndentRequisitions.RESET;
                    IndentRequisitions.SETRANGE("Item No.", "No.");
                    IndentRequisitions.SETRANGE("Variant Code", "Variant Code");
                    IndentRequisitions.SETRANGE("Location Code", "Delivery Location");
                    IndentRequisitions.SETRANGE("Vendor No.", "Vendor No.");
                    IndentRequisitions.SETRANGE("Document No.", IndentReqHeader."No.");
                    IF IndentRequisitions.FIND('-') THEN BEGIN
                        IndentRequisitions.Quantity += "Quantity (Base)";
                        IndentRequisitions."Qty. To Order" += "Quantity (Base)";
                        IndentRequisitions."Remaining Quantity" += "Quantity (Base)";
                        //B2B.1.3 S
                        ItemVendorGvar.RESET;
                        ItemVendorGvar.SETRANGE("Item No.", IndentRequisitions."Item No.");
                        ItemVendorGvar.SETRANGE("Vendor No.", IndentRequisitions."Manufacturer Code");
                        IF ItemVendorGvar.FINDFIRST THEN;
                        //IndentRequisitions."Vendor Min.Ord.Qty" := ItemVendorGvar."Vendor Min.Ord.Qty"; B2B1.1
                        IndentRequisitions.MODIFY;
                        //B2B.1.3 E
                    END ELSE BEGIN
                        IndentRequisitions.INIT;
                        IndentRequisitions."Document No." := IndentReqHeader."No.";
                        IndentRequisitions."Line No." := TempLineNo;
                        IndentRequisitions."Line Type" := Type; //ETVPO1.1
                        IndentRequisitions."Item No." := "No.";
                        //Message('%1..%2...%3', "No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
                        IndentRequisitions.Description := Description;
                        IF RecItem.GET(IndentRequisitions."Item No.") THEN
                            IndentRequisitions."Unit of Measure" := RecItem."Base Unit of Measure";
                        //  IndentRequisitions."Manufacturer Code" := "Manufacturer Code";//Divya
                        //      IndentRequisitions."Vendor Name" :=  "Indent Line"."Manufacture Name";//Divya
                        IndentRequisitions."Vendor No." := "Vendor No.";
                        //B2B.1.3 s
                        ItemVendorGvar.RESET;
                        ItemVendorGvar.SETRANGE("Item No.", IndentRequisitions."Item No.");
                        ItemVendorGvar.SETRANGE("Vendor No.", IndentRequisitions."Manufacturer Code");
                        IF ItemVendorGvar.FINDFIRST THEN
                            //IndentRequisitions."Vendor Min.Ord.Qty" := ItemVendorGvar."Vendor Min.Ord.Qty" ;B2B1.1
                            //B2B.1.3 E
                            IndentRequisitions.Department := Department;
                        IndentRequisitions."Variant Code" := "Variant Code";
                        IndentRequisitions."Indent No." := "Document No.";
                        IndentRequisitions."Indent Line No." := "Line No.";
                        IndentRequisitions."Indent Status" := "Indent Status";
                        IndentRequisitions.Quantity += "Quantity (Base)";
                        IndentRequisitions."Remaining Quantity" := "Quantity (Base)";
                        IndentRequisitions.VALIDATE(IndentRequisitions.Quantity);//test001
                        IndentRequisitions.VALIDATE(IndentRequisitions.Quantity);
                        IndentRequisitions."Unit Cost" := "Unit Cost";  //Divya
                        //IndentRequisitions.Amount := "Indent Line".Amount;//Divya
                        IndentRequisitions."Location Code" := "Delivery Location";
                        IndentRequisitions."Indent Quantity" := "Req.Quantity";//B2B1.1
                                                                               //    IndentRequisitions."Manufacturer Ref. No." := "Manufacturer Ref. No.";
                        IndentRequisitions."Due Date" := "Due Date";
                        //    IndentRequisitions."Payment Method Code" := "Indent Line"."Payment Meathod Code";//Divya
                        IndentRequisitions."Carry out Action" := TRUE;
                        IndentRequisitions.Validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");//B2BPAV
                        IndentRequisitions.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");//B2BPAV
                        IndentRequisitions.INSERT;
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
                //Message('Hi');
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
        IndentRequisitions: Record 50038;
        RecItem: Record 27;
        RecVendor: Record 23;
        RecLocation: Record 14;
        TempLineNo: Integer;
        QtyNotAvailable: Boolean;
        BoolGvar: Boolean;
        IndentReqHeader: Record 50045;
        IndentReqHeaderGRec: Record 50045;
        RequestNo: Code[20];
        ResponsibilityCenter: Code[20];
        Count1: Integer;
        ItemVendorGvar: Record 99;

    procedure GetValue(var HeaderNo: Code[20]; var RespCenter: Code[20]);
    begin
        RequestNo := HeaderNo;
        ResponsibilityCenter := RespCenter;
    end;
}

