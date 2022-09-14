page 50154 "Inward Gate Entry List-NRGP"
{
    Caption = 'NRGP-INWARD List';
    UsageCategory = Lists;
    ApplicationArea = ALL;
    CardPageID = "Inward Gate Entry-NRGP";
    PageType = List;
    SourceTable = "Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Inward), Type = const(NRGP));

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                Editable = false;
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field("No."; "No.")
                {
                    ApplicationArea = ALL;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = ALL;
                }
                field("Document Time"; "Document Time")
                {
                    ApplicationArea = ALL;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Description)
                {
                    ApplicationArea = ALL;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR No."; "LR/RR No.")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR Date"; "LR/RR Date")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}

