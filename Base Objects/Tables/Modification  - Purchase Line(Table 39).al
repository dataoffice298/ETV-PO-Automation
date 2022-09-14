
tableextension 50056 tableextension70000011 extends "Purchase Line"
{
    // version NAVW19.00.00.45778,NAVIN9.00.00.45778,B2BQC1.00.00,PO

    fields
    {



        //Unsupported feature: CodeModification on ""No."(Field 6).OnValidate". Please convert manually.

        //trigger "(Field 6)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;
        TESTFIELD("Qty. Rcd. Not Invoiced",0);
        TESTFIELD("Quantity Received",0);
        #4..130
                "Posting Group" := Item."Inventory Posting Group";
              END;
              Description := Item.Description;
              "Description 2" := Item."Description 2";
              "Unit Price (LCY)" := Item."Unit Price";
              "Units per Parcel" := Item."Units per Parcel";
        #137..217

        IF Type <> Type::" " THEN BEGIN
          Quantity := xRec.Quantity;
          VALIDATE("Unit of Measure Code");
          IF Quantity <> 0 THEN BEGIN
            InitOutstanding;
        #224..265
          END;
        END;
        "Assessable Value" := Item."Assessable Value" * "Qty. per Unit of Measure" ;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..133

              // Start  B2BQC1.00.00 - 01
              //Insert the spec Id of the item into the purchase line when the Item is selected
              UpdateQualityPurchLines;
              // Stop   B2BQC1.00.00 - 01

        #134..220
          //PO >>
           "Indent Req No":=xRec."Indent Req No";
           "Indent Req No":=xRec."Indent Req No";
          //PO <<
        #221..268
        */
        //end;


        //Unsupported feature: CodeModification on "Quantity(Field 15).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;

        IF "Drop Shipment" AND ("Document Type" <> "Document Type"::Invoice) THEN
        #4..68
          "Amount Including VAT" := 0;
          "VAT Base Amount" := 0;
        END;
        IF (xRec.Quantity <> Quantity) AND (Quantity = 0) AND (("Amount To Vendor" <> 0) OR IsServiceTaxExist(Rec)) THEN BEGIN
          ClearServiceTaxAmounts;
          "Amount To Vendor" := 0;
          "Service Tax Base" := 0;
        #76..88
        TaxAreaUpdate;

        CheckWMS;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..71
        IF (xRec.Quantity <> Quantity) AND (Quantity = 0) AND
           (("Amount To Vendor" <> 0) OR ("Bal. TDS Including SHE CESS" <> 0) OR ("Service Tax Amount" <> 0) OR ("Service Tax SBC Amount" <> 0))
        THEN BEGIN
        #73..91
        */
        //end;


        //Unsupported feature: CodeModification on ""Job Task No."(Field 1001).OnValidate". Please convert manually.

        //trigger "(Field 1001)();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD("Receipt No.",'');

        IF "Job Task No." <> xRec."Job Task No." THEN BEGIN
        #4..9
          CLEAR(JobJnlLine);
          "Job Line Type" := "Job Line Type"::" ";
          UpdateJobPrices;
          CreateDim(
            DimMgt.TypeToTableID3(Type),"No.",
            DATABASE::Job,"Job No.",
            DATABASE::"Responsibility Center","Responsibility Center",
            DATABASE::"Work Center","Work Center No.");
          EXIT;
        END;

        #21..23
          UpdateJobPrices;
        END;
        UpdateDimensionsFromJobTask;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..12
        #18..26
        */
        //end;


        //Unsupported feature: CodeModification on ""Variant Code"(Field 5402).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "Variant Code" <> '' THEN
          TESTFIELD(Type,Type::Item);
        TestStatusOpen;
        #4..32
          CreateTempJobJnlLine(TRUE);
          UpdateJobPrices;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..35
        CreateFreePurchLine(Rec);
        */
        //end;


        //Unsupported feature: CodeModification on ""Amount Including Tax"(Field 13702).OnValidate". Please convert manually.

        //trigger OnValidate();
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TESTFIELD(Type);
        TESTFIELD(Quantity);
        TESTFIELD("Direct Unit Cost");
        #4..11
              Currency."Amount Rounding Precision");
          Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
          "Amount To Vendor" := "Line Amount" -"Inv. Discount Amount" + "Tax Amount" -
            "Bal. TDS Including SHE CESS"  + "Charges To Vendor" + FullServiceTaxAmount + FullServiceTaxSBCAmount +
            KKCessAmount;
          IF NOT (CVD AND GetCVDPayableToThirdParty(Rec)) THEN
            "Amount To Vendor" += "Excise Amount";
          "Amount To Vendor" := ROUND("Amount To Vendor");
        #20..22

        InitOutstandingAmount;
        UpdateUnitCost;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..14
            "Bal. TDS Including SHE CESS"  + "Charges To Vendor" + FullServiceTaxAmount + FullServiceTaxSBCAmount;
        #17..25
        */
        //end;

        //Unsupported feature: Deletion on ""KK Cess%"(Field 16542)". Please convert manually.


        //Unsupported feature: Deletion on ""KK Cess Amount"(Field 16543)". Please convert manually.


        //Unsupported feature: Deletion on ""KK Cess Amount (Intm)"(Field 16544)". Please convert manually.

        field(50100; "Applies-to Cons. Entry No."; Integer)
        {
        }
        /*
        field(50001; "Free Item Type"; Option)
        {
            Description = 'B2B1.0 12Dec2016';
            OptionCaption = '" ,Same Item,Different Item"';
            OptionMembers = " ","Same Item","Different Item";

            trigger OnValidate();
            begin
                //B2B1.0 13Dec2016>>
                IF NOT Free THEN
                    CASE "Free Item Type" OF
                        "Free Item Type"::" ":
                            BEGIN
                                "Free Item No." := '';
                                "Free Unit of Measure Code" := '';
                                "Free Quantity" := 0;
                                DeleteFreePurchLines(Rec);
                            END;
                        "Free Item Type"::"Same Item":
                            BEGIN
                                "Free Item No." := "No.";
                                "Free Unit of Measure Code" := "Unit of Measure Code";
                            END;
                        "Free Item Type"::"Different Item":
                            BEGIN
                                DeleteFreePurchLines(Rec);
                            END;
                    END;
                //B2B1.0 13Dec2016<<
            end;
        }*///Balu
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
                //B2B1.0 13Dec2016>>
                /*IF NOT Free THEN
                    IF "Free Item No." <> '' THEN
                        CASE "Free Item Type" OF
                            "Free Item Type"::" ":
                                ERROR(EmptyItemTypeErr, FIELDCAPTION("Free Item Type"), FIELDCAPTION("Free Item No."));
                            "Free Item Type"::"Same Item":
                                IF "Free Item No." <> "No." THEN
                                    ERROR(SameItemTypeErr, "No.", "Free Item Type", "Free Item No.");
                            "Free Item Type"::"Different Item":
                                IF "Free Item No." = "No." THEN
                                    ERROR(DiffItemTypeErr, "No.", "Free Item Type", "Free Item No.");
                        END;*///Balu
                //B2B1.0 13Dec2016<<
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
                /*
                //B2B1.0 13Dec2016>>
                //DeleteFreePurchLines(Rec);
                IF NOT Free THEN
                    IF "Free Quantity" <> 0 THEN
                        CreateFreePurchLine(Rec);
                //B2B1.0 13Dec2016<<*///Balu
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
        field(60001; "Indent No."; Code[20])
        {
            Description = 'B2B1.0';
        }
        field(60002; "Indent Line No."; Integer)
        {
            Description = 'B2B1.0';
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
        /*
        field(33000250; "Spec ID"; Code[20])
        {
            Caption = 'Spec ID';
            TableRelation = "Specification Header";
        }
        field(33000251; "Quantity Accepted"; Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry".Quantity WHERE(Order No.=FIELD(Document No.),
                                                                     Order Line No.=FIELD(Line No.),
                                                                     Entry Type=FILTER(Accepted)));
            Caption = 'Quantity Accepted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000252;"Quantity Rework";Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry"."Remaining Quantity" WHERE (Order No.=FIELD(Document No.),
                                                                                 Order Line No.=FIELD(Line No.),
                                                                                 Entry Type=FILTER(Rework),
                                                                                 Open=CONST(Yes)));
            Caption = 'Quantity Rework';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000253;"QC Enabled";Boolean)
        {
            Caption = 'QC Enabled';

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Satisfy the field condition

                TestStatusOpen;
                TESTFIELD(Type,Type :: Item);
                IF "QC Enabled" THEN
                  TESTFIELD("Spec ID");
                IF NOT "QC Enabled" THEN
                  IF "Quality Before Receipt" THEN
                    VALIDATE("Quality Before Receipt",FALSE);
                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000254;"Quantity Rejected";Decimal)
        {
            CalcFormula = Sum("Quality Ledger Entry".Quantity WHERE (Order No.=FIELD(Document No.),
                                                                     Order Line No.=FIELD(Line No.),
                                                                     Entry Type=FILTER(Reject)));
            Caption = 'Quantity Rejected';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33000255;"Quality Before Receipt";Boolean)
        {
            Caption = 'Quality Before Receipt';

            trigger OnValidate();
            begin
                // Start  B2BQC1.00.00 - 01
                //Satisfy the field condition

                TestStatusOpen;
                TESTFIELD(Type,Type :: Item);
                IF "Quantity Received" <> 0 THEN
                  FIELDERROR("Quantity Received",Text33000250);
                IF "Qty. Sent to Quality" <> 0 THEN
                  FIELDERROR("Qty. Sent to Quality",Text33000250);
                "Qty. Sending to Quality" := 0;
                IF "Quality Before Receipt" THEN BEGIN
                  GetQCSetup;
                  QualityCtrlSetup.TESTFIELD("Quality Before Receipt",TRUE);
                  TESTFIELD("QC Enabled",TRUE);
                END;
                // Stop   B2BQC1.00.00 - 01
            end;
        }
        field(33000256;"Qty. Sending to Quality";Decimal)
        {
            Caption = 'Qty. Sending to Quality';
            MinValue = 0;
        }
        field(33000257;"Qty. Sent to Quality";Decimal)
        {
            Caption = 'Qty. Sent to Quality';
            Editable = false;
        }
        field(33000258;"Qty. Sending to Quality(R)";Decimal)
        {
            Caption = 'Qty. Sending to Quality(R)';
            MinValue = 0;
        }
        field(33000259;"Spec Version";Code[20])
        {
            Caption = 'Spec Version';
            TableRelation = "Specification Version"."Version Code" WHERE (Specification No.=FIELD(Spec ID));
        }
        field(33002902;"Quotation No.";Code[20])
        {
            Description = 'PO1.0';
        }*///Balu
        /*
        field(33002904; "Indent Req No"; Code[20])
        {
            Description = 'PO1.0';
            Editable = false;
        }
        field(33002905; "Indent Req Line No"; Integer)
        {
            Description = 'PO1.0';
            Editable = false;
        }*///Balu
    }
    keys
    {
        /*
        key(Key1; "Order Date", "Document Type", "Document No.", "No.")
        {
        }
        key(Key2; "Document Type", "Indent No.", "Indent Line No.")
        {
            SumIndexFields = Quantity;
        }*///Balu
    }


    //Unsupported feature: CodeInsertion on "OnDelete". Please convert manually.

    //trigger (Variable: IndentLine)();
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: CodeModification on "OnDelete". Please convert manually.

    //trigger OnDelete();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TestStatusOpen;
    IF NOT StatusCheckSuspended AND (PurchHeader.Status = PurchHeader.Status::Released) AND
       (Type IN [Type::"G/L Account",Type::"Charge (Item)"])
    THEN
    #5..94
    DefermentBuffer.SETRANGE("Line No.","Line No.");
    DefermentBuffer.DELETEALL;

    DetailTaxEntryBuffer.RESET;
    DetailTaxEntryBuffer.SETRANGE("Document No.","Document No.");
    DetailTaxEntryBuffer.SETRANGE("Line No.","Line No.");
    DetailTaxEntryBuffer.SETRANGE("Transaction Type",DetailTaxEntryBuffer."Transaction Type"::Purchase);
    DetailTaxEntryBuffer.DELETEALL;

    IF ("Line No." <> 0) AND ("Attached to Line No." = 0) THEN BEGIN
      PurchLine2.COPY(Rec);
      IF PurchLine2.FIND('<>') THEN BEGIN
        PurchLine2.VALIDATE("Recalculate Invoice Disc.",TRUE);
        PurchLine2.MODIFY;
      END;
    #110..112
      DeferralUtilities.DeferralCodeOnDelete(
        DeferralUtilities.GetPurchDeferralDocType,'','',
        "Document Type","Document No.","Line No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //TESTFIELD(Free,FALSE);// CZ1.0//CbyPh
    TestStatusOpen;
    DeleteFreePurchLines(Rec);//B2B1.0 13Dec2016
    ClearFreeItemDetails(Rec);//B2B1.0 19 Dec2016
    #2..97

    // CZ1.0 >>//CbyPh
    {
    PurchaseLineLRec.RESET;
    PurchaseLineLRec.SETRANGE("Document Type","Free Doc Type");
    PurchaseLineLRec.SETRANGE("Document No.","Free Doc No.");
    PurchaseLineLRec.SETRANGE("Line No.","Free Line No.");
    PurchaseLineLRec.DELETEALL;
    }
    // CZ1.0 <<

    #98..104
      PurchLine2.RESET;
      PurchLine2.SETRANGE("Document Type","Document Type");
      PurchLine2.SETRANGE("Document No.","Document No.");
      PurchLine2.SETFILTER("Line No.",'<>%1',"Line No.");
      IF PurchLine2.FINDFIRST THEN BEGIN
    #107..115

    //Begin>>PO1.0
    IndentLine.RESET;
    IndentLine.SETRANGE("Document No.","Indent No.");
    IndentLine.SETRANGE("Line No.","Indent Line No.");
    IF IndentLine.FINDFIRST THEN BEGIN
      IndentLine."Indent Status":=IndentLine."Indent Status"::Indent;
      IndentLine.MODIFY;
    END;
    //End<<PO1.0
    */
    //end;


    //Unsupported feature: CodeModification on "OnModify". Please convert manually.

    //trigger OnModify();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF ("Document Type" = "Document Type"::"Blanket Order") AND
       ((Type <> xRec.Type) OR ("No." <> xRec."No."))
    THEN BEGIN
    #4..18
    IF PurchHeader.Subcontracting AND (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) THEN
      IF xRec.Quantity <> Quantity THEN
        ERROR(Text16322);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //TESTFIELD(Free,FALSE);// CZ1.0//CbyPh
    #1..21
    {
    //B2B1.0 16Dec2016>>
    IF NOT Free THEN
      IF NOT CheckPurchPriceExists(Rec) THEN
        DeleteFreePurchLines(Rec)
      ELSE IF "Free Quantity" <> 0 THEN
        CreateFreePurchLine(Rec);
    //B2B1.0 16Dec2016<<
    }
    */
    //end;

    //Unsupported feature: InsertAfter on "Documentation". Please convert manually.


    //Unsupported feature: PropertyChange. Please convert manually.


    var
        PurchasesPayablesSetup: Record 312;

    var
        IndentLine: Record "Indent Line";
        "--B2B1.0 13Dec2016--": Integer;
        FreePurchLine: Record 39;

    var
        "-B2BQC1.00.00-": Integer;
        //QualityCtrlSetup: Record 33000257;//Balu
        QCSetupRead: Boolean;
        //"--B2BQC1.00.00--": ;
        Text33000250: Label 'Should be 0.';
        Text33000251: Label 'You can not create Inspection Data Sheets when Warehouse Receipt line exists.';
        PurchaseLineLRec: Record 39;
        PurchaseLnGRec: Record 39;

}

