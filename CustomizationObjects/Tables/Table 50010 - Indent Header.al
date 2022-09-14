table 50010 "Indent Header"
{
    // version PH1.0,PO1.0

    LookupPageID = 50024;

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchaseSetup.GET;
                    NoSeriesMgt.TestManual(PurchaseSetup."Indent Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; Description; Text[50])
        {


        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(7; "Due Date"; Date)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(8; "Delivery Location"; Code[20])
        {

            trigger OnLookup();
            begin
                IF PAGE.RUNMODAL(0, Location) = ACTION::LookupOK THEN
                    "Delivery Location" := Location.Code;
                IndentLine.SETRANGE("Document No.", "No.");
                IF IndentLine.FIND('-') THEN BEGIN
                    TestStatusOpen;
                    REPEAT
                        IndentLine."Delivery Location" := "Delivery Location";
                        IndentLine.MODIFY;
                    UNTIL IndentLine.NEXT = 0;
                END;
            end;

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(10; Department; Code[20])
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
                //B2BESGOn23May2022++
                IndentLine.SETRANGE("Document No.", "No.");
                IF IndentLine.FIND('-') THEN BEGIN
                    TestStatusOpen;
                    REPEAT
                        IndentLine.Department := Department;
                        IndentLine.MODIFY;
                    UNTIL IndentLine.NEXT = 0;
                END;
                //B2BESGOn23May2022--
            end;
        }
        field(13; "No. Series"; Code[20])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15; Indentor; Text[50])
        {
            Editable = false;
        }
        field(16; Comment; Boolean)
        {
        }
        field(21; "Indent Status"; Option)
        {
            OptionCaption = 'Indent,Enquiry,Offer,Order,Cancel,Close';
            OptionMembers = Indent,Enquiry,Offer,"Order",Cancel,Close;
        }
        field(23; "User Id"; Code[30])
        {
            Editable = false;
        }
        field(24; "Released Status"; Option)
        {
            Editable = false;
            //B2BMSOn12Sep2022>>
            //OptionMembers = Open,Released,Cancel,Close;
            OptionMembers = Open,Released,Cancel,Close,"Pending Approval";
            //B2BMSOn12Sep2022<<
        }
        field(25; "Last Modified Date"; Date)
        {
        }
        field(31; "Sent for Authorization"; Boolean)
        {
            Caption = 'Sent for Authorization';
        }
        field(32; Authorized; Boolean)
        {
            Caption = 'Authorized';
        }
        field(33; Declined; Boolean)
        {
            Caption = 'Declined';
        }
        //B2BPAVOn09Sep2022>>
        field(50001; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));

            trigger OnValidate()
            begin
                IndentLine.Reset();
                IndentLine.SetRange("Document No.", "No.");
                IF IndentLine.FINDSET THEN
                    IndentLine.Modifyall("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
            END;
        }

        field(50002; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
            Blocked = CONST(false));

            trigger OnValidate()
            begin
                IndentLine.Reset();
                IndentLine.SetRange("Document No.", "No.");
                IF IndentLine.FINDSET THEN
                    IndentLine.Modifyall("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");

            END;
        }
        field(50003; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50004; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50005; "In-Transit Code"; Code[10])
        {
            Caption = 'In-Transit Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true));
        }
        //B2BPAVOn09Sep2022<<

        //B2BMSOn13Sep2022>>
        field(50006; "No. of Archived Versions"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Archive Indent Header" where("No." = field("No.")));
        }
        field(50007; "Ammendent Comments"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        //B2BMSOn13Sep2022<<

    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TESTFIELD("Released Status", "Released Status"::Open);
        IndentLine.RESET;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.SETFILTER(IndentLine."Indent Status", '<>%1', IndentLine."Indent Status"::Indent);
        IF IndentLine.FIND('-') THEN
            ERROR(Text008);
        IndentLine.RESET;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.DELETEALL;
    end;

    trigger OnInsert();
    begin
        PurchaseSetup.GET;
        IF "No." = '' THEN BEGIN
            PurchaseSetup.TESTFIELD("Indent Nos.");
            NoSeriesMgt.InitSeries(PurchaseSetup."Indent Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "User Id" := USERID;
        "Document Date" := WORKDATE;
        Indentor := USERID;
        CompSetup.GET;
        "Delivery Location" := CompSetup."Location Code";
    end;



    var
        PurchaseSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PIndent: Record 50010;
        IndentLine: Record 50037;
        Item: Record 27;
        Text000: Label 'The %1 cannot be copied to itself.';
        Text002: Label 'Do you want to release the Indent?';
        Text003: Label 'Do you want to cancel the Indent?';
        Text004: Label 'Indent can not be cancel as it is in process';
        Text005: Label 'Do you want to close the Indent?';
        Text006: Label 'Do you want to reopen the Indent?';
        Text007: Label 'Do you want to open the Indent?';
        CopyDocNo: Code[20];
        Location: Record 14;
        Text008: Label '"You cannot Delete "';
        Employee: Record 5200;
        Job: Record 167;
        CompSetup: Record 79;
        IndentLineRec: Record 50037;
        IndentHeaderRec: Record 50010;
        Text006Lbl: Label 'You do not have permission to edit the MRS Qty-to issue. %1 and %2';
        Text007Lbl: Label '%1 %2 cannot be more than %3 %4.';
        NoworkfloweableErr: Label 'No work flows enabled';
        WorkflowManagement: Codeunit "Workflow Management";


    procedure CreateReturnItemJnlLine();
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlTemp: Record "Item Journal Template";
        TempLocation: Record Location temporary;
        Location: Record Location;
        DocNo: Code[20];
        LineNo: Integer;
        PurchPaySetup: Record "Purchases & Payables Setup";
    begin
        //B2BMSOn13Sep2022>>
        //if not ItemJnlLine.GET('RETURN', "No.") then begin
        //ItemJnlTemp.SETFILTER(Name, 'RETURN');
        //ItemJnlBatch.SETRANGE("Journal Template Name", 'RETURN');
        //ItemJnlBatch.SETRANGE(Name, "No.");
        if ItemJnlTemp.Get(PurchPaySetup."Indent Return Jnl. Template") then;
        ItemJnlTemp.TestField("No. Series");
        DocNo := NoSeriesMgt.GetNextNo(ItemJnlTemp."No. Series", TODAY(), true);
        ItemJnlBatch.Reset();
        ItemJnlBatch.SETRANGE("Journal Template Name", PurchPaySetup."Indent Return Jnl. Template");
        ItemJnlBatch.SETRANGE(Name, PurchPaySetup."Indent Return Jnl. Batch");
        //B2BMSOn13Sep2022<<
        if ItemJnlBatch.ISEMPTY() then begin
            ItemJnlBatch.INIT();
            //B2BMSOn13Sep2022>>
            //ItemJnlBatch."Journal Template Name" := 'RETURN';
            //ItemJnlBatch.Description := 'MRS Return Journal Batch';
            ItemJnlBatch."Journal Template Name" := PurchPaySetup."Indent Return Jnl. Template";
            ItemJnlBatch.Description := PurchaseSetup."Indent Return Jnl. Batch";
            //B2BMSOn13Sep2022<<
            ItemJnlBatch."Reason Code" := ItemJnlTemp."Reason Code";
            ItemJnlBatch.VALIDATE(Name, "No.");
            ItemJnlBatch.INSERT();
        end;
        //Group Locations
        IndentLineRec.RESET();
        IndentLineRec.SETCURRENTKEY("Delivery Location");
        IndentLineRec.SETRANGE(IndentLineRec."Document No.", "No.");
        //    IndentLineRec.SETFILTER("Qty. to Return", '<>%1', 0);
        if IndentLineRec.FIND('-') then
            repeat
                TempLocation.INIT();
                TempLocation.Code := IndentLineRec."Delivery Location";
                if TempLocation.INSERT() then;//PKONJ22.2
            until IndentLineRec.NEXT() = 0;

        //Create Docs according to Location
        TempLocation.RESET();
        if TempLocation.FINDFIRST() then
            repeat
                //Get Location No. Series
                if Location.GET(TempLocation.Code) then;
                //       Location.TESTFIELD("Return Journal Nos.");
                //       DocNo := NoSeriesMgt.GetNextNo(Location."Return Journal Nos.", TODAY(), true);
                LineNo := 0;
                IndentLineRec.SETCURRENTKEY("Delivery Location");
                IndentLineRec.SETRANGE(IndentLineRec."Document No.", "No.");
                IndentLineRec.SETRANGE("Delivery Location", TempLocation.Code);
                //       IndentLineRec.SETFILTER("Qty. to Return", '<>%1', 0);
                if IndentLineRec.FIND('-') then
                    repeat
                        //          IndentLineRec.CALCFIELDS("Quantity Returned Acknowledged");
                        //            if (IndentLineRec."Qty. to Return" + IndentLineRec."Quantity Returned Acknowledged") > MRSLine."Return Quantity" then
                        //               ERROR(Text007Lbl, 'Total Qty to Return', (IndentLineRec."Qty. to Return" + IndentLineRec."Quantity Returned Acknowledged"),
                        //                               IndentLineRec.FIELDCAPTION("Return Quantity"), IndentLineRec."Return Quantity");
                        LineNo += 10000;
                        ItemJnlLine.INIT();
                        ItemJnlLine."Source Code" := ItemJnlTemp."Source Code";
                        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                        ItemJnlLine.VALIDATE("Journal Template Name", PurchPaySetup."Indent Return Jnl. Template");
                        ItemJnlLine.VALIDATE("Gen. Bus. Posting Group", 'RETURN');
                        ItemJnlLine."Line No." := LineNo;
                        ItemJnlLine.VALIDATE("Journal Batch Name", PurchPaySetup."Indent Return Jnl. Batch");
                        //            IF "Manual MRS No." <> '' THEN
                        //                ItemJnlLine."External Document No." := "Manual MRS No." + '\' + "MRS No."
                        //            else
                        //                ItemJnlLine."External Document No." := "MRS No.";
                        //PKONJ11
                        ItemJnlLine.INSERT(true);
                        ItemJnlLine.VALIDATE(ItemJnlLine."Document Type", ItemJnlLine."Document Type"::"Sales Shipment");
                        ItemJnlLine.VALIDATE(ItemJnlLine."Document No.", DocNo);
                        ItemJnlLine.VALIDATE(ItemJnlLine."Posting Date", WORKDATE());
                        ItemJnlLine."Reason Code" := ItemJnlTemp."Reason Code";
                        ItemJnlLine."No." := "No.";
                        ItemJnlLine.VALIDATE(ItemJnlLine."Item No.", IndentLineRec."No.");
                        ItemJnlLine.VALIDATE(ItemJnlLine."Unit of Measure Code", IndentLineRec."Unit of Measure");//PKON22M9
                                                                                                                  //ItemJnlLine.VALIDATE("Gen. Bus. Posting Group", ItemJnlTemp."Gen. Bus. posting group");B2B
                                                                                                                  //            ItemJnlLine.VALIDATE(ItemJnlLine."Shortcut Dimension 1 Code", IndentLineRec."Shortcut Dimension 1 Code");
                                                                                                                  //            ItemJnlLine.VALIDATE(ItemJnlLine."Shortcut Dimension 2 Code", IndentLineRec."Shortcut Dimension 2 Code");
                                                                                                                  //            ItemJnlLine.VALIDATE(ItemJnlLine.Quantity, IndentLineRec."Qty. to Return");
                        ItemJnlLine.VALIDATE("Location Code", IndentLineRec."Delivery Location");
                        ItemJnlLine."Reason Code" := 'ISSUE';
                        //            ItemJnlLine."MRS Ref. No." := "MRS No.";
                        //            B2B
                        ItemJnlLine.MODIFY();
                    //            IndentLineRec."Qty. to Return" := 0;
                    //IndentLineRec.MODIFY();
                    until IndentLineRec.NEXT() = 0;
                //    MESSAGE('The Journal Batch has been successfully created with batch name %1', "MRS No.");
                Message('Item Journals are created successfully.');
            until TempLocation.NEXT() = 0;
        //end else
        //   ERROR(Text006Lbl, FIELDCAPTION("No."), "No."); //B2BMSOn13Sep2022


    end;

    procedure CreateItemJnlLine();
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlTemp: Record "Item Journal Template";
        TempLocation: Record Location temporary;
        Bincontent: Record "Bin Content";
        PurchPaySetup: Record "Purchases & Payables Setup"; //B2BMSOn13Sep2022
        DocNo: Code[20];
        LineNo: Integer;
    begin
        //B2BMSOn13Sep2022>>
        //if not ItemJnlLine.GET('ISSUE', "No.") then begin 
        //ItemJnlTemp.SETFILTER(Name, 'ISSUE');
        PurchPaySetup.Get();
        PurchPaySetup.TestField("Indent Issue Jnl. Batch");
        PurchPaySetup.TestField("Indent Issue Jnl. Template");
        ItemJnlTemp.Reset();
        ItemJnlTemp.SETFILTER(Name, PurchPaySetup."Indent Issue Jnl. Template");
        //B2BMSOn13Sep2022<<
        if ItemJnlTemp.FINDFIRST() then;
        ItemJnlTemp.TESTFIELD("No. Series");
        DocNo := NoSeriesMgt.GetNextNo(ItemJnlTemp."No. Series", TODAY(), true);
        //B2BMSOn13Sep2022>>
        //ItemJnlBatch.SETRANGE("Journal Template Name", 'ISSUE');
        ItemJnlBatch.SETRANGE("Journal Template Name", PurchPaySetup."Indent Issue Jnl. Template");
        //B2BMSOn13Sep2022<<
        ItemJnlBatch.SETRANGE(Name, PurchPaySetup."Indent Issue Jnl. Batch");
        if ItemJnlBatch.ISEMPTY() then begin
            ItemJnlBatch.INIT();
            ItemJnlBatch."Journal Template Name" := PurchPaySetup."Indent Issue Jnl. Template";
            ItemJnlBatch.Description := PurchPaySetup."Indent Issue Jnl. Batch";
            ItemJnlBatch."Reason Code" := 'ISSUE';
            ItemJnlBatch.VALIDATE(Name, "No.");
            ItemJnlBatch.INSERT();
        end;
        //Group Locations
        IndentLineRec.SETCURRENTKEY("Delivery Location");
        IndentLineRec.RESET();
        IndentLineRec.SETRANGE(IndentLineRec."Document No.", "No.");
        //   IndentLineRec.SETFILTER("Qty. to Issue", '<>%1', 0);
        if IndentLineRec.FIND('-') then
            repeat
                TempLocation.INIT();
                TempLocation.Code := IndentLineRec."Delivery Location";
                if TempLocation.INSERT() then;
            until IndentLineRec.NEXT() = 0;

        IndentLineRec.SETCURRENTKEY("Delivery Location");
        IndentLineRec.SETRANGE(IndentLineRec."Document No.", "No.");
        IndentLineRec.SETRANGE("Delivery Location", TempLocation.Code);
        //    IndentLineRec.SETFILTER("Qty. to Issue", '<>%1', 0);
        if IndentLineRec.FIND('-') then
            repeat
                LineNo += 10000;

                ItemJnlLine.INIT();
                ItemJnlLine."Source Code" := ItemJnlTemp."Source Code";
                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
                ItemJnlLine.VALIDATE("Journal Template Name", PurchPaySetup."Indent Issue Jnl. Template");
                ItemJnlLine.VALIDATE("Gen. Bus. Posting Group", 'ISSUE');
                ItemJnlLine.VALIDATE("Journal Batch Name", PurchPaySetup."Indent Issue Jnl. Batch");
                ItemJnlLine.VALIDATE(ItemJnlLine."Document Type", ItemJnlLine."Document Type"::" ");
                ItemJnlLine.VALIDATE(ItemJnlLine."Document No.", DocNo);
                ItemJnlLine.VALIDATE(ItemJnlLine."Posting Date", WORKDATE());
                ItemJnlLine."Reason Code" := ItemJnlTemp."Reason Code";
                //if IndentHeaderRec.GET(IndentLineRec."Document No.") then
                //    ItemJnlLine."No." := IndentHeaderRec."No."; //B2BMSOn13Sep2022
                ItemJnlLine."No." := "No.";
                ItemJnlLine."Line No." := LineNo;
                ItemJnlLine.VALIDATE(ItemJnlLine."Item No.", IndentLineRec."No.");
                ItemJnlLine.VALIDATE(ItemJnlLine."Unit of Measure Code", IndentLineRec."Unit of Measure");//PKON22M9
                ItemJnlLine."Reason Code" := 'ISSUE';
                //    ItemJnlLine.VALIDATE(ItemJnlLine."Shortcut Dimension 1 Code", indentlinerec."Shortcut Dimension 1 Code");
                //    ItemJnlLine.VALIDATE(ItemJnlLine."Shortcut Dimension 2 Code", IndentLineRec."Shortcut Dimension 2 Code");
                //    ItemJnlLine.VALIDATE(ItemJnlLine."Dimension Set ID", IndentLineRec."Dimension Set ID");//B2BPkON06012021
                ItemJnlLine.VALIDATE(ItemJnlLine.Quantity, IndentLineRec."Quantity (Base)");
                ItemJnlLine.VALIDATE("Location Code", IndentLineRec."Delivery Location");
                ItemJnlLine."Variant Code" := IndentLineRec."Variant Code";
                ItemJnlLine."External Document No." := "No.";
                //PKONJ11
                //Fix12Jul2021Cwip>>
                //    ItemJnlLine."CWIP No." := IndentLineRec."CWIPNo.";
                //    ItemJnlLine."Capex No." := IndentLineRec."Capex No.";
                //    ItemJnlLine."Capex Line No." := IndentLineRec."Capex Line No.";
                //Fix12Jul2021Cwip<<
                ItemJnlLine.INSERT(true);
                //   if MRSLine."Bin Code" <> '' then
                //       ItemJnlLine.VALIDATE("Bin Code", IndentLineRec."Bin Code")
                //   else begin
                Bincontent.RESET();
                Bincontent.SETRANGE("Item No.", IndentLineRec."No.");
                Bincontent.SETRANGE("Location Code", IndentLineRec."Delivery Location");
                Bincontent.SETFILTER(Bincontent.Quantity, '<>%1', 0);
                if Bincontent.FINDFIRST() then
                    ItemJnlLine.VALIDATE("Bin Code", Bincontent."Bin Code");
                //    end;
                ItemJnlLine.MODIFY();
            //    IndentLineRec."Qty. to Issue" := 0;
            //IndentLineRec.MODIFY(); //B2BMSOn13Sep2022
            until IndentLineRec.NEXT() = 0;
        //B2BMSOn13Sep2022>>
        //MESSAGE('The Journal Batch has been successfully created with batch name %1', "No.");
        MESSAGE('Item journals are created successfully.');
        //B2BMSOn13Sep2022<<
        //until TempLocation.NEXT = 0;
        //end else
        //    ERROR(Text006Lbl, FIELDCAPTION("No."), "No.");
    end;

    Procedure CheckIndentHeaderApprovalsWorkflowEnabled(var IndentHeader: Record "Indent Header"): Boolean
    begin
        IF not ISIndentHeaderworkflowenabled(IndentHeader) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    procedure ISIndentHeaderworkflowenabled(var IndentHeader: Record "Indent Header"): Boolean
    begin
        if (IndentHeader."Released Status" <> IndentHeader."Released Status"::Open) then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(IndentHeader, RunworkflowOnSendIndentHeaderforApprovalCode()));
    end;

    procedure RunworkflowOnSendIndentHeaderforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendIndentHeaderforApproval'), 1, 128));
    end;

    Procedure OnCancelIndentHeaderForApproval(var IndentHeader: Record "Indent Header")
    begin
    end;



    procedure ReleaseIndent();
    var
        IndentLine: Record 50037;
    begin
        IF NOT CONFIRM(Text002, FALSE) THEN
            EXIT;
        TESTFIELD("Released Status", "Released Status"::Open);
        TESTFIELD(Indentor);
        LOCKTABLE;
        IndentLine.RESET;
        IndentLine.SETRANGE("Document No.", "No.");
        IF IndentLine.FINDSET THEN
            REPEAT
                IF IndentLine.Type <> IndentLine.Type::Description THEN BEGIN
                    IndentLine.TESTFIELD(IndentLine."No.");
                    IndentLine.TESTFIELD(IndentLine."Req.Quantity");
                END;
            UNTIL IndentLine.NEXT = 0;
        IF IndentLine.FINDSET THEN;
        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Released);
        "Released Status" := "Released Status"::Released;
        "Last Modified Date" := WORKDATE;
    end;

    procedure CancelIndent();
    begin
        IF "Released Status" = "Released Status"::Cancel THEN BEGIN //sankar added for cancel
            MESSAGE('Status is Already in Cancel');
            EXIT;
        END;
        IF NOT ("Released Status" = "Released Status"::Open) THEN BEGIN
            MESSAGE('Status Must be Open to Cancel/Close');
            EXIT;
        END;
        IF NOT CONFIRM(Text003, FALSE) THEN
            EXIT;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.SETFILTER("Indent Status", '%1|%2', IndentLine."Indent Status"::Offer, IndentLine."Indent Status"::Order);
        IF IndentLine.FIND('-') THEN
            ERROR(Text004);
        LOCKTABLE;
        IndentLine.SETRANGE("Indent Status");
        IndentLine.MODIFYALL("Indent Status", IndentLine."Indent Status"::Cancel);
        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Cancel);
        "Released Status" := "Released Status"::Cancel;
        "Indent Status" := "Indent Status"::Cancel;
    end;

    procedure CloseIndent();
    begin
        IF "Released Status" = "Released Status"::Close THEN BEGIN //sankar added for close
            MESSAGE('Status is Already in Closed');
            EXIT;
        END;
        IF NOT ("Released Status" = "Released Status"::Open) THEN BEGIN
            MESSAGE('Status Must be open to Cancel/Close');
            EXIT;
        END;

        IF NOT CONFIRM(Text005, FALSE) THEN
            EXIT;
        LOCKTABLE;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.MODIFYALL("Indent Status", IndentLine."Indent Status"::Closed);
        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Closed);
        "Released Status" := "Released Status"::Close;
        "Indent Status" := "Indent Status"::Close;
    end;

    procedure ReopenIndent();
    var
        IndentLine: Record 50037;
        Text000: Label 'Indent Status must be ''Indent'' in the Indent Lines';
        Text007: Label 'Can not Reopen the indent if status is Cancel/Closed.';
    begin
        IF NOT CONFIRM(Text006, FALSE) THEN
            EXIT;
        IF "Released Status" <> "Released Status"::Released THEN
            ERROR(Text007);
        TESTFIELD("Indent Status", "Indent Status"::Indent);
        IndentLine.RESET;
        IndentLine.SETRANGE("Document No.", "No.");
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
        IF IndentLine.FIND('-') THEN BEGIN
            IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Open);
            MODIFY(TRUE);
            "Released Status" := "Released Status"::Open;
            "Last Modified Date" := WORKDATE;
        END ELSE
            MESSAGE(Text000);
    end;

    procedure TestStatusOpen();
    begin
        TESTFIELD("Released Status", "Released Status"::Open);
    end;

    procedure CopyIndent();
    var
        FromIndentLine: Record 50037;
        ToIndentLine: Record 50037;
        IndentHeader: Record 50037;
        ToIndentLine1: Record 50037;
        ToIndentLine2: Record 50037;
    begin
        TESTFIELD("No.");
        TESTFIELD("Released Status", "Released Status"::Open);
        IF PAGE.RUNMODAL(0, IndentHeader) = ACTION::LookupOK THEN BEGIN
            CopyDocNo := IndentHeader."No.";
            IF CopyDocNo = "No." THEN
                ERROR(Text000, TABLECAPTION);

            FromIndentLine.SETRANGE("Document No.", CopyDocNo);
            IF FromIndentLine.FIND('-') THEN
                REPEAT
                    ToIndentLine.INIT;
                    ToIndentLine.TRANSFERFIELDS(FromIndentLine);
                    ToIndentLine2.SETRANGE(ToIndentLine2."Document No.", "No.");
                    IF ToIndentLine2.FIND('-') THEN BEGIN
                        ToIndentLine1.SETRANGE(ToIndentLine1."Document No.", "No.");
                        ToIndentLine1.FIND('+');
                        ToIndentLine."Line No." := ToIndentLine1."Line No." + 10000
                    END ELSE
                        ToIndentLine."Line No." := 10000;
                    ToIndentLine."Document No." := "No.";
                    ToIndentLine."Indent Status" := ToIndentLine."Indent Status"::Indent;
                    ToIndentLine."Release Status" := ToIndentLine."Release Status"::Open;
                    ToIndentLine."Due Date" := WORKDATE;
                    ToIndentLine."Delivery Location" := "Delivery Location";
                    ToIndentLine.INSERT;
                UNTIL FromIndentLine.NEXT = 0;
        END;
    end;

    procedure CreateTransferOrder()
    var
        IndentLine: Record "Indent Line";
        IndentHdr: Record "Indent Header";
        InvSetup: Record "Inventory Setup";
        TransHead: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        DimMgmt: Codeunit DimensionManagement;
        TransferOrderNo: Code[20];
        LastTransferLine: Integer;
    begin

        if not Confirm('Do you want to Generate Transfer Order', true) then
            exit;
        LastTransferLine := 10000;
        InvSetup.Get();
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."No.");
        IndentLine.SetFilter("Req.Quantity", '<>%1', 0);
        if IndentLine.FindSet() then begin
            repeat
                if TransferOrderNo = '' then begin
                    TransHead.Init();
                    TransHead."No." := '';
                    TransHead.Insert(true);
                    TransHead.Validate("Transfer-from Code", "Transfer-from Code");
                    TransHead.Validate("Transfer-to Code", "Transfer-to Code");
                    TransHead.Validate("Posting Date", WorkDate());

                    TransHead.Modify(true);
                    TransferOrderNo := TransHead."No.";
                end;

                TransLine.Init();
                TransLine.Validate("Document No.", TransferOrderNo);
                TransLine.Validate("Line No.", LastTransferLine);
                TransLine.Validate("Item No.", IndentLine."No.");
                //TransLine.Validate("Transfer-from Bin Code", IndentLine."Transfer From BinCode");
                TransLine.Validate(Quantity, IndentLine."Req.Quantity");
                TransLine.Insert(true);
                LastTransferLine += 10000;
                IndentLine."Transfer Order No." := TransferOrderNo;

                IndentLine.Modify(true);
            until IndentLine.Next() = 0;
            Message('Transfer Order %1 Generated', TransferOrderNo);
        end else
            Error('Noting to transfer');
    end;

    //B2BMSOn13Sep2022>>
    procedure AssistEdit(OldIndentHdr: Record "Indent Header"): Boolean;
    var
        IndentHdr: Record "Indent Header";
    begin
        IndentHdr := Rec;
        PurchaseSetup.GET;
        PurchaseSetup.TESTFIELD("Indent Req No.");
        IF NoSeriesMgt.SelectSeries(PurchaseSetup."Indent Req No.", OldIndentHdr."No.", IndentHdr."No.") THEN BEGIN
            PurchaseSetup.GET;
            PurchaseSetup.TESTFIELD("Indent Req No.");
            NoSeriesMgt.SetSeries(IndentHdr."No.");
            Rec := IndentHdr;
            EXIT(TRUE);
        END;
    end;
}


