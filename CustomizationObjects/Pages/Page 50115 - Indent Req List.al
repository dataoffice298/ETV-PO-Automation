page 50115 "Indent Req List"
{
    // version PO1.0

    CardPageID = "Indent Req Header";
    Editable = false;
    PageType = List;
    SourceTable = "Indent Req Header";
    //UsageCategory = Lists;
    //ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Resposibility Center"; Rec."Resposibility Center")
                {
                    ApplicationArea = All;
                }
                
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("L&ine")
            {
                Caption = 'L&ine';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    //RunObject = Page 50148;//Balu
                    RunPageOnRec = true;
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;
                }
            }
        }
    }
}

