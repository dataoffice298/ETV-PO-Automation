page 50156 "Outward Gate Entry List-RGP"
{
    Caption = 'RGP-OUTWARD List';
    UsageCategory = Lists;
    ApplicationArea = ALL;

    CardPageID = "Outward Gate Entry - RGP";
    PageType = List;
    SourceTable = "Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Outward), Type = const(RGP));

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
                field("LR/RR No."; "LR/RR No.")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR Date"; "LR/RR Date")
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
            }
        }
    }
}

