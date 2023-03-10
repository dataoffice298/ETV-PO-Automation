page 50164 "Posted Outward Gate SubFm-RGP"
{
    Caption = 'Posted RGP-OUTWARD Subform';
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = all;
                }
                //Balu 05212021>>
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
                //Balu 05212021<<

                //B2BSSD27Dec2022<<
                field(Variant; Rec.Variant)
                {
                    ApplicationArea = All;
                }
                field(ModelNo; Rec.ModelNo)
                {
                    ApplicationArea = All;
                }
                field(SerialNo; Rec.SerialNo)
                {
                    ApplicationArea = All;
                }
                //B2BSSD27Dec2022>>
            }
        }
    }
}

