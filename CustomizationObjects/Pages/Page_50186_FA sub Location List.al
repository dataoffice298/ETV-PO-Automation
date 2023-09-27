page 50186 "FA Sub Locations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FA Sub Location";
    Caption = 'FA Sub Locations';
    DelayedInsert = true;

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
                field("Location Name"; Rec."Location Name")
                {
                    ApplicationArea = All;
                    Caption = 'Location Description';
                }
                field("Sub Location Code"; Rec."Sub Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'Sub Location Code';
                }
                field("Sub Location Name"; Rec."Sub Location Name")
                {
                    ApplicationArea = All;
                    Caption = 'sub Loctaion Description';
                }
            }
        }
    } 
}