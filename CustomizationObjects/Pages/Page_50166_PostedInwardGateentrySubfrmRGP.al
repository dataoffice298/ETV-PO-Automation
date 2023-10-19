page 50166 "Posted Inward Gate SubFm-RGP"
{

    Caption = 'Posted RGP-INWARD Subform';
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
                    ApplicationArea = ALL;
                    OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Item,Fixed Asset,Others,Indent,Description';
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
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = ALL;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Posted RGP OUT NO."; Rec."Posted RGP OUT NO.")
                {
                    ApplicationArea = all;
                }
                field("Posted RGP OUT NO. Line"; Rec."Posted RGP OUT NO. Line")
                {
                    ApplicationArea = all;
                }
                //B2BSSD30Dec2022<<
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
                //B2BSSD30Dec2022>>
                field("Purchase Order No."; "Purchase Order No.")
                {
                    ApplicationArea = all;

                }
                field("Purchase Order Line No."; "Purchase Order Line No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}

