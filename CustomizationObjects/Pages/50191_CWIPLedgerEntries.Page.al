page 50191 "CWIP Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'CWIP Ledger Entries';
    PageType = List;
    SourceTable = "CWIP Ledger Entry";
    UsageCategory = History;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Entry';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    Caption = 'Posting Date';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                    Caption = 'Item No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Description';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                    Caption = 'Vendor No.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                    Caption = 'Vendor Name';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order No. field.';
                    Caption = 'Order No.';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Line No. field.';
                    Caption = 'Order Line No.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    Caption = 'Global Dimension 1 Code';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    Caption = 'Global Dimension 2 Code';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                    Caption = 'Location Code';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    Caption = 'Quantity';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                    Caption = 'Amount';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Caption = 'Entry No.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Open field.';
                    Caption = 'Open';
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Make field.';
                    Caption = 'Make';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Model field.';
                    Caption = 'Model';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No. field.';
                    Caption = 'Serial No.';
                }
                field("CWIP No."; Rec."CWIP No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CWIP No. field.';
                    Caption = 'CWIP No.';
                }
                field("CWIP Line No."; Rec."CWIP Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CWIP Line No. field.';
                    Caption = 'CWIP Line No.';
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                    Caption = 'Receipt No.';
                    ApplicationArea = All;
                }
                field("Receipt Line No."; Rec."Receipt Line No.")
                {
                    ToolTip = 'Specifies the value of the Receipt Line No. field.';
                    Caption = 'Receipt Line No.';
                    ApplicationArea = All;
                }
                field("FA Acquired"; Rec."FA Acquired")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FA Acquired field.';
                    Caption = 'FA Acquired';
                }
                field("FA No."; Rec."FA No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FA No. field.';
                    Caption = 'FA No.';
                }
                field("FA Name"; Rec."FA Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FA Name field.';
                    Caption = 'FA Name';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }
        }
    }
}
