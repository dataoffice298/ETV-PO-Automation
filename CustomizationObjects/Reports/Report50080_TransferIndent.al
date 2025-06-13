report 50300 "CAPITAL ASSET MOVEMENT"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'CAPITAL ASSET MOVEMENT';

    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {

            DataItemTableView = sorting("Document Date") where("Indent Transfer" = const(true), Post = const(true));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                indentLine: Record "Indent Line";
                Fixedasset: Record "Fixed Asset";
            begin
                indentLine.Reset();
                indentLine.SetRange("Document No.", "Indent Header"."No.");
                if indentLine.FindSet() then begin
                    repeat
                        ExcelBuffer.NewRow();
                        ExcelBuffer.AddColumn(sl, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        sl += 1;
                        ExcelBuffer.AddColumn(indentLine."Document No.", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Indent Header"."Document Date", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Date);
                        ExcelBuffer.AddColumn(indentLine."No.", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(indentLine.Description, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(indentLine."Req.Quantity", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Number);
                        if Fixedasset.Get(indentLine."No.") then begin
                            ExcelBuffer.AddColumn(Fixedasset.Make_B2B, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Fixedasset."Model No.", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Fixedasset."Serial No.", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        end;
                        ExcelBuffer.AddColumn("Indent Header"."Transfer-from Code", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::text);
                        ExcelBuffer.AddColumn("Indent Header"."Sub Location code", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Indent Header"."Physical Location", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Indent Header"."Transfer-to Code", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Indent Header"."FA Sub Location code", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Indent Header"."FA Physical Location", FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn("Indent Header".Purpose, FALSE, '', false, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
                    until indentLine.Next() = 0;
                end;
            end;

            trigger OnPreDataItem()
            var
                StartDate: Date;
                EndDate: Date;
            begin
                if (StartDatevar <> 0D) and (EndDatevar <> 0D) then
                    SetFilter("Document Date", '%1..%2', StartDatevar, EndDatevar);

            end;
        }

    }
    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(StartDate; StartDatevar)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDatevar)
                    {
                        ApplicationArea = all;
                        Caption = 'End Date';
                    }
                }
                /*  group(CAM)
                 {
                     field("Capital Asset Movement"; CAM)
                     {
                         ApplicationArea = ALL;
                         // TableRelation = "Indent Header";
                         trigger OnLookup(var Text: Text): Boolean
                         var
                             IndentHdr: Record "Indent Header";
                         begin
                             IndentHdr.Reset();
                             // IndentHdr.SetRange("No.", "Indent Header"."No.");
                             IndentHdr.SetRange(Post, true);

                             if Page.RunModal(Page::"Posted Transfer Indent List", IndentHdr) = Action::LookupOK then
                                 CAM := IndentHdr."No.";
                         end;
                     }
                 } */
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }
    trigger OnPreReport()
    begin
        sl := 1;
        CLEAR(ExcelBuffer);
        ExcelBuffer.DELETEALL;
        CreateCaptions();
    end;

    trigger OnPostReport()
    begin
        ExcelBuffer.CreateNewBook('CAPITAL ASSET MOVEMENT');
        ExcelBuffer.WriteSheet('CAPITAL ASSET MOVEMENT', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('CAPITAL ASSET MOVEMENT');
        ExcelBuffer.OpenExcel();
    end;

    Procedure CreateCaptions()
    begin
        AddHeader();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Sl No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CAM No.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CAM Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FA Code /TAG', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Asset Description', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Make', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Model No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Serial No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Main Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sub Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Physical Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Main Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Sub Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Physical Location', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Reasons for Transfer', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddHeader()
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Report: CAPITAL ASSET MOVEMENT', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Company Name: ' + CompanyInfo.Name, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Start Date: ' + Format(StartDatevar), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('End Date: ' + Format(EndDatevar), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('From Location', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('To Location', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    var
        ExcelBuffer: Record "Excel Buffer";
        StartDatevar: Date;
        EndDatevar: Date;
        sl: Integer;
        CAM: Code[50];

}