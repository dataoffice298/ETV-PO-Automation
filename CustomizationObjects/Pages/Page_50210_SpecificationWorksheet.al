page 50210 "Specification Worksheet"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Specification Worksheet";
    DelayedInsert = true;
    SaveValues = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }
            }
            repeater(control)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean

                    begin
                        PurchHeader.Reset();
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Quote);
                        PurchHeader.SetRange("RFQ No.", Rec.Code);
                        if PurchHeader.FindSet() then
                            if Page.RunModal(Page::"Purchase Quotes", PurchHeader) = Action::LookupOK then
                                Rec.Validate("Vendor No.", PurchHeader."Buy-from Vendor No.");
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PurchHeader1.Reset();
                        PurchHeader1.SetRange("Document Type", PurchHeader1."Document Type"::Quote);
                        PurchHeader1.SetRange("RFQ No.", Rec.Code);
                        PurchHeader1.SetRange("Buy-from Vendor No.", Rec."Vendor No.");
                        if PurchHeader1.FindFirst() then begin
                            PurchLine.Reset();
                            PurchLine.SetRange("Document Type",PurchHeader1."Document Type");
                            PurchLine.SetRange("Document No.", PurchHeader1."No.");
                            if PurchLine.FindSet() then
                                if Page.RunModal(Page::"Purchase Quote Subform", PurchLine) = Action::LookupOK then
                                    Rec.Validate("Item No.", PurchLine."No.");
                        end;
                    end;
                }
                field("Spec ID"; Rec."Spec ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
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
        RFQNo: Code[20];
        PurchHeader: Record "Purchase Header";
        PurchHeader1: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
}