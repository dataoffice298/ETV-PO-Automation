table 50228 "FA Sub Location"
{
    DataClassification = CustomerContent;
    LookupPageId = "FA Sub Locations";

    fields
    {
        field(1; "Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
            TableRelation = "FA Location";
            trigger OnValidate()
            var
                FaLocation: Record "FA Location";
            begin
                if FaLocation.Get("Location Code") then
                    "Location Name" := FaLocation.Name;
            end;
        }
        field(2; "Location Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Location description';
        }
        field(3; "Sub Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Location Code';
        }
        field(4; "Sub Location Name"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Sub Location description';
        }
    }

    keys
    {
        key(PK; "Location Code", "Sub Location Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Sub Location Code", "Sub Location Name")
        { }
    }
}