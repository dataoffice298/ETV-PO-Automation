page 50167 "PostedOutwardGateEntryList-RGP"
{
    Caption = 'Posted RGP-OUTWARD List';
    CardPageID = "Posted Outward Gate Entry-RGP";
    UsageCategory = Lists;
    ApplicationArea = ALL;
    PageType = List;
    SourceTable = "Posted Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = FILTER(Outward), Type = const(RGP));

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

