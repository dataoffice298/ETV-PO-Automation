page 50046 "Archive Indent"
{

    PageType = ListPlus;
    SourceTable = "Archive Indent Header";
    Caption = 'Archive Indent Document';
    //Editable = false;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Archived Version"; Rec."Archived Version")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Archived By"; Rec."Archived By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Indentor; rec.Indentor)
                {
                    Caption = 'Indentor';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Department; rec.Department)
                {
                    Visible = true;
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document Date"; rec."Document Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Released Status"; rec."Released Status")
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                    Editable = false;
                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Authorized; rec.Authorized)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                }
                field("Ammendent Comments"; Rec."Ammendent Comments")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 1 Code';
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 2 Code';
                    Editable = false;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that items are transferred from.';
                    Editable = false;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                    Editable = false;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the in-transit code for the transfer order, such as a shipping agent.';
                    Editable = false;
                }
                field("Indent Issued"; Rec."Indent Issued")
                {
                    ApplicationArea = All;
                    Caption = 'Indent Issued';
                    Editable = false;
                }
                //B2BVCOn01Jan2023 >>
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    Caption = 'Purpose';
                    Editable = false;
                }
                //B2BVCOn01Jan2023 <<
                field("ILE Doc No."; Rec."ILE Doc No.")
                {
                    ApplicationArea = All;
                    Caption = 'ILE Doc No.';
                    Editable = false;
                }
                field("ILE Posting Date"; Rec."ILE Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'ILE Posting Date';
                    Editable = false;
                }
                field("Issue Doc No."; Rec."Issue Doc No.")
                {
                    ApplicationArea = All;
                    Caption = 'Issue Doc No.';
                    Editable = false;
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ApplicationArea = All;
                    Caption = 'Issue Date';
                    Editable = false;
                }
            }
            part(ArchiveIndentSubform; "Archive Indent Subform")
            {
                SubPageLink = "Document No." = FIELD("No."), "Archived Version" = field("Archived Version");
                ApplicationArea = All;
                Editable = false;
            }
        }


    }
    actions
    {
        area(Processing)
        {
            group("&Print")
            {
                action(Print)
                {
                    Caption = 'Print';
                    ApplicationArea = ALL;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;
                    trigger OnAction()

                    begin
                        Archiveindent.Reset();
                        Archiveindent.setrange("No.", rec."No.");
                        Archiveindent.SetRange("Archived Version", Rec."Archived Version");
                        if Archiveindent.findfirst then
                            Report.RunModal(Report::"Archive Material Issue Slip", true, true, Archiveindent);

                    end;
                }
            }
        }
    }
    var
        Archiveindent: Record "Archive Indent Header";
}


