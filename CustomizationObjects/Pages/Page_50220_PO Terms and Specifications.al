page 50220 "PO Terms and Specifications"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = ListPart;
    SourceTable = "PO Terms And Conditions";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    SourceTableView = WHERE(Type = filter(Specifications));
    Caption = 'PO Terms and Specifications';

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
                        TechSpecOpt.SetRange(Type, TechSpecOpt.Type::Specifications);
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
                    Caption = 'Priority';
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