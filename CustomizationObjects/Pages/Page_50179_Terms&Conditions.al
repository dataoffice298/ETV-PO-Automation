page 50179 "Terms and Condition"
{

    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = ListPart;
    SourceTable = "PO Terms And Conditions";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    SourceTableView = WHERE(Type = filter("Terms & Conditions"));

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(LineType; rec.LineType)
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        TechSpecOpt.Reset();
                        TechSpecOpt.SetRange(Type, TechSpecOpt.Type::"Terms & Conditions");
                        if TechSpecOpt.FindSet() then
                            if Page.RunModal(Page::TechnicalSpecificationOpList, TechSpecOpt) = Action::LookupOK then begin
                                Rec.Validate(LineType, TechSpecOpt.Code);
                                Rec.Validate(Description, TechSpecOpt.Description);
                                Rec.Validate(Type, TechSpecOpt.Type);
                                Rec.Validate("SNo.", TechSpecOpt."SNo.");
                            end;

                    end;
                }
                /*field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }*/
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    //Editable = false;
                }
                field(Type; Rec.Type) //B2BVCOn30Aug2024
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                /* field("SNo."; Rec."SNo.")
                {
                    ApplicationArea = All;
                    Editable = false;
                } */
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
        TechSpecOpt: Record TechnicalSpecOption;
}