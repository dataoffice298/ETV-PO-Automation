pageextension 50117 TransferOrederExt extends "Transfer Order"//B2BSSD20MAR2023
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = All;
                Caption = 'Shortcut Dimension 9 Code';
            }
            field("Programme Name"; Rec."Programme Name")
            {
                ApplicationArea = All;
                Caption = 'Programme Name';
            }
            field(Purpose; Rec.Purpose)//B2BSSD23MAR2023
            {
                ApplicationArea = All;
                Caption = 'Purpose';
            }
        }
        //B2BSSD11APR2023<<
        modify("Transfer-from Code")
        {
            trigger OnAfterValidate()
            var
                UserWiseLocation: Record "Location Wise User";
                userwisesecurity: Codeunit UserWiseSecuritySetup;
            begin
                if not userwisesecurity.CheckUserLocation(UserId, Rec."Transfer-from Code", 6) then
                    Error('User %1 dont have permission to location %2', UserId, Rec."Transfer-from Code");
            end;
        }
        //B2BSSD11APR2023>>
    }
}