page 50165 "Posted Outward Gate Entry-RGP"
{
    Caption = 'Posted RGP-OUTWARD';
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = ALL;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                }
                field("To Location"; Rec."To Location")
                {
                    ApplicationArea = All;
                    Caption = 'To Location';
                }
                field(SubLocation; Rec.SubLocation)//B2BSSD27MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'Sub Location';
                }
                field("Station From/To"; Rec."Station From/To")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                    Visible = false;
                    Importance = Additional;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                    Importance = Additional;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = ALL;
                }
                field("Posting Time"; Rec."Posting Time")
                {
                    ApplicationArea = ALL;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = ALL;
                }
                field("Document Time"; Rec."Document Time")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    ApplicationArea = ALL;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = ALL;
                }
                field("Gate Entry No."; Rec."Gate Entry No.")
                {
                    ApplicationArea = ALL;
                }
                field(StaffNo; Rec.StaffNo)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Importance = Additional;
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Accounting Location';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Caption = 'CC Code';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Importance = Additional;
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Vend Type"; Rec."Vend Type")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                //B2BSSD02Jan2023<<
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                //B2BSSD02Jan2023>>

                //B2BSSD02MAR2023<<
                field("Challan No."; Rec."Challan Date")
                {
                    ApplicationArea = All;
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    ApplicationArea = All;
                }
                //B2BSSD02MAR2023>>
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
                action(delete)
                {
                    Image = Delete;
                    trigger OnAction()
                    var
                        PostedRGPOutward: Record "Posted Gate Entry Line_B2B";
                    begin
                        PostedRGPOutward.Get(PostedRGPOutward."Entry Type"::Outward, PostedRGPOutward.Type::RGP, 'RGPO-0086', '10000');
                        PostedRGPOutward.Delete();
                    end;
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

