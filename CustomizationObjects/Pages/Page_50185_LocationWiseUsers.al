page 50185 "Location Wise Users" //B2BSSD29MAR2023
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Location Wise User";
    RefreshOnActivate = true;//B2BSSD30MAR2023
    Caption = 'User Wise Location Permissions';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Location Code';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'User ID';
                }
                field(Indent; Rec.Indent)
                {
                    ApplicationArea = All;
                    Caption = 'Indent';
                }
                field("Transfer Indent Header"; Rec."Transfer Indent Header")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer Indent Header';
                }
                field("Transfer Order"; Rec."Transfer Order")//B2BSSD03APR2023
                {
                    ApplicationArea = All;
                    Caption = 'Transfer Order';
                }
                field(RGPInward; Rec.RGPInward)
                {
                    ApplicationArea = All;
                    Caption = 'RGP Inward';
                }
                field(RGPOutward; Rec.RGPOutward)
                {
                    ApplicationArea = All;
                    Caption = 'RGP Outward';
                }
                field(NRGPOutward; Rec.NRGPOutward)
                {
                    ApplicationArea = All;
                    Caption = 'NRGP Outward';
                }
                field("Item issue"; Rec."Item issue")//B2BSCM23AUG2023
                {
                    ApplicationArea = All;
                    Caption = 'Item Issue';
                }
                field("Item Return"; Rec."Item Return")//B2BSCM23AUG2023
                {
                    ApplicationArea = All;
                    Caption = 'Item Return';
                }
                field("PO Posting"; Rec."PO Posting")//B2BSCM24AUG2023
                {
                    ApplicationArea = All;
                    Caption = 'PO Posting';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}