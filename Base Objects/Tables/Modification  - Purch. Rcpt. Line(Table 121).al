tableextension 50052 tableextension70000003 extends "Purch. Rcpt. Line"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,B2BQC1.00.00,PO

    fields
    {

        //Unsupported feature: Deletion on ""KK Cess%"(Field 16542)". Please convert manually.


        //Unsupported feature: Deletion on ""KK Cess Amount"(Field 16543)". Please convert manually.
        field(50100; "Applies-to Cons. Entry No."; Integer)
        {
        }
        field(50101; "Free Item Type"; Option)
        {
            Description = 'B2B1.0 13Dec2016';
            OptionCaption = '" ,Same Item,Different Item"';
            OptionMembers = " ","Same Item","Different Item";
        }
        field(50102; "Free Item No."; Code[20])
        {
            Description = 'B2B1.0 13Dec2016';
            TableRelation = Item;
        }
        field(50103; "Free Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Free Unit of Measure Code',
                        ENN = 'Unit of Measure Code';
            Description = 'B2B1.0 13Dec2016';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Free Item No."));
        }
        field(50104; "Free Quantity"; Decimal)
        {
            CaptionML = ENU = 'Free Quantity',
                        ENN = 'Minimum Quantity';
            Description = 'B2B1.0 13Dec2016';
            MinValue = 0;
        }
        field(50105; "Parent Line No."; Integer)
        {
            Description = 'B2B1.0 13Dec2016';
            Editable = false;
        }
        field(50049; "Free Doc Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Enquiry';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Enquiry;
        }
        field(50050; "Free Doc No."; Code[20])
        {
        }
        field(50051; "Free Line No."; Integer)
        {
        }
        field(50052; Free; Boolean)
        {
            Description = 'B2B1.0 13Dec2016';
            Editable = false;
        }
        field(50053; "Approved Vendor"; Boolean)
        {
            Description = 'B2B1.0 05 Dec2016';
        }
        field(50054; "Agreement No."; Code[20])
        {
            Description = 'B2B1.0 06 Dec2016';
        }

        field(60003; "Indent Due Date"; Date)
        {
            Description = 'B2B1.0';
        }
        field(60004; "Indent Reference"; Text[50])
        {
            Description = 'B2B1.0';
        }
        field(60005; "Revision No."; Code[10])
        {
            Description = 'B2B1.0';
        }
        field(60006; "Production Order"; Code[20])
        {
            Description = 'B2B1.0';
            Editable = false;
            TableRelation = "Production Order"."No." WHERE(Status = CONST(Released));
        }
        field(60007; "Production Order Line No."; Integer)
        {
            Description = 'B2B1.0';
            Editable = false;
        }
        field(60008; "Drawing No."; Code[20])
        {
            Description = 'B2B1.0';
            Editable = false;
            TableRelation = Item;
        }
        field(60009; "Sub Operation No."; Code[20])
        {
            Description = 'B2B1.0';
            Editable = false;
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE("Prod. Order No." = FIELD("Production Order"),
                                                                              "Routing Reference No." = FIELD("Production Order Line No."),
                                                                              "Routing No." = FIELD("Routing No."));
        }
        field(60010; "Sub Routing No."; Code[20])
        {
            Description = 'B2B1.0';
            Editable = false;
            Enabled = false;
            TableRelation = "Routing Line"."Routing No.";
        }
        //B2BVCOn03Oct22>>>
        field(60011; "Ref. Posted Gate Entry"; Code[20])
        {
            TableRelation = "Posted Gate Entry Line_B2B"."Source No." where("Source No." = field("Document No."));
        }
        //B2BVCOn03Oct22<<<
        field(33002900; "Indent No."; Code[20])
        {
            Description = 'B2B1.0';
        }
        field(33002901; "Indent Line No."; Integer)
        {
            Description = 'B2B1.0';
        }

        field(33002902; "Quotation No."; Code[20])
        {
            Description = 'PO1.0';

        }
        field(33002903; "Delivery Rating"; Decimal)
        {
            Description = 'PO1.0';
        }
        field(33002904; "Indent Req No"; Code[20])
        {
            Description = 'PO1.0';
            Editable = false;
        }
        field(33002905; "Indent Req Line No"; Integer)
        {
            Description = 'PO1.0';
            Editable = false;
        }
        field(60018; "Sub Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(60019; "Rejection Comments B2B"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(60020; Make_B2B; Text[250])
        {
            Caption = 'Make';
            DataClassification = CustomerContent;
        }
        field(60021; "Model No."; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(60022; "Serial No."; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(60024; "Spec Id"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(33002906; "Indentor Description"; Code[100])//B2BSSD07Feb2023
        {
            DataClassification = CustomerContent;
        }
        field(60025; warranty; Code[50])//B2BSSD10Feb2023
        {
            DataClassification = CustomerContent;
        }
        field(60050; "Posted Gate Entry No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(60051; "Posted Gate Entry Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(60061; CWIP; Boolean)
        {
            Caption = 'CWIP';
            DataClassification = CustomerContent;
            Editable = false;
        }

        modify("Variant Code")  //B2BKM29APR2024
        {
            trigger OnAfterValidate()
            var
                ItemVariant: Record "Item Variant";
                Item: Record Item;
            begin
                if "Variant Code" <> '' then begin
                    if ItemVariant.Get("No.", "Variant Code") then
                        "Variant Description" := ItemVariant.Description;
                    if "No." <> '' then begin
                        if Item.get("No.") then
                            Description := Item.Description;
                    end;
                end else
                    "Variant Description" := '';
            end;
        }
        field(60052; "Variant Description"; Text[100]) //B2BKM29APR2024
        {
            Caption = 'Variant Description';
            DataClassification = CustomerContent;
            Editable = false;

        }

    }
    keys
    {
        /*
        key(Key1;"Indent No.","Indent Line No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key2;Type,"Buy-from Vendor No.","No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key3;"Buy-from Vendor No.","No.",Type)
        {
            SumIndexFields = Quantity,"Delivery Rating";
        }*///Balu
    }

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        //"--B2BQC1.00.00--" : ;
        Text33000250: Label 'Sum of the Quantity Accepted and Rejected should not be more than Receipt Quantity.';
}

