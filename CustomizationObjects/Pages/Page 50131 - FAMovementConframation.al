page 50131 "FA Movements Confirmation"
{
    Caption = 'FA Movements Confirmation';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    InstructionalText = 'Do you want to Transfer Fixed asset?';
    ModifyAllowed = false;
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(FixedAssetNo; IndentLine."No.")
            {
                ApplicationArea = all;
                Caption = 'Fixed Asset No.';
                Editable = false;
            }
            field(IssuedDateTime; IssuedDateTime)
            {
                ApplicationArea = all;
                Caption = 'Issued Date Time';
            }
            field(IssuedTo; IndentHeader."User Id")
            {
                ApplicationArea = all;
                Caption = 'Issued To User';
                Editable = false;
            }
            field(FromLocation; FromLocation)
            {
                TableRelation = Location;
                ApplicationArea = all;
                Caption = 'From Location';
                //B2BSSD30MAR2023<<
                trigger OnValidate()
                var
                    UserWiseLocation: Record "Location Wise User";
                    userwisesecurity: Codeunit UserWiseSecuritySetup;
                begin
                    UserWiseLocation.Reset();
                    UserWiseLocation.SetRange("Location Code", FromLocation);
                    UserWiseLocation.SetRange(Indent, false);
                    if UserWiseLocation.FindFirst() then
                        Error('Does not have Permmision To This user')
                    else
                        if not userwisesecurity.CheckUserLocation(UserId, FromLocation, 1) then
                            Error('User %1 dont have permission to location %2', UserId, FromLocation);
                end;
                //B2BSSD30MAR2023>>
            }
            field(ToLocation; ToLocation)
            {
                ApplicationArea = all;
                Caption = 'To Location';
                TableRelation = Location;//B2BSSD01MAR2023
            }
            field(Comment; Comment)
            {
                ApplicationArea = all;
                Caption = 'Comments';
            }
        }
    }



    var
        IndentLine: Record "Indent Line";
        IndentHeader: Record "Indent Header";
        IssuedDateTime: DateTime;
        FromLocation: Code[20];
        ToLocation: Code[20];
        IssuedTo: Text[50];
        Comment: Text[500];


    procedure Set(var IndentLine1: Record "Indent Line")
    begin
        IndentLine := IndentLine1;
        if IndentHeader.Get(IndentLine."Document No.") then;
        //FromLocation := IndentLine1."Delivery Location";//B2BSSD03APR2023
    end;

    procedure ReturnPostingInfo(var IssuedDateTime2: DateTime; var Issueto2: Text[50]; var FromLocation2: Code[20]; var ToLocation2: Code[20]; var Comment2: Text[500])
    var
        IsHandled: Boolean;
    begin
        IssuedDateTime2 := IssuedDateTime;
        Issueto2 := IssuedTo;
        FromLocation2 := FromLocation;
        ToLocation2 := ToLocation;
        Comment2 := Comment;
    end;


}

