codeunit 50022 UserWiseSecuritySetup
{
    trigger OnRun()
    begin

    end;

    procedure GetLocationWiseUser(UserID: code[50]; Type: Integer): Text
    var
        LocationWiseUser: Record "Location Wise User";
        LocationText: Text;
    begin
        LocationWiseUser.Reset();
        LocationWiseUser.SetRange("User ID", UserId);
        if Type = 1 then
            LocationWiseUser.SetRange(Indent, true);
        if Type = 2 then
            LocationWiseUser.SetRange(RGPInward, true);
        if Type = 3 then
            LocationWiseUser.SetRange(RGPOutward, true);
        if Type = 4 then
            LocationWiseUser.SetRange(NRGPOutward, true);
        if Type = 5 then
            LocationWiseUser.SetRange("Transfer Indent Header", true);
        if Type = 6 then
            LocationWiseUser.SetRange("Transfer Order", true);

        if LocationWiseUser.FindSet() then begin
            repeat
                LocationText += LocationWiseUser."Location Code" + '|';
            until LocationWiseUser.Next() = 0;
            LocationText := CopyStr(LocationText, 1, StrLen(LocationText) - 1);
            exit(LocationText);
        end else
            Error('No Location user found');
    end;

    procedure CheckUserLocation(UserID: Code[50]; LocationCode: Code[20]; TypeP: integer): Boolean
    var
        LocationWiseUser: Record "Location Wise User";
        LocationText: Text;
    begin
        LocationWiseUser.Reset();
        LocationWiseUser.SetRange("Location Code", LocationCode);
        LocationWiseUser.SetRange("User ID", UserId);
        if TypeP = 1 then
            LocationWiseUser.SetRange("Transfer Indent Header", true)
        else
            if TypeP = 2 then
                LocationWiseUser.SetRange(RGPInward, true)
            else
                if TypeP = 3 then
                    LocationWiseUser.SetRange(RGPOutward, true)
                else
                    if TypeP = 4 then
                        LocationWiseUser.SetRange(NRGPOutward, true)
                    else
                        if TypeP = 5 then
                            LocationWiseUser.SetRange(Indent, true)
                        else
                            if TypeP = 6 then
                                LocationWiseUser.SetRange("Transfer Order", true);
        if LocationWiseUser.FindFirst() then
            exit(true)
        else
            exit(false);
    end;
}