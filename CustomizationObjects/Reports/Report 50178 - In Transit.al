report 50178 "In Transit"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'In Transit_50178';
    ProcessingOnly = true;



    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Qty. in Transit" = filter(<> 0));
                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    FA: Record "Fixed Asset";
                    ItemTracking: Record "Tracking Specification";
                    TransHeader: Record "Transfer Header";
                    TransLine: Record "Transfer Line";
                    Reservationentry: Record 337;
                begin
                    clear(Item);
                    if Item.Get("Item No.") then;
                    if FA.Get("Item No.") then;

                    //B2BSSD_08Dec2022<<
                    Reservationentry.Reset();
                    Reservationentry.SetRange("Item No.", "Item No.");
                    Reservationentry.SetRange("Source ID", "Document No.");
                    Reservationentry.SetRange("Source Type", 5741);
                    Reservationentry.SetRange("Source Prod. Order Line", "Line No.");
                    if Reservationentry.FindFirst() then;
                    //B2BSSD_08Dec2022>>

                    SNo += 1;
                    ExcelBuffer1.NewRow();
                    ExcelBuffer1.AddColumn(SNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Number);
                    ExcelBuffer1.AddColumn("Transfer Header"."Transfer-from Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Header"."Transfer-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Line"."Indent No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Line"."Indent Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Header"."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(Item."Item Category Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Line"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn('', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(Reservationentry."Lot No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn(Reservationentry."Serial No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Line"."Transfer Price", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);
                    ExcelBuffer1.AddColumn("Transfer Line".Amount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer1."Cell Type"::Text);

                end;

            }
            trigger OnPreDataItem()
            begin
                SetFilter("Posting Date", '%1..%2', StartDate, EndDate);//B2BSSD27Dec2022
                clear(SNo);
                MakeInTransitHeader();
            end;
        }
    }
    //B2BSSD27Dec2022<<
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
        //B2BSSD27Dec2022>>
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

    /*rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'mylayout.rdl';
        }
    }*/

    trigger OnPostReport()
    begin
        CreateExcelbook();
    end;

    var
        myInt: Integer;
        ExcelBuffer1: Record "Excel Buffer" temporary;
        SNo: Integer;
        StartDate: Date;
        EndDate: Date;

    PROCEDURE MakeInTransitHeader()
    begin
        ExcelBuffer1.NewRow;
        ExcelBuffer1.AddColumn('SL NO.', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('From Stores', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('To Stores', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Indent No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Indent Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Transfer Number', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Transfer Date', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Category', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Sub Category', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Item Code', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Item Name', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('UOM', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Make', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Model No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Serial No', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Qty', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Rate', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);
        ExcelBuffer1.AddColumn('Amount', FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuffer1."Cell Type"::Text);


    end;

    PROCEDURE CreateExcelbook()
    BEGIN
        ExcelBuffer1.CreateBookAndOpenExcel('', 'In Transit', '', COMPANYNAME, USERID);
    END;

}