page 50223 "Posted Transfer Indent Header"
{
    // version PH1.0,PO1.0,REP1.0

    PageType = Document;
    SourceTable = "Indent Header";
    Caption = 'POSTED CAM REQUEST';
    SourceTableView = where("Indent Transfer" = const(true), Post = const(true));
    Editable = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; rec."No.")
                {
                    AssistEdit = true;
                    //Editable = PageEditable;//B2BVCOn28Sep22
                    ApplicationArea = All;
                    trigger OnAssistEdit();
                    begin
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                    //Editable = PageEditable;//B2BVCOn28Sep22

                }
                field(Indentor; rec.Indentor)
                {
                    Caption = 'Indentor';
                    ApplicationArea = all;
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                field(Department; rec.Department)
                {
                    Visible = false;
                    ApplicationArea = all;
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("Document Date"; rec."Document Date")
                {
                    Caption = 'Order Date';
                    ApplicationArea = all;
                    //Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("Released Status"; rec."Released Status")
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                    //Editable = false;//B2BVCOn28Sep22

                }
                field("User Id"; rec."User Id")
                {
                    ApplicationArea = all;
                    //Editable = PageEditable;//B2BVCOn28Sep22

                }
                field(Authorized; rec.Authorized)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                }
                //B2BMSOn13Sep2022>>
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = All;
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("Ammendent Comments"; Rec."Ammendent Comments")
                {
                    ApplicationArea = All;
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                //B2BMSOn13Sep2022<<

                // >> B2BPAV 
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 1 Code';
                    //Editable =  PageEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")//B2BSSD16MAR2023
                {
                    ApplicationArea = All;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = Location;
                    //Editable = (Status = Status::Open) AND EnableTransferFields;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that items are transferred from.';
                    // Editable = PageEditable;//B2BVCOn28Sep22

                    //B2BMSOn27Oct2022>>
                    trigger OnValidate()
                    var
                        Userwisesetup: Codeunit UserWiseSecuritySetup;
                    begin
                        if (Rec."Transfer-from Code" <> '') and (Rec."Transfer-to Code" <> '') then begin
                            if Rec."Transfer-from Code" = Rec."Transfer-to Code" then
                                Error('Transfer-From and Transfer-To Codes must not be the same.');
                        end;
                        //B2BSSD11APR2023<<
                        if not Userwisesetup.CheckUserLocation(UserId, Rec."Transfer-from Code", 1) then
                            Error('User %1 dont have permission to location %2', UserId, Rec."Transfer-from Code");
                        //B2BSSD11APR2023>>
                    end;
                    //B2BMSOn27Oct2022<<

                }
                field("Sub Location code"; "Sub Location code")
                {
                    ApplicationArea = all;
                }
                field("Physical Location"; "Physical Location")
                {
                    ApplicationArea = all;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = Location;
                    // Editable = (Status = Status::Open) AND EnableTransferFields;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that the items are transferred to.';
                    //Editable = PageEditable;//B2BVCOn28Sep22

                    //B2BMSOn27Oct2022>>
                    trigger OnValidate()
                    begin
                        if (Rec."Transfer-from Code" <> '') and (Rec."Transfer-to Code" <> '') then begin
                            if Rec."Transfer-from Code" = Rec."Transfer-to Code" then
                                Error('Transfer-From and Transfer-To Codes must not be the same.');
                        end;
                    end;
                    //B2BMSOn27Oct2022<<

                }
                field("FA Physical Location"; "FA Physical Location")
                {
                    ApplicationArea = all;
                }
                field("FA Sub Location code"; "FA Sub Location code")
                {
                    ApplicationArea = all;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = Location;
                    // Editable = EnableTransferFields;
                    // Enabled = (NOT "Direct Transfer") AND (Status = Status::Open);
                    ToolTip = 'Specifies the in-transit code for the transfer order, such as a shipping agent.';
                    // Editable = PageEditable;//B2BVCOn28Sep22

                }
                field("programme Name"; Rec."programme Name")//B2BSSD20MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'programme Name';
                }
                field(Purpose; Rec.Purpose)//B2BSSD23MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'Purpose';
                }
                field(Post; Post)
                {
                    ApplicationArea = all;
                }
            }
            //B2BPAV<<
            part(TransferindentLine; "Transfer Indent Line")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
                //Editable = PageEditable;//B2BVCOn28Sep22
            }
        }

    }

    actions
    {
        area(processing)
        {
            action("Capital Asset Movement")
            {
                ApplicationArea = All;
                Caption = 'Capital Asset Movement';

                trigger OnAction()
                var
                    INdent: Record "Indent Header";

                begin
                    INdent.Reset();
                    INdent.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"CAPITAL ASSET MOVEMENT", true, false, INdent);

                end;
            }

        }
    }



}