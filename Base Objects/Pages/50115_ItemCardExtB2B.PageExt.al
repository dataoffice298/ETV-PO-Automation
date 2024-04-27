pageextension 50115 ItemCardExtB2B extends "Item Card"
{
    //B2BMSOn04Nov2022
    layout
    {
        addlast(Item)
        {
            group(QC)
            {
                Caption = 'QC';
                field("QC Enabled B2B"; Rec."QC Enabled B2B")
                {
                    ApplicationArea = all;
                }
            }

            field("CWIP "; Rec."CWIP")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the CWIP  field.';
                Caption = 'CWIP ';
            }
        }
        modify("Item Category Code")
        {
            Editable = FieldEditable; //B2BVCOn14Nov2023
        }

    }

    actions
    {
        // Add changes to page actions here
    }
    //B2BVCOn14Nov2023 >>
    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup.Stores then
                FieldEditable := true
            else
                FieldEditable := false;
        end;

    end;
    //B2BVCOn14Nov2023 <<

    var
        UserSetup: Record "User Setup";
        FieldEditable: Boolean;
}