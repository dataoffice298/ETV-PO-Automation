page 75466 "Objects Used"
{
    PageType = List;
    ApplicationArea = All;
    Editable = false;
    Caption = 'Objects Used';
    SourceTable = 2000000207;
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            repeater(contol1)
            {
                field("User AL Code"; "User AL Code")
                {

                    ApplicationArea = All;
                }
                field(SystemCreatedAt; SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field("User Code"; "User Code")
                {
                    ApplicationArea = All;
                }
                field("User Code Hash"; "User Code Hash")
                {
                    ApplicationArea = All;
                }
                field("Object Flags"; "Object Flags")
                {
                    ApplicationArea = All;
                }
                field("Metadata Format"; "Metadata Format")
                {
                    ApplicationArea = all;
                }
                field("Metadata Hash"; "Metadata Hash")
                {
                    ApplicationArea = All;
                }
                field(SystemId; SystemId)
                {
                    ApplicationArea = All;
                }
                field("Object ID"; "Object ID")
                {
                    ApplicationArea = All;
                }
                field("Package ID"; "Package ID")
                {
                    ApplicationArea = All;
                }
                Field("Runtime Package ID"; "Runtime Package ID")
                {
                    ApplicationArea = all;
                }
                field(Metadata; Metadata)
                {

                }
                field("Metadata Version"; "Metadata Version")
                {
                    ApplicationArea = All;
                }
                field("Object Name"; "Object Name")
                {
                    ApplicationArea = All;
                }
                field("Object Subtype"; "Object Subtype")
                {
                    ApplicationArea = All;
                }
                field("Object Type"; "Object Type")
                {
                    ApplicationArea = all;
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