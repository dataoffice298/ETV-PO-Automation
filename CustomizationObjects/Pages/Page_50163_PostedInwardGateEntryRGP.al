page 50163 "Posted Inward Gate Entry-RGP"
{
    Caption = 'Posted RGP-INWARD';
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Inward), Type = const(RGP));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
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
                field("To Location"; Rec."To Location")//B2BSSD31MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'To Location';
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

                }
                /*field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }*/
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = ALL;
                }
                field("Posting Time"; Rec."Posting Time")
                {
                    ApplicationArea = ALL;
                }
                //B2BSSD02Jan2023<<
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                //B2BSSD02Jan2023>>
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
                //B2BSSD02Jan2023<<
                field("Posted RGP Outward No"; Rec."Posted RGP Outward No")
                {
                    ApplicationArea = All;
                }
                field("Posted RGP Outward Date"; Rec."Posted RGP Outward Date")
                {
                    ApplicationArea = All;
                }
                field(ExpectedDateofReturn; ExpectedDateofReturn)
                {
                    ApplicationArea = All;
                    Caption = 'Expected Date of Return';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    //Caption = 'Department Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    //Caption = 'Channel Code';
                }
                //B2BSSD02Jan2023>>
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")//B2BSSD22FEB2023
                {
                    ApplicationArea = All;
                }
                field("Challan No."; Rec."Challan No.")//B2BSSD02MAR2023
                {
                    ApplicationArea = All;
                }
                field("Challan Date"; Rec."Challan Date")//B2BSSD02MAR2023
                {
                    ApplicationArea = All;
                }
                field(ReceiptDate; Rec."Receipt Date")//B2BSSD23MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'Receipt Date';
                }
            }
            part(Control1500028; "Posted Inward Gate SubFm-RGP")
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
                    RunObject = Page "PostedInwardGateEntryList-NRGP";
                    ShortCutKey = 'Shift+Ctrl+L';
                    ApplicationArea = ALL;
                }
            }
        }
    }
}

