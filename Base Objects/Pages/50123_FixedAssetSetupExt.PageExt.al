pageextension 50182 "Fixed Asset Setup Ext" extends "Fixed Asset Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(CWIP)
            {
                Caption = 'CWIP';
                field("CWIP Nos."; Rec."CWIP Nos.")
                {
                    ToolTip = 'Specifies the value of the CWIP Nos. field.';
                    ApplicationArea = All;
                    Caption = 'CWIP Nos.';
                }
                field("CWIP FA Jnl. Tem. Name"; Rec."CWIP FA Jnl. Tem. Name")
                {
                    ToolTip = 'Specifies the value of the CWIP FA Jnl. Tem. Name field.';
                    ApplicationArea = All;
                    Caption = 'CWIP FA Jnl. Tem. Name';
                }
                field("CWIP FA Jnl. Batch Name"; Rec."CWIP FA Jnl. Batch Name")
                {
                    ToolTip = 'Specifies the value of the CWIP FA Jnl. Batch Name field.';
                    ApplicationArea = All;
                    Caption = 'CWIP FA Jnl. Batch Name';
                }
                field("CWIP G/L Account No."; Rec."CWIP G/L Account No.")
                {
                    ToolTip = 'Specifies the value of the CWIP G/L Account No. field.';
                    ApplicationArea = All;
                    Caption = 'CWIP G/L Account No.';
                }
                field("CWIP Item Jnl. Tem. Name"; Rec."CWIP Item Jnl. Tem. Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CWIP Item Jnl. Tem. Name field.';
                }
                field("CWIP Item Jnl. Batch Name"; Rec."CWIP Item Jnl. Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CWIP Item Jnl. Batch Name field.';
                }
            }
        }
    }
}