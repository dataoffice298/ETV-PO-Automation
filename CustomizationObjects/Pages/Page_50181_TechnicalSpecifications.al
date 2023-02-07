page 50181 TechnicalSpecifications
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Technical Specifications";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    Caption = 'Technical Specifications';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    Editable = false;

                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
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
                field(Make; Rec.Make)
                {
                    ApplicationArea = All;
                    Caption = 'Make';
                }
                field("CAT No."; Rec."CAT No.")
                {
                    ApplicationArea = All;
                    Caption = 'CAT No.';
                }
                /*field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }*/
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
        IsEditable: Boolean;
}