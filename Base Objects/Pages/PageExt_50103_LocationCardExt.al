pageextension 50103 LocationExt_B2B extends "Location Card"
{
    layout
    {
        addafter(General)
        {
            group("Numbering")
            {
                field("Inward Gate Entry Nos.NRGP_B2B"; Rec."Inward Gate Entry Nos.NRGP_B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inward Gate Entry Nos.NRGP_B2B field.';
                }
                field("Inward Gate Entry Nos.-RGP_B2B"; Rec."Inward Gate Entry Nos.-RGP_B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inward Gate Entry Nos.-RGP_B2B field.';
                }
                field("Inward NRGP No. Series_B2B"; Rec."Inward NRGP No. Series_B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inward NRGP No. Series_B2B field.';
                }
                field("Inward RGP No. Series_B2B"; Rec."Inward RGP No. Series_B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Inward RGP No. Series_B2B field.';
                }
                field("Outward Gate Entry Nos.RGP_B2B"; Rec."Outward Gate Entry Nos.RGP_B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outward Gate Entry Nos.RGP_B2B field.';
                }
                field("Outward Gate EntryNos.NRGP_B2B"; Rec."Outward Gate EntryNos.NRGP_B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outward Gate EntryNos.NRGP_B2B field.';
                }
                field("Outward NRGP No. Series_B2B"; Rec."Outward NRGP No. Series_B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outward NRGP No. Series_B2B field.';
                }
                field("Outward RGP No. Series_B2B"; Rec."Outward RGP No. Series_B2B")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outward RGP No. Series_B2B field.';
                }
                field("Address 3"; Rec."Address 3")//B2BSSD25Jan2023
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}