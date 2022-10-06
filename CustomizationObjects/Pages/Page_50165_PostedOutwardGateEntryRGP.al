page 50165 "Posted Outward Gate Entry-RGP"
{
    Caption = 'Posted RGP-OUTWARD';
    UsageCategory = Documents;
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Outward), Type = const(RGP));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Type; Type)
                {
                    ApplicationArea = all;
                    Editable = false;
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
                field(StaffNo; StaffNo)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Staff Name"; "Staff Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Caption = 'Accounting Location';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Caption = 'CC Code';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Vendor No"; "Vendor No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Vend Type"; "Vend Type")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
            }

            part(Control1500028; "Posted Outward Gate SubFm-RGP")
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
        area(navigation)
        {
            group("&Gate Entry")
            {
                Image = InwardEntry;
                action(List)
                {
                    Image = OpportunitiesList;
                    RunObject = Page "Posted Outward Gate Entry List";
                    ShortCutKey = 'Shift+Ctrl+L';
                }
                /*action("Print Returnable Gate Pass")
                {
                    Image = Print;
                    trigger OnAction()
                    begin
                        GateEntryHeaderGRec.Reset();
                        GateEntryHeaderGRec.SetRange("Entry Type", "Entry Type");
                        GateEntryHeaderGRec.SetRange(Type, Type);
                        GateEntryHeaderGRec.SetRange("No.", "No.");
                        Report.Run(Report::"Returnable GatePass", true, false, GateEntryHeaderGRec);
                    end;
            }*///Commented By B2BJK
            }
        }
    }
    var
        GateEntryHeaderGRec: Record "Posted Gate Entry Header_B2B";
}

