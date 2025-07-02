report 50135 NonInventoryItemIssue
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Non-Inventory Item Issue';

    dataset
    {
        dataitem(IndentHeader; "Indent Header")
        {
            trigger OnPreDataItem()
            begin
                SetRange("No.", IndentDocNo);
            end;

            trigger OnAfterGetRecord()
            begin
                ArchiveNonInventoryQtyIssuedNew();
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
                    field(IssueDocNo; IssueDocNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Issue Document No.';
                    }
                    field(IssueDate; IssueDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Issue Date';
                    }
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

    procedure ArchiveNonInventoryQtyIssuedNew()
    var
        IndentLine: Record "Indent Line";
        ArchiveIndHdr: Record "Archive Indent Header";
        ArchiveIndLine: Record "Archive Indent Line";
        IndentLineRec: Record "Indent Line";
        ArchiveVersion: Integer;
        ArchiveDoc: Boolean;
    begin
        IF NOT (IndentHeader."Indent Status" = IndentHeader."Indent Status"::Close) OR (IndentHeader."Indent Status" = IndentHeader."Indent Status"::Cancel) THEN BEGIN
            ArchiveDoc := false;
            IndentLine.Reset();
            IndentLine.SetRange("Document No.", IndentDocNo);
            IndentLine.SetFilter("Qty To Issue", '>%1', 0);
            if IndentLine.FindSet() then begin
                repeat
                    ArchiveIndLine.Reset();
                    ArchiveIndLine.SetRange("Document No.", IndentLine."Document No.");
                    ArchiveIndLine.SetRange("Line No.", IndentLine."Line No.");
                    ArchiveIndLine.SetRange("Archived Qty Issued", IndentLine."Qty To Issue");
                    if not ArchiveIndLine.FindFirst() then begin
                        if ArchiveDoc = false then begin
                            ArchiveIndHdr.Reset();
                            ArchiveIndHdr.SetCurrentKey("Archived Version");
                            ArchiveIndHdr.SetRange("No.", IndentDocNo);
                            if ArchiveIndHdr.FindLast() then
                                ArchiveVersion := ArchiveIndHdr."Archived Version" + 1
                            else
                                ArchiveVersion := 1;

                            ArchiveIndHdr.Init();
                            ArchiveIndHdr.TransferFields(IndentHeader);
                            ArchiveIndHdr."Archived Version" := ArchiveVersion;
                            ArchiveIndHdr."Archived By" := UserId;
                            ArchiveIndHdr."Issue Doc No." := IssueDocNo;
                            ArchiveIndHdr."Issue Date" := IssueDate;
                            ArchiveIndHdr."Indent Issued" := true;
                            ArchiveIndHdr.Insert();
                            ArchiveDoc := true;
                        end;
                        ArchiveIndLine.Init();
                        ArchiveIndLine.TransferFields(IndentLine);
                        ArchiveIndLine."Archived Version" := ArchiveVersion;
                        ArchiveIndLine."Archived By" := UserId;
                        ArchiveIndLine."Archived Qty Issued" := IndentLine."Qty To Issue";
                        ArchiveIndLine.Insert();
                        IndentLine."Archive Indent" := false;
                        IndentLine."Non-Inventory Item Qty Issued" += IndentLine."Qty To Issue";
                        IndentLine."Qty To Issue" := 0;
                        IndentLine.Modify;
                    end else begin
                        ArchiveIndLine.Reset();
                        ArchiveIndLine.SetRange("Document No.", IndentLine."Document No.");
                        ArchiveIndLine.SetRange("Line No.", IndentLine."Line No.");
                        ArchiveIndLine.SetRange("Archived Qty Issued", IndentLine."Qty To Issue");
                        if ArchiveIndLine.FindFirst() then begin
                            ArchiveIndHdr.Reset();
                            ArchiveIndHdr.SetCurrentKey("Archived Version");
                            ArchiveIndHdr.SetRange("No.", IndentDocNo);
                            if ArchiveIndHdr.FindLast() then
                                ArchiveVersion := ArchiveIndHdr."Archived Version" + 1
                            else
                                ArchiveVersion := 1;

                            ArchiveIndHdr.Init();
                            ArchiveIndHdr.TransferFields(IndentHeader);
                            ArchiveIndHdr."Archived Version" := ArchiveVersion;
                            ArchiveIndHdr."Issue Doc No." := IssueDocNo;
                            ArchiveIndHdr."Issue Date" := IssueDate;
                            ArchiveIndHdr."Archived By" := UserId;
                            ArchiveIndHdr."Indent Issued" := true;
                            ArchiveIndHdr.Insert();

                            ArchiveIndLine.Init();
                            ArchiveIndLine.TransferFields(IndentLine);
                            ArchiveIndLine."Archived Version" := ArchiveVersion;
                            ArchiveIndLine."Archived By" := UserId;
                            ArchiveIndLine."Archived Qty Issued" := IndentLine."Qty To Issue";
                            ArchiveIndLine.Insert();
                            IndentLine."Archive Indent" := false;
                            IndentLine."Non-Inventory Item Qty Issued" += IndentLine."Qty To Issue";
                            IndentLine."Qty To Issue" := 0;
                            IndentLine.Modify;
                        end;
                    end;
                    IndentLineRec.Reset();
                    IndentLineRec.SetRange("Document No.", IndentLine."Document No.");
                    IndentLineRec.SetRange("Line No.", IndentLine."Line No.");
                    if IndentLineRec.FindFirst() then begin
                        if IndentLineRec."Req.Quantity" = IndentLineRec."Non-Inventory Item Qty Issued" then begin
                            IndentLineRec.Closed := true;
                            if IndentLineRec."ShortClose Status" = IndentLineRec."ShortClose Status"::" " then
                                IndentLineRec."ShortClose Status" := IndentLineRec."ShortClose Status"::Closed;
                            IndentLineRec.Modify;
                        end;
                    end;
                until IndentLine.Next() = 0;
                Message('Document Archived %1', IndentDocNo);
            end else
                Error('Noting to transfer');

        end;
    end;

    procedure GetValue(IndentNo: Code[20])
    begin
        IndentDocNo := IndentNo;
    end;

    var
        IssueDocNo: Code[20];
        IssueDate: Date;
        IndentDocNo: Code[20];
        IndentLine: Record "Indent Line";
}