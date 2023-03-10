page 50153 "Posted Outward Gate SubFm-NRGP"
{
    Caption = 'Posted NRGP-OUTWARD Subform';
    AutoSplitKey = true;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Posted Gate Entry Line_B2B";
    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = all;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = ALL;
                }
                field("Source Name"; Rec."Source Name")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                //B2BSSD30Dec2022<<
                field(Variant; Variant)
                {
                    ApplicationArea = All;
                }
                field(ModelNo; ModelNo)
                {
                    ApplicationArea = All;
                }
                field(SerialNo; SerialNo)
                {
                    ApplicationArea = All;
                }
                //B2BSSD30Dec2022>>
            }
        }
    }
}

