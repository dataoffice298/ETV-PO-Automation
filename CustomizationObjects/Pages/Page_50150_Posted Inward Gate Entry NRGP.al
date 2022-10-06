page 50150 "Posted Inward Gate Entry-NRGP"
{
    Caption = 'Posted NRGP-INWARD';
    UsageCategory = Documents;
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Inward), Type = const(NRGP));
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = ALL;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = ALL;
                }
                field("Station From/To"; "Station From/To")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = ALL;
                }
                field("Posting Time"; "Posting Time")
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
                field("LR/RR No."; "LR/RR No.")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR Date"; "LR/RR Date")
                {
                    ApplicationArea = ALL;
                }
                field("Vehicle No."; "Vehicle No.")
                {
                    ApplicationArea = ALL;
                }
                field("Gate Entry No."; "Gate Entry No.")
                {
                    ApplicationArea = ALL;
                }
            }
            part(Control1500028; "Posted Inward Gate SubFm-NRGP")
            {
                SubPageLink = "Entry Type" = FIELD("Entry Type"),
                "Type" = field("Type"),
                              "Gate Entry No." = FIELD("No.");
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        /*area(navigation)
        {
            group("&Gate Entry")
            {

                Image = InwardEntry;
                action(List)
                {
                    Image = OpportunitiesList;
                    RunObject = Page "PostedInwardGateEntryList-NRGP";
                    ShortCutKey = 'Shift+Ctrl+L';
                    ApplicationArea = ALL;
                }
            }
        }*/
    }
}

