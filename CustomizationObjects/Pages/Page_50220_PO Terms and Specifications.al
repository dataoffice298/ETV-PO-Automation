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
                        if TechSpecOpt.FindSet() then begin
                            Clear(TechSpecOptList);
                            TechSpecOptList.LookupMode(true);
                            TechSpecOptList.SetTableView(TechSpecOpt);
                            if TechSpecOptList.RunModal() = Action::LookupOK then begin
                                TechSpecOptList.SetSelectionFilter(TechSpecOpt);
                                if TechSpecOpt.FindSet() then begin
                                    repeat
                                        POTermsCond.Reset();
                                        POTermsCond.SetRange(DocumentNo, Rec.DocumentNo);
                                        POTermsCond.SetRange(DocumentType, Rec.DocumentType);
                                        if POTermsCond.FindLast() then
                                            LineNoVar := POTermsCond.LineNo + 10000
                                        else
                                            LineNoVar := 10000;
                                        POTermsConditions.Init();
                                        POTermsConditions.DocumentNo := Rec.DocumentNo;
                                        POTermsConditions.DocumentType := Rec.DocumentType;
                                        POTermsConditions.Type := Rec.Type;
                                        POTermsConditions.LineType := TechSpecOpt.Code;
                                        POTermsConditions.Description := TechSpecOpt.Description;
                                        POTermsConditions.LineNo := LineNoVar;
                                        POTermsConditions.Type := TechSpecOpt.Type;
                                        POTermsConditions."SNo." := TechSpecOpt."SNo.";
                                        POTermsConditions.Insert(true);
                                    until TechSpecOpt.Next = 0;
                                end;
                            end;

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
        TechSpecOptList: Page TechnicalSpecificationOpList;
        POTermsConditions: Record "PO Terms And Conditions";
        POTermsCond: Record "PO Terms And Conditions";
        LineNoVar: Integer;
}