page 50166 "Posted Inward Gate SubFm-RGP"
{

    Caption = 'Posted RGP-INWARD Subform';
    UsageCategory = Tasks;
    ApplicationArea = ALL;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Posted Gate Entry Line_B2B";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Challan No."; "Challan No.")
                {
                    ApplicationArea = ALL;
                }
                field("Challan Date"; "Challan Date")
                {
                    ApplicationArea = ALL;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = ALL;

                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = ALL;
                }
                field("Source Name"; "Source Name")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Description)
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = ALL;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Posted RGP OUT NO."; "Posted RGP OUT NO.")
                {
                    ApplicationArea = all;
                }
                field("Posted RGP OUT NO. Line"; "Posted RGP OUT NO. Line")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

