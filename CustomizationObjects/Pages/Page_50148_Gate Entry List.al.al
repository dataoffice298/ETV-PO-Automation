page 50148 "Gate Entry List"
{
    Caption = 'Inward/Outward List';
    PageType = List;
    SourceTable = "Gate Entry Header_B2B";
    UsageCategory = Lists;
    ApplicationArea = ALL;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = ALL;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = ALL;
                }
                field("Document Time"; Rec."Document Time")
                {
                    ApplicationArea = ALL;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }          
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Card)
            {
                ApplicationArea = All;
                Image = Card;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if (Rec."Entry Type" = Rec."Entry Type"::Inward) and (Rec.Type = Rec.Type::RGP) then
                        Page.Run(Page::"Inward Gate Entry-RGP", Rec)
                    else
                        if (Rec."Entry Type" = Rec."Entry Type"::Inward) and (Rec.Type = Rec.Type::NRGP) then
                            Page.Run(Page::"Inward Gate Entry-NRGP", Rec)
                        else
                            if (Rec."Entry Type" = Rec."Entry Type"::Outward) and (Rec.Type = Rec.Type::RGP) then
                                Page.Run(Page::"Outward Gate Entry - RGP", Rec)
                            else
                                if (Rec."Entry Type" = Rec."Entry Type"::Outward) and (Rec.Type = Rec.Type::NRGP) then
                                    Page.Run(Page::"Outward Gate Entry - NRGP", Rec);
                end;
            }
        }
    }
}

