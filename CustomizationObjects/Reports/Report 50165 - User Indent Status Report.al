report 50165 "User Indent Status Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'User Indent Status_50165';

    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");
                CalcFields = "Qty Issued", "Qty Returned";

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    Users, Users2 : Record User;
                    FixedAsset: Record "Fixed Asset";
                    FixedAsset1: Record "Fixed Asset";//B2BSSD30Dec2022
                    ApprovalEntry: Record "Approval Entry";
                    CATEGORY: Text[100];//B2BSSD30Dec2022
                    FADepreciationBookOld: Record "FA Depreciation Book";//B2BSSD30Dec2022
                    IndentorName: Code[30];//B2BSSD27MAR2023
                begin

                    Users.Reset();
                    Users.SetRange("User Name", "Indent Header".Indentor);
                    if Users.FindFirst() then
                        IndentorName := Users."User Name";//B2BSSD27MAR2023

                    if Item.Get("No.") then;
                    if FixedAsset.Get("No.") then;
                    WindPa.Update(1, "Document No.");
                    //B2BSSD06122022<<
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetCurrentKey("Sequence No.");
                    ApprovalEntry.SetRange("Document No.", "Indent Header"."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                    if ApprovalEntry.FindFirst() then begin
                        "Indent Header"."Approver Name" := ApprovalEntry."Approver ID";
                    end;

                    //B2BAnusha02Jan>>
                    PurchaseLineRec.Reset();
                    PurchaseLineRec.SetRange("Indent No.", "Indent Line"."Document No.");
                    PurchaseLineRec.SetRange("Indent Line No.", "Indent Line"."Line No.");
                    if PurchaseLineRec.FindFirst() then begin
                        QuantityVar := PurchaseLineRec.Quantity;
                    end;
                    //B2BAnusha02Jan<<
                    //B2BSSD30Dec2022<<
                    case Type of
                        Type::"Item":
                            begin
                                if Item.Get("No.") then
                                    CATEGORY := Item."Item Category Code";
                            end;
                        Type::"Fixed Assets":
                            begin
                                if FixedAsset1.Get("No.") then
                                    CATEGORY := FixedAsset1."FA Class Code";
                                Clear(FADepreciationBookOld);
                                FADepreciationBookOld.SetRange("FA No.", "No.");
                                if FADepreciationBookOld.Count <= 1 then begin
                                    if not FADepreciationBookOld.FindFirst then
                                        Clear(FADepreciationBookOld);
                                end;
                            end;
                    end;
                    //B2BSSD30Dec2022>>

                    //B2BSSD11APR2023<<
                    if "Indent Line"."Req.Quantity" = 0 then
                        CurrReport.Skip();
                    //B2BSSD11APR2023>>
                    SNo += 1;
                    TempExcelBuffer.NewRow();
                    //TempExcelBuffer.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Document No.", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Indent Header"."Document Date", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Date);
                    TempExcelBuffer.AddColumn(IndentorName, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD27MAR2023
                    TempExcelBuffer.AddColumn("Indent Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Req.Quantity", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Indent Header"."Shortcut Dimension 2 Code", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Release Status", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    TempExcelBuffer.AddColumn("Indent Line".Status, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);


                    TempExcelBuffer.AddColumn("Indent Header".Purpose, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    //B2BAnusha02Jan>>
                    TempExcelBuffer.AddColumn(QuantityVar, FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    //B2BAnusha02Jan<<
                    TempExcelBuffer.AddColumn("Qty Issued", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("Qty Returned", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    //B2BAnusha02Jan>>
                    TempExcelBuffer.AddColumn("ShortClose Qty", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Number);
                    TempExcelBuffer.AddColumn("ShortClose Status", FALSE, '', FALSE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
                    //B2BAnusha02Jan<<
                end;
            }
            trigger OnPreDataItem()
            begin
                SetFilter("Document Date", '%1..%2', StartDate, EndDate);//B2BSSD20Dec2022
                Clear(SNo);
                MakeExcelHeaders();
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Date Filters")
                {
                    field(StartDate;
                    StartDate)
                    {
                        ApplicationArea = all;
                    }
                    field(EndDate;
                    EndDate)
                    {
                        ApplicationArea = all;
                    }

                }
            }
        }

    }

    trigger OnPreReport()
    begin
        TempExcelBuffer.DeleteAll();
    end;

    trigger OnPostReport()
    begin

        WindPa.CLOSE();
        TempExcelBuffer.CreateBookAndOpenExcel('', 'Indent', '', COMPANYNAME, USERID);
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        StartDate: Date;
        EndDate: Date;
        WindPa: Dialog;
        SNo: Integer;
        IndentReqHeder: Record "Indent Req Header";
        IndentReqLine: Record "Indent Requisitions";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        IndentReqNo: Code[20];
        ApprovalDate: DateTime;


    procedure MakeExcelHeaders()
    begin
        WindPa.OPEN('Processing #1###############');
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('INDENT DETAILED STATUS', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        IF (StartDate <> 0D) or (EndDate <> 0D) THEN
            TempExcelBuffer.AddColumn('INDENT DETAILED STATUS FROM ' + Format(StartDate) + ' TO ' + Format(EndDate), FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        //TempExcelBuffer.AddColumn('SNo.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INDENT NO.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INDENT DATE', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('INDENTOR NAME', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Dept Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Line No', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Item Code', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Variant', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indentor Description', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD21Dec2022
        TempExcelBuffer.AddColumn('Spec ID', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Unit of Measurement', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);//B2BSSD21Dec2022
        TempExcelBuffer.AddColumn('Indent Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //B2BAnusha02Jan>>
        TempExcelBuffer.AddColumn('Indent Approved By', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Last Approval Date & Time', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //B2BAnusha02Jan<<
        TempExcelBuffer.AddColumn('Indent Requisition No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Requisition Date', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Responsibility Center', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Requisition Status', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Qty Ordered', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('PO Number', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Unit Cost', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Received Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Remaining Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor No.', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vendor Name', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Requisition Last Approval Date&Time', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Purpose', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //B2BAnusha02Jan>>
        TempExcelBuffer.AddColumn('Requested Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //B2BAnusha02Jan<<
        TempExcelBuffer.AddColumn('Issued Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //B2BAnusha02Jan>>
        TempExcelBuffer.AddColumn('Return Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Cancelled/Closed/Short Closed Qty', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Indent Line Status', FALSE, '', TRUE, FALSE, FALSE, '', TempExcelBuffer."Cell Type"::Text);
        //B2BAnusha02Jan<<
    end;

    var
        ApprovalEntryRec: Record "Approval Entry";
        UserRec: Record User;
        PurchaseLineRec: Record "Purchase Line";
        ReqLastDatetime: DateTime;
        QuantityVar: Decimal;
        ReqDateAndTime: DateTime;
        IndentReqHeaderrec: Record "Indent Req Header";
}