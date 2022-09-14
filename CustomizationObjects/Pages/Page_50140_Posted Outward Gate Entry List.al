page 50140 "Posted Outward Gate Entry List"
{
    // version NAVIN7.00
    Caption = 'Posted NRGP-OUTWARD List';
    CardPageID = "Posted Outward Gate Entry-NRGP";
    UsageCategory = Lists;
    ApplicationArea = ALL;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Posted Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = FILTER(Outward), Type = const(NRGP));

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                Editable = false;
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field("No."; "No.")
                {
                    ApplicationArea = ALL;
                }
                field("Gate Entry No."; "Gate Entry No.")
                {
                    ApplicationArea = ALL;//Balu 05092021
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

    actions
    {
    }
}

