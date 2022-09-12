page 50024 "Indent List"
{
    // version PH1.0,PO1.0

    CardPageID = "Indent Header";
    Editable = false;
    PageType = List;
    SourceTable = "Indent Header";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field("Document Date"; rec."Document Date")
                {
                    ApplicationArea = all;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = all;
                }
                field(Indentor; rec.Indentor)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        /*
                        CASE "Document Type" OF
                          "Document Type"::Quote:
                            PAGE.RUN(PAGE::"Sales Quote",Rec);
                          "Document Type"::Order:
                            PAGE.RUN(PAGE::"Sales Order",Rec);
                          "Document Type"::Invoice:
                            IF NOT "Service Mgt. Document" THEN
                              PAGE.RUN(PAGE::"Sales Invoice",Rec)
                            ELSE
                              PAGE.RUN(PAGE::"Sales Invoice (Service)",Rec);
                          "Document Type"::"Return Order":
                            PAGE.RUN(PAGE::"Sales Return Order",Rec);
                          "Document Type"::"Credit Memo":
                            IF NOT "Service Mgt. Document" THEN
                              PAGE.RUN(PAGE::"Sales Credit Memo",Rec)
                            ELSE
                              PAGE.RUN(PAGE::"Sales Credit Memo (Service)",Rec);
                          "Document Type"::"Blanket Order":
                            PAGE.RUN(PAGE::"Blanket Sales Order",Rec);
                           //B2B Reach
                          "Document Type"::Enquiry:
                            PAGE.RUN(PAGE::"Sales Enquiry",Rec);
                        
                        END;
                         */
                        PAGE.RUN(PAGE::"Indent Header", Rec);

                    end;
                }
            }
        }
    }
}

