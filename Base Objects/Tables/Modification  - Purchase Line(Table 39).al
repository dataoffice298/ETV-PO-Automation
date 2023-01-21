
tableextension 50056 tableextension70000011 extends "Purchase Line" //39
{
    fields
    {
        field(50101; "Free Item Type"; Option)
        {
            Description = 'B2B1.0 13Dec2016';
            OptionCaption = '" ,Same Item,Different Item"';
            OptionMembers = " ","Same Item","Different Item";
        }
        field(50102; "Free Item No."; Code[20])
        {
            Description = 'B2B1.0 12Dec2016';
            TableRelation = Item;

            trigger OnValidate();
            var
                EmptyItemTypeErr: Label '"You must select %1 before selecting %2. "';
                SameItemTypeErr: Label 'Free Item No. must be %1 for %2. Current value is : %3.';
                DiffItemTypeErr: Label 'Free Item No. must not be %1 for %2. Current value is : %3.';
            begin

            end;
        }
        field(50103; "Free Unit of Measure Code"; Code[10])
        {
            CaptionML = ENU = 'Free Unit of Measure Code',
                        ENN = 'Unit of Measure Code';
            Description = 'B2B1.0 12Dec2016';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Free Item No."));
        }

        field(50104; "Free Quantity"; Decimal)
        {
            CaptionML = ENU = 'Free Quantity',
                        ENN = 'Minimum Quantity';
            Description = 'B2B1.0 12Dec2016';
            MinValue = 0;

            trigger OnValidate();
            begin

            end;
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
            Editable = false;
        }
        field(50053; "Approved Vendor"; Boolean)
        {
            Description = 'B2B1.0';
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
        field(60008; "Drawing No.-Old"; Code[20])
        {
            Description = 'B2B1.0';
            Editable = false;
            Enabled = false;
            TableRelation = Item;
        }
        field(60009; "Sub Operation No."; Code[20])
        {
            Description = 'B2B1.0';
            Editable = false;
            Enabled = false;
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
            TableRelation = "Posted Gate Entry Line_B2B"."Gate Entry No." where("Source No." = field("Document No."));

            trigger OnValidate()
            var
                PurchRcptLine: Record "Purch. Rcpt. Line";
                RGPErr: Label 'This gate entry is already used for GRN No. %1.';
            begin
                PurchRcptLine.Reset();
                PurchRcptLine.SetRange("Order No.", "Document No.");
                PurchRcptLine.SetRange("Order Line No.", "Line No.");
                if PurchRcptLine.FindSet() then
                    repeat
                        if PurchRcptLine."Ref. Posted Gate Entry" = "Ref. Posted Gate Entry" then
                            Error(RGPErr, PurchRcptLine."Document No.");
                    until PurchRcptLine.Next() = 0;
            end;
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

        //B2BMSOn03Nov2022>>
        field(60012; "Qty. to Accept B2B"; Decimal)
        {
            Caption = 'Qty. to Accept';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Qty. to Accept B2B" <> 0 then
                    CheckTracking(Rec);
                if ("Qty. to Accept B2B" + "Quantity Accepted B2B") > Quantity then
                    Error(Err0001);
                if "Qty. to Accept B2B" <> 0 then
                    Validate("Qty. to Receive", "Qty. to Accept B2B");
            end;
        }
        field(60013; "Qty. to Reject B2B"; Decimal)
        {
            Caption = 'Qty. to Reject';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                RejErr: Label 'You cannot reject the quantity as total quantity is received.';
            begin
                if "Qty. to Reject B2B" <> 0 then
                    CheckTracking(Rec);
                if Quantity = "Quantity Received" then
                    Error(RejErr);
                if ("Qty. to Reject B2B" + "Quantity Rejected B2B") > Quantity then
                    Error(Err0002);
            end;
        }
        field(60014; "Quantity Accepted B2B"; Decimal)
        {
            Editable = false;
            Caption = 'Quantity Accepted';
            DataClassification = CustomerContent;
        }
        field(60015; "Quantity Rejected B2B"; Decimal)
        {
            Editable = false;
            Caption = 'Quantity Rejected';
            DataClassification = CustomerContent;
        }
        field(60016; "QC Enabled B2B"; Boolean)
        {
            Editable = false;
            Caption = 'QC Enabled';
            DataClassification = CustomerContent;
        }
        field(60017; Select; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Select';
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                ItemLRec: Record Item;
                FALRec: Record "Fixed Asset";
            begin
                if ItemLRec.Get("No.") then
                    Rec."QC Enabled B2B" := ItemLRec."QC Enabled B2B";
                if Rec.Type = Rec.Type::"Fixed Asset" then
                    if FALRec.Get(Rec."No.") then
                        Rec.Make_B2B := FALRec.Make_B2B;
            end;
        }

        field(60018; "Sub Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        //B2BMSOn03Nov2022<<
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

    }



    var
        PurchasesPayablesSetup: Record 312;
        IndentLine: Record "Indent Line";
        FreePurchLine: Record 39;
        QCSetupRead: Boolean;
        Text33000250: Label 'Should be 0.';
        Text33000251: Label 'You can not create Inspection Data Sheets when Warehouse Receipt line exists.';
        PurchaseLineLRec: Record 39;
        PurchaseLnGRec: Record 39;
        Err0001: Label 'The Qty. to Accept must not be greater than Quantity.';
        Err0002: Label 'The Qty. to Reject must not be greater than Quantity.';
        ReservationEntry: Record "Reservation Entry";

    procedure CheckTracking(PurchLine: Record "Purchase Line")
    var
        TrackErr: Label 'You must assign a serial number for item %1.';
        ItemLRec: Record Item;
        ReservEntry: Record "Reservation Entry";
        ReservEntry1: Record "Reservation Entry";
        TrackErr1: Label 'Item tracking lines are defined more than the Qty. to Receive.';
    begin
        if (ItemLRec.Get(PurchLine."No.")) and (ItemLRec."Item Tracking Code" <> '') then begin
            ReservEntry.Reset();
            ReservEntry.SetRange("Item No.", PurchLine."No.");
            ReservEntry.SetRange("Source Type", 39);
            ReservEntry.SetRange("Source Subtype", 1);
            ReservEntry.SetRange("Location Code", PurchLine."Location Code");
            ReservEntry.SetRange("Source ID", PurchLine."Document No.");
            ReservEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SetRange(Positive, true);
            if not ReservEntry.Findset() then
                Error(TrackErr, PurchLine."No.")
            else begin
                ReservEntry1.copy(ReservEntry);
                ReservEntry1.CalcSums(Quantity);
                if ReservEntry1.Quantity > PurchLine."Qty. to Receive" then
                    Error(TrackErr1);
            end;
        end;
    end;
}

