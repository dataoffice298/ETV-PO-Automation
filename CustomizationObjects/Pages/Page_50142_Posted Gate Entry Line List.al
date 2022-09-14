page 50142 "Posted Gate Entry Line List"
{
    // version NAVIN7.00
    UsageCategory = Lists;
    ApplicationArea = ALL;

    Editable = false;
    PageType = List;
    SourceTable = "Posted Gate Entry Line_B2B";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field("Gate Entry No."; "Gate Entry No.")
                {
                    ApplicationArea = ALL;
                }
                field("Line No."; "Line No.")
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
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Quantity Received"; "Quantity Received")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
    }
    procedure SetSelection(var Grl: Record "Posted Gate Entry Line_B2B")
    begin
        CurrPage.SetSelectionFilter(Grl);
    end;
}

