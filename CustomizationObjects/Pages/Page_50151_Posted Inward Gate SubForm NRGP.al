page 50151 "Posted Inward Gate SubFm-NRGP"
{
    Caption = 'Posted NRGP-INWARD Subform';
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
                    OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Item,Fixed Asset,Others';
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
                field(Status; Status)
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}

