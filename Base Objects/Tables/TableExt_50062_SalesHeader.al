tableextension 50062 SalesHeaderExt extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnBeforeValidate()
            var
                myInt: Integer;
                CUST: Record Customer;
            begin
                if CUST.Get(rec."Sell-to Customer No.") then
                    if CUST."Approval Status" <> CUST."Approval Status"::Released then
                        Error('Customer Approval Status must be Released');
            end;
        }
        field(50100; "LC No."; Code[20])
        {
            Caption = 'LC No.';
            TableRelation = "LC Details"."No." WHERE("Transaction Type" = CONST(Sale), "Issued To/Received From" = FIELD("Bill-to Customer No."), Closed = CONST(false), Released = CONST(true));
            trigger OnValidate()
            var
                LCDetail: Record "LC Details";
                Text13700: Label 'The LC which you have selected is Foreign type you cannot utilise for this order.';
            begin
                IF "LC No." <> '' THEN BEGIN
                    LCDetail.GET("LC No.");
                    IF LCDetail."Type of LC" = LCDetail."Type of LC"::Foreign THEN
                        IF "Currency Code" = '' THEN
                            ERROR(Text13700);
                END;
            end;
        }
    }

    var
        myInt: Integer;
}