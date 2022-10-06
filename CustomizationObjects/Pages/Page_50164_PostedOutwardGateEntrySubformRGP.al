page 50164 "Posted Outward Gate SubFm-RGP"
{
    Caption = 'Posted RGP-OUTWARD Subform';
    AutoSplitKey = true;
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
                    ApplicationArea = all;
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
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Quantity Received"; "Quantity Received")
                {
                    ApplicationArea = all;
                }
                //Balu 05212021>>
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
                //Balu 05212021<<
            }
        }
    }
}

