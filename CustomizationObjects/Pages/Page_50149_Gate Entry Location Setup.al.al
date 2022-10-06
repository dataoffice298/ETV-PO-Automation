page 50149 "Gate Entry Location Setup"
{
    PageType = List;
    SourceTable = "Gate Entry Location Setup_B2B";
    UsageCategory = Administration;
    ApplicationArea = ALL;
    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = ALL;
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                    ApplicationArea = ALL;
                }
                field("Allow GateEntry Lines Delete"; "Allow GateEntry Lines Delete")
                {
                    ApplicationArea = ALL;
                }

            }
        }
    }

}

