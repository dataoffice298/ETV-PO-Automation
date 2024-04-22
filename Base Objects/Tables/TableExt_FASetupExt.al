tableextension 50251 "FA Setup Ext" extends "FA Setup"
{
    fields
    {
        field(50001; "CWIP FA Jnl. Tem. Name"; Code[10])
        {
            Caption = 'CWIP FA Jnl. Tem. Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Template";
        }

        field(50002; "CWIP FA Jnl. Batch Name"; Code[10])
        {
            Caption = 'CWIP FA Jnl. Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("CWIP FA Jnl. Tem. Name"));
        }
        field(50003; "CWIP G/L Account No."; Code[20])
        {
            TableRelation = "G/L Account" where(Blocked = const(false));
        }
        field(50004; "CWIP Item Jnl. Tem. Name"; Code[10])
        {
            Caption = 'CWIP Item Jnl. Tem. Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Template";
        }
        field(50005; "CWIP Item Jnl. Batch Name"; Code[10])
        {
            Caption = 'CWIP Item Jnl. Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = field("CWIP Item Jnl. Tem. Name"));
        }
        field(50006; "CWIP Nos."; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'CWIP Nos.';
        }
    }
}