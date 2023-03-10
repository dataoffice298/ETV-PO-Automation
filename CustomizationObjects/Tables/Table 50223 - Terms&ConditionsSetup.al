table 50223 "Terms&ConditionSetUp"
{
    DataClassification = CustomerContent;
    Caption = 'Terms & Condition SetUp';

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line Type"; Option)
        {
            OptionMembers = ,Unloading,"Installation/configuration",Rates,GST,"Packing & Forwarding",Transportation,"AMC Period","Billing & Installation Address","Billing & Delivery Address","Billing Address","Contract Period","Contract Value",Completion,"Completion Timelines","Delivery & Completion",Delivery,"Delivery Address","Delivery & Installation","Liquidated Damages",Maintenance,"ManPower Requirement","Nature Of Work",Others,Payment,Packing,"Payment Terms","Shifting Date","Shipping Address","Support Period",Taxes,"Terms & Conditions","Total AMC Value Yearly","Total Contract Value",Warranty,"Delivery Address2","Event Date","Courier Charges";
            OptionCaption = 'Unloading,Installation/configuration,Rates,GST,Packing & Forwarding,Transportation,AMC Period,Billing & Installation Address,Billing & Delivery Address,Billing Address,Contract Period,Contract Value,Completion,Completion Timelines,Delivery & Completion,Delivery,Delivery Address,Delivery & Installation,Liquidated Damages,Maintenance,ManPower Requirement,Nature Of Work,Others,Payment,Packing,Payment Terms,Shifting Date,Shipping Address,Support Period,Taxes,Terms & Conditions,Total AMC Value Yearly,Total Contract Value,Warranty,Delivery Address2,Event Date,Courier Charges';
        }
        field(3; Description; Text[500])
        {

        }
        field(5; Sequence; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Pk; "Line No.")
        {
            Clustered = true;
        }
    }

    var
        TermsConditionSetup: Record "Terms&ConditionSetUp";

    trigger OnInsert()
    begin
        TermsConditionSetup.Reset();
        if TermsConditionSetup.FindLast() then
            "Line No." := TermsConditionSetup."Line No." + 1
        else
            "Line No." := 1;
    end;
}