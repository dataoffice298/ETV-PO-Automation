page 50204 QuoteSpecifications
{
    //B2BVCOn07Aug2024
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = QuoteSpecifications;
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    Caption = 'Quote Specifications';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Editable = false;

                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    Editable = false;
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                    Caption = 'Product Name';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = All;
                    Caption = 'Units';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Price';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
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
    trigger OnAfterGetCurrRecord()
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."Item No.") then begin
            Rec."Product Name" := Item.Description;
            Rec.Modify();
        end;
    end;
}