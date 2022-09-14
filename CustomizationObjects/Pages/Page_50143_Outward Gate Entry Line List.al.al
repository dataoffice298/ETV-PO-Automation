page 50143 "Outward Gate Entry Line List"
{
    // version NAVIN7.00
    UsageCategory = Lists;
    ApplicationArea = ALL;

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Posted Gate Entry Line_B2B";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Gate Entry No."; "Gate Entry No.")
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
                }
                field("Challan No."; "Challan No.")
                {
                    ApplicationArea = ALL;
                }
                field("Challan Date"; "Challan Date")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }

    actions
    {

    }
}

