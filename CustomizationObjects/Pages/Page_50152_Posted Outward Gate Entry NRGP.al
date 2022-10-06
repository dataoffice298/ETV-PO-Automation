page 50152 "Posted Outward Gate Entry-NRGP"
{
    Caption = 'Posted NRGP-OUTWARD';
    UsageCategory = Documents;
    Editable = false;
    DeleteAllowed = false;
    PageType = Document;
    SourceTable = "Posted Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Outward), Type = const(NRGP));
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
                field("Gate Entry No."; "Gate Entry No.")
                {
                    ApplicationArea = ALL;//Balu 05092021
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

                field("Transporter No."; "Transporter No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Transporter Name"; "Transporter Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
            part(Control1500028; "Posted Outward Gate SubFm-NRGP")
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
                /*action(List)
                {
                    Image = OpportunitiesList;
                    RunObject = Page "Posted Outward Gate Entry List";
                    ShortCutKey = 'Shift+Ctrl+L';
                }*/
                /*action("Print Non Returnable Gate Pass")
                {
                    Image = Print;
                    trigger OnAction()
                    var
                        uSrSet: Record "User Setup";
                    begin
                        //b2bpksalecorr12 start
                        IF "No. Printed" > 1 then begin
                            uSrSet.get(UserId);
                            IF NOT uSrSet."Reprint Shipmt & GatePass Docs" then
                                Error('You do not have permissions to reprint the document.');
                        end;
                        "No. Printed" += 1;
                        //b2bpksalecorr12 end
                        GateEntryHeaderGRec.Reset();
                        GateEntryHeaderGRec.SetRange("Entry Type", "Entry Type");
                        GateEntryHeaderGRec.SetRange(Type, Type);
                        GateEntryHeaderGRec.SetRange("No.", "No.");
                        Report.Run(Report::"Non Returnable GatePass", true, false, GateEntryHeaderGRec);
                    end;
                }*/
            }
        }
    }
    var
        GateEntryHeaderGRec: Record "Posted Gate Entry Header_B2B";
    //Re: Record 18478;
}

