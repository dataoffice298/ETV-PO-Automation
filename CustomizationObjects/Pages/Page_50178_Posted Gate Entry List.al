page 50178 "Posted Gate Entries List"
{
    Caption = 'Posted Inward/Outward Entries';
    UsageCategory = Lists;
    ApplicationArea = ALL;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Posted Gate Entry Header_B2B";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                Editable = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = ALL;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = ALL;
                }
                field("Gate Entry No."; Rec."Gate Entry No.")
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
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
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
                        Page.Run(Page::"Posted Inward Gate Entry-RGP", Rec)
                    else
                        if (Rec."Entry Type" = Rec."Entry Type"::Inward) and (Rec.Type = Rec.Type::NRGP) then
                            Page.Run(Page::"Posted Inward Gate Entry-NRGP", Rec)
                        else
                            if (Rec."Entry Type" = Rec."Entry Type"::Outward) and (Rec.Type = Rec.Type::RGP) then
                                Page.Run(Page::"Posted Outward Gate Entry-RGP", Rec)
                            else
                                if (Rec."Entry Type" = Rec."Entry Type"::Outward) and (Rec.Type = Rec.Type::NRGP) then
                                    Page.Run(Page::"Posted Outward Gate Entry-NRGP", Rec);
                end;
            }
        }
    }
}

