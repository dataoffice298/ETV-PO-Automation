/* page 50189 "CWIP Subform"
{
    PageType = ListPart;
    SourceTable = "CWIP Line";
    MultipleNewLines = true;
    AutoSplitKey = true;
    DelayedInsert = true;
    Caption = 'CWIP Subform';
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
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
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Channel Code field.';
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Depart Code field.';
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field("FA Start Date"; Rec."FA Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FA Start Date field.';
                    Caption = 'FA Start Date';
                    ShowMandatory = true;
                }
                field("FA Posting Group"; Rec."FA Posting Group")
                {
                    ToolTip = 'Specifies the value of the FA Posting Group field.';
                    Caption = 'FA Posting Group';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("FA Depreciation Book"; Rec."FA Depreciation Book")
                {
                    ToolTip = 'Specifies the value of the FA Depreciation Book field.';
                    Caption = 'FA Depreciation Book';
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("FA Class Code"; Rec."FA Class Code")
                {
                    ToolTip = 'Specifies the value of the FA Class Code field.';
                    Caption = 'FA Class Code';
                    ApplicationArea = All;
                }
                field("FA Sub Class Code"; Rec."FA Sub Class Code")
                {
                    ToolTip = 'Specifies the value of the FA Sub Class Code field.';
                    Caption = 'FA Sub Class Code';
                    ApplicationArea = All;
                }
                field("No. of Depreciation Years"; Rec."No. of Depreciation Years")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Depreciation Years field.';
                    Caption = 'No. of Depreciation Years';
                    BlankZero = true;
                    ShowMandatory = true;
                }
                field("Fixed Asset No."; Rec."Fixed Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FA Asset No. field.';
                    Caption = 'Fixed Asset No.';
                }
                field("Fixed Asset Name"; Rec."Fixed Asset Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FA Asset Name field.';
                    Caption = 'Fixed Asset Name';
                }
            }
        }
    }
} */