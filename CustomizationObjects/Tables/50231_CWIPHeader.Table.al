
table 50231 "CWIP Header"

{
    Caption = 'CWIP Header';
    DataClassification = CustomerContent;
    LookupPageId = "CWIP List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    FASetup.Get();
                    NoSeriesMgt.TestManual(FASetup."CWIP Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor where(Blocked = filter(" " | Payment));

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get("Vendor No.") then
                    "Vendor Name" := Vendor.Name
                else
                    "Vendor Name" := '';
            end;
        }
        field(4; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(5; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'No. Series';
        }
        field(6; "Created By"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
            Editable = false;
            Caption = 'Created By';
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(9; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDocDim();
            end;

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(10; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Released;
            OptionCaption = 'Open,Pending Approval,Released';
            Caption = 'Status';
        }
        field(11; Posted; Boolean)
        {

        }
        field(12; "Item No."; Code[20])
        {
            TableRelation = Item;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("Item No.") then
                    "Item Name" := Item.Description;
            end;
        }
        field(13; "Item Name"; Text[100])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            FASetup.Get();
            FASetup.TestField("CWIP Nos.");
            NoSeriesMgt.InitSeries(FASetup."CWIP Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        "Posting Date" := WorkDate();
        "Created By" := UserId;
    end;

    trigger OnDelete()
    begin
        if PreventDeletingLines() then
            Error(DelErrLbl);
    end;

    var
        FASetup: Record "FA Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DelErrLbl: Label 'Document cannot be deleted due to the lines have been processed.';

    procedure AssistEdit(OldCWIPHeader: Record "CWIP Header"): Boolean
    var
        CWIPHeader: Record "CWIP Header";
    begin
        CWIPHeader := Rec;
        FASetup.Get();
        FASetup.TestField("CWIP Nos.");
        if NoSeriesMgt.SelectSeries(FASetup."CWIP Nos.", OldCWIPHeader."No. Series", CWIPHeader."No. Series") then begin
            NoSeriesMgt.SetSeries(CWIPHeader."No.");
            Rec := CWIPHeader;
            exit(true);
        end;
    end;

    procedure ShowDocDim()
    var
        DimMgt: Codeunit DimensionManagement;
        OldDimSetID: Integer;
    begin

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            Rec, "Dimension Set ID", StrSubstNo('%1', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");


        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if CWIPLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure CWIPLinesExist(): Boolean
    var
        CWIPLine: Record "CWIP Line";
    begin
        CWIPLine.Reset();
        //CWIPLine.ReadIsolation := IsolationLevel::ReadUncommitted;
        CWIPLine.SetRange("Document No.", "No.");
        exit(not CWIPLine.IsEmpty);
    end;

    local procedure PreventDeletingLines(): Boolean
    var
        CWIPLine: Record "CWIP Line";
    begin
        CWIPLine.Reset();
        CWIPLine.SetRange("Document No.", "No.");
        CWIPLine.SetFilter("Fixed Asset No.", '<>%1', '');
        if CWIPLine.FindFirst() then
            exit(true);
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        CWIPLine: Record "CWIP Line";
        ConfirmManagement: Codeunit "Confirm Management";
        DimMgt: Codeunit DimensionManagement;
        NewDimSetID: Integer;
        Text051Lbl: Label 'You may have changed a dimension.\\Do you want to update the lines?';
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not ConfirmManagement.GetResponseOrDefault(Text051Lbl, true) then
            exit;

        CWIPLine.Reset();
        CWIPLine.SetRange("Document No.", "No.");
        CWIPLine.LockTable();
        if CWIPLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(CWIPLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if CWIPLine."Dimension Set ID" <> NewDimSetID then begin
                    CWIPLine."Dimension Set ID" := NewDimSetID;

                    DimMgt.UpdateGlobalDimFromDimSetID(
                      CWIPLine."Dimension Set ID", CWIPLine."Shortcut Dimension 1 Code", CWIPLine."Shortcut Dimension 2 Code");
                    CWIPLine.Modify();
                end;
            until CWIPLine.Next() = 0;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
        OldDimSetID: Integer;
    begin

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify();

        if OldDimSetID <> "Dimension Set ID" then
            if not IsNullGuid(Rec.SystemId) then
                Modify();
    end;

    procedure GetLedgerEntries()
    var
        CWIPLedgerEntry: Record "CWIP Ledger Entry";
        CWIPLedgerEntries: Page "CWIP Ledger Entries";
        LineNo: Integer;
        PrevVendorNo: Code[20];
        MultipleVendors: Boolean;
        ErrLbl: Label 'No open line are found against to the selected vendor.';
        Err2Lbl: Label 'Vendor or Item must be selected.';
    begin
        if ("Vendor No." = '') and ("Item No." = '') then
            Error(Err2Lbl);
        CWIPLedgerEntry.Reset();
        if "Vendor No." <> '' then
            CWIPLedgerEntry.SetRange("Vendor No.", "Vendor No.");
        if "Item No." <> '' then
            CWIPLedgerEntry.SetRange("Item No.", "Item No.");
        CWIPLedgerEntry.SetRange(Open, true);
        if CWIPLedgerEntry.FindSet() then begin
            Clear(CWIPLedgerEntries);
            CWIPLedgerEntries.LookupMode(true);
            CWIPLedgerEntries.SetTableView(CWIPLedgerEntry);
            if CWIPLedgerEntries.RunModal() = Action::LookupOK then begin
                Clear(CWIPLedgerEntry);
                CWIPLedgerEntry.SetCurrentKey("Vendor No.");
                CWIPLedgerEntries.SetSelectionFilter(CWIPLedgerEntry);
                if CWIPLedgerEntry.FindSet() then begin
                    LineNo := 10000;
                    Clear(MultipleVendors);
                    PrevVendorNo := CWIPLedgerEntry."Vendor No.";
                    repeat
                        InsertCWIPLineFromLedgers(CWIPLedgerEntry, LineNo);
                        LineNo += 10000;

                        if PrevVendorNo <> CWIPLedgerEntry."Vendor No." then
                            MultipleVendors := true;
                    until CWIPLedgerEntry.Next() = 0;
                    if not MultipleVendors then
                        Validate("Vendor No.", PrevVendorNo);
                end;
            end;
        end else
            Error(ErrLbl);
    end;


    local procedure InsertCWIPLineFromLedgers(CWIPLedgerEntry: Record "CWIP Ledger Entry"; LineNo: Integer)
    var
        CWIPLine: Record "CWIP Line";
    begin
        CWIPLine.Init();
        CWIPLine."Document No." := "No.";
        CWIPLine."Line No." := LineNo;
        CWIPLine."Posting Date" := CWIPLedgerEntry."Posting Date";
        CWIPLine."CWIP Entry No." := CWIPLedgerEntry."Entry No.";
        CWIPLine."Order No." := CWIPLedgerEntry."Order No.";
        CWIPLine."Order Line No." := CWIPLedgerEntry."Order Line No.";
        CWIPLine."Receipt No." := CWIPLedgerEntry."Receipt No.";
        CWIPLine."Receipt Line No." := CWIPLedgerEntry."Receipt Line No.";
        CWIPLine.Make := CWIPLedgerEntry.Make;
        CWIPLine.Model := CWIPLedgerEntry.Model;
        CWIPLine."Serial No." := CWIPLedgerEntry."Serial No.";
        CWIPLine."Vendor No." := CWIPLedgerEntry."Vendor No.";
        CWIPLine."Vendor Name" := CWIPLedgerEntry."Vendor Name";
        CWIPLine."Item No." := CWIPLedgerEntry."Item No.";
        CWIPLine.Description := CWIPLedgerEntry.Description;
        CWIPLine.Quantity := CWIPLedgerEntry.Quantity;
        CWIPLine.Amount := CWIPLedgerEntry.Amount;
        CWIPLine."Location Code" := CWIPLedgerEntry."Location Code";
        CWIPLine.Insert(true);
        CWIPLine.Validate("Shortcut Dimension 1 Code", CWIPLedgerEntry."Global Dimension 1 Code");
        CWIPLine.Validate("Shortcut Dimension 2 Code", CWIPLedgerEntry."Global Dimension 2 Code");
        CWIPLine.Modify();

        UpdateCWIPLedgerEntry(CWIPLedgerEntry, CWIPLine);
    end;

    local procedure UpdateCWIPLedgerEntry(CWIPLedgerEntry: Record "CWIP Ledger Entry"; CWIPLine: Record "CWIP Line")
    var
        CWIPLedgEntry: Record "CWIP Ledger Entry";
    begin
        if CWIPLedgEntry.Get(CWIPLedgerEntry."Entry No.") then begin
            CWIPLedgEntry."CWIP No." := CWIPLine."Document No.";
            CWIPLedgEntry."CWIP Line No." := CWIPLine."Line No.";
            CWIPLedgEntry.Modify();
        end;
    end;

    procedure ReOpenDocument()
    var
        ReleaseTxt: Label 'Do you want to reopen the Document?';
        SucessTxt: Label 'Document has been re-opened successfully.';
    begin
        if not CONFIRM(ReleaseTxt, false) then
            exit;
        TestField(Status, Status::Released);
        Status := Rec.Status::Open;
        Modify(true);
        Message(SucessTxt);
    end;

    procedure ReleaseDocument()
    var
        ApprovalMgmt: Codeunit CWIP;
        ReleaseTxt: Label 'Do you want to release the Document?';
        NoWorkflowEnabledErr: Label 'This document can only be released when the approval process is complete.';
        SucessTxt: Label 'Document has been released successfully.';
        ErrTxt: Label 'Atleast one CWIP must be selected.';
        CWIPLine: Record "CWIP Line";
    begin
        if ApprovalMgmt.IsCheckCWIPworkflowenabled(Rec) then
            Error(NoWorkflowEnabledErr);
        if not CONFIRM(ReleaseTxt, false) then
            exit;
        CWIPLine.Reset();
        CWIPLine.SetRange("Document No.", "No.");
        CWIPLine.SetRange(Select, true);
        if not CWIPLine.FindFirst() then
            Error(ErrTxt);
        TestField(Status, Status::Open);
        Status := Status::Released;
        Modify(true);
        Message(SucessTxt);
    end;

    procedure CreateFixedAssetsFromLines()
    var
        FixedAsset: Record "Fixed Asset";
        FADepreciationBook: Record "FA Depreciation Book";
        CWIPLine: Record "CWIP Line";
        Window: Dialog;
        SuccessTxt: Label 'Fixed Assets created successfully.';
        ExecuteTxt: Label 'Do you want to create fixed assets?';
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if not CONFIRM(ExecuteTxt, false) then
            exit;
        CheckFACreationValidations();
        CWIPLine.Reset();
        CWIPLine.SetRange("Document No.", "No.");
        CWIPLine.SetRange(Select, true);
        if CWIPLine.FindSet() then begin
            Window.Open('Processing Lines...');
            repeat
                FixedAsset.Init();
                FixedAsset."No." := NoSeriesMgt.GetNextNo(CWIPLine."FA No. Series", WorkDate(), true);
                FixedAsset.Insert(true);
                FixedAsset.Description := CopyStr(CWIPLine.Description, 1, MaxStrLen(FixedAsset.Description));
                FixedAsset.Validate("FA Class Code", CWIPLine."FA Class Code");
                FixedAsset.Validate("FA Subclass Code", CWIPLine."FA Sub Class Code");
                FixedAsset.Validate("FA Posting Group", CWIPLine."FA Posting Group");
                FixedAsset.Validate(Make_B2B, CWIPLine.Make);
                FixedAsset.Validate("Model No.", CWIPLine.Model);
                FixedAsset.Validate("Serial No.", CWIPLine."Serial No.");
                FixedAsset.Modify(true);
                FADepreciationBook.Init();
                FADepreciationBook.Validate("FA No.", FixedAsset."No.");
                FADepreciationBook.Validate("Depreciation Book Code", CWIPLine."FA Depreciation Book");
                FADepreciationBook.Insert(true);
                FADepreciationBook.Validate("Depreciation Method", FADepreciationBook."Depreciation Method"::"Straight-Line");
                FADepreciationBook.Validate("FA Posting Group", CWIPLine."FA Posting Group");
                FADepreciationBook.Validate("Depreciation Starting Date", CWIPLine."FA Start Date");
                FADepreciationBook.Validate("No. of Depreciation Years", CWIPLine."No. of Depreciation Years");
                FADepreciationBook.Modify(true);

                UpdateCWIPLedgerEntryAfterFACreated(CWIPLine, FixedAsset);

                CWIPLine."Fixed Asset No." := FixedAsset."No.";
                CWIPLine."Fixed Asset Name" := FixedAsset.Description;
                CWIPLine.Select := false;
                CWIPLine.Modify();
            until CWIPLine.Next() = 0;
            Window.Close();
            Message(SuccessTxt);
        end;
    end;

    local procedure CheckFACreationValidations()
    var
        CWIPLine: Record "CWIP Line";
        NoSelectErr: Label 'No lines selected.';
    begin
        TestField(Status, Status::Released);
        TestField(Posted, false);
        CWIPLine.Reset();
        CWIPLine.SetRange("Document No.", "No.");
        CWIPLine.SetRange(Select, true);
        if CWIPLine.FindSet() then begin
            repeat
                CWIPLine.TestField("FA Posting Group");
                CWIPLine.TestField("FA Depreciation Book");
                CWIPLine.TestField("FA Start Date");
                CWIPLine.TestField("No. of Depreciation Years");
                CWIPLine.TestField("FA No. Series");
            until CWIPLine.Next() = 0;
        end else
            Error(NoSelectErr);
    end;

    local procedure UpdateCWIPLedgerEntryAfterFACreated(CWIPLine: Record "CWIP Line"; FixedAsset: Record "Fixed Asset")
    var
        CWIPLedgerEntry: Record "CWIP Ledger Entry";
    begin
        if CWIPLedgerEntry.Get(CWIPLine."CWIP Entry No.") then begin
            CWIPLedgerEntry."FA No." := FixedAsset."No.";
            CWIPLedgerEntry.Description := FixedAsset.Description;
            CWIPLedgerEntry.Open := false;
            CWIPLedgerEntry.Modify();
        end;
    end;

    local procedure UpdateCWIPDetails(CWIPLine: Record "CWIP Line"; FixedAsset: Record "Fixed Asset")
    var
        CWIPDetails: Record "CWIP Details";
        CWIPLedgerEntry: Record "CWIP Ledger Entry";
    begin
        if CWIPLedgerEntry.Get(CWIPLine."CWIP Entry No.") then
            if CWIPDetails.Get(CWIPLine."Order No.", CWIPLine."Order Line No.", CWIPLedgerEntry."CWIP Detail Line No.") then begin
                CWIPDetails."FA No." := FixedAsset."No.";
                CWIPDetails."FA Created" := true;
                CWIPDetails.Modify();
            end;
    end;

    procedure PostDocument()
    var
        CWIPLine: Record "CWIP Line";
        PrevItemNo: Code[20];
        SuccessTxt: Label 'Document has been posted successfully.';
        ExecuteTxt: Label 'Do you want to post the document?';
    begin
        if not CONFIRM(ExecuteTxt, false) then
            exit;

        CheckFAPostingValidations();

        CWIPLine.Reset();
        CWIPLine.SetCurrentKey("Item No.");
        CWIPLine.SetRange("Document No.", "No.");
        if CWIPLine.FindSet() then begin
            repeat
                PostFAGeneralJournalEntry(CWIPLine);

                UpdateCWIPLedgerEntryAfterFAPosted(CWIPLine);

            /* if PrevItemNo <> CWIPLine."Item No." then begin
                PrevItemNo := CWIPLine."Item No.";
                PostNegativeAdjustmentForItem(CWIPLine);
            end; */

            until CWIPLine.Next() = 0;
            Posted := true;
            Modify();
            Message(SuccessTxt);
        end;
    end;

    local procedure CheckFAPostingValidations()
    var
        CWIPLine: Record "CWIP Line";
    begin
        TestField(Status, Status::Released);
        TestField(Posted, false);

        FASetup.Get();
        FASetup.TestField("CWIP FA Jnl. Tem. Name");
        FASetup.TestField("CWIP FA Jnl. Batch Name");
        FASetup.TestField("CWIP Item Jnl. Tem. Name");
        FASetup.TestField("CWIP Item Jnl. Batch Name");

        CWIPLine.Reset();
        CWIPLine.SetRange("Document No.", "No.");
        if CWIPLine.FindSet() then
            repeat
                CWIPLine.TestField("Fixed Asset No.");
            until CWIPLine.Next() = 0;
    end;

    local procedure PostFAGeneralJournalEntry(CWIPLine: Record "CWIP Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        FixedAsset: Record "Fixed Asset";
        FADeprBook: Record "FA Depreciation Book";
        LastGenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        LineNo: Integer;
    begin
        FASetup.Get();
        LastGenJnlLine.Reset;
        LastGenJnlLine.SetRange("Journal Template Name", FASetup."CWIP FA Jnl. Tem. Name");
        LastGenJnlLine.SetRange("Journal Batch Name", FASetup."CWIP FA Jnl. Batch Name");
        if LastGenJnlLine.FindLast() then
            LineNo := LastGenJnlLine."Line No." + 10000
        else
            LineNo := 10000;

        FixedAsset.Reset();
        FixedAsset.SetRange("No.", CWIPLine."Fixed Asset No.");
        FixedAsset.SetRange(Acquired, false);
        if FixedAsset.FindFirst() then begin
            FADeprBook.Reset();
            FADeprBook.SetRange("FA No.", FixedAsset."No.");
            if FADeprBook.FindFirst() then;

            GenJnlLine.Init();
            GenJnlLine.Validate("Journal Template Name", FASetup."CWIP FA Jnl. Tem. Name");
            GenJnlLine.Validate("Journal Batch Name", FASetup."CWIP FA Jnl. Batch Name");
            GenJnlLine.Validate("Line No.", LineNo);
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"Fixed Asset");
            GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Invoice);
            GenJnlLine.Validate("Account No.", FixedAsset."No.");
            GenJnlLine.Validate("Document No.", "No.");
            GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.Validate("Bal. Account No.", FASetup."CWIP G/L Account No.");
            GenJnlLine.Validate(Description, CWIPLine."Fixed Asset Name");
            GenJnlLine.Validate("Posting Date", "Posting Date");
            GenJnlLine.Validate("FA Posting Date", "Posting Date");
            GenJnlLine.Validate("FA Posting Type", GenJnlLine."FA Posting Type"::"Acquisition Cost");
            GenJnlLine.Validate("Depreciation Book Code", FADeprBook."Depreciation Book Code");
            GenJnlLine.Validate(Amount, CWIPLine.Amount);
            GenJnlLine.Validate("Shortcut Dimension 1 Code", CWIPLine."Shortcut Dimension 1 Code");
            GenJnlLine.Validate("Shortcut Dimension 2 Code", CWIPLine."Shortcut Dimension 2 Code");
            GenJnlLine.Validate("Dimension Set ID", CWIPLine."Dimension Set ID");
            GenJnlLine.Validate("Bal. Gen. Bus. Posting Group", '');
            GenJnlLine.Validate("Bal. Gen. Prod. Posting Group", '');
            GenJnlLine.Validate("Gen. Bus. Posting Group", '');
            GenJnlLine.Validate("Gen. Prod. Posting Group", '');
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure UpdateCWIPLedgerEntryAfterFAPosted(CWIPLine: Record "CWIP Line")
    var
        CWIPLedgerEntry: Record "CWIP Ledger Entry";
    begin
        if CWIPLedgerEntry.Get(CWIPLine."CWIP Entry No.") then begin
            CWIPLedgerEntry."FA Acquired" := true;
            CWIPLedgerEntry.Modify();
        end;
    end;

    local procedure PostNegativeAdjustmentForItem(CWIPLine: Record "CWIP Line")
    var
        ItemJnlLine: Record "Item Journal Line";
        LastItemJnlLine: Record "Item Journal Line";
        CWIPLine2: Record "CWIP Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        LineNo: Integer;
    begin
        FASetup.Get();

        LastItemJnlLine.Reset();
        LastItemJnlLine.SetRange("Journal Template Name", FASetup."CWIP Item Jnl. Tem. Name");
        LastItemJnlLine.SetRange("Journal Batch Name", FASetup."CWIP Item Jnl. Batch Name");
        if LastItemJnlLine.FindLast() then
            LineNo := LastItemJnlLine."Line No." + 10000
        else
            LineNo := 10000;


        CWIPLine2.Reset();
        CWIPLine2.SetRange("Document No.", CWIPLine."Document No.");
        CWIPLine2.SetRange("Item No.", CWIPLine."Item No.");
        if CWIPLine2.FindSet() then
            CWIPLine2.CalcSums(Quantity, Amount);

        ItemJnlLine.Init();
        ItemJnlLine.Validate("Journal Template Name", FASetup."CWIP Item Jnl. Tem. Name");
        ItemJnlLine.Validate("Journal Batch Name", FASetup."CWIP Item Jnl. Batch Name");
        ItemJnlLine.Validate("Line No.", LineNo);
        ItemJnlLine.Validate("Posting Date", "Posting Date");
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Negative Adjmt.");
        ItemJnlLine.Validate("Document No.", CWIPLine."Document No.");
        ItemJnlLine.Validate("Item No.", CWIPLine."Item No.");
        ItemJnlLine.Validate("Location Code", CWIPLine."Location Code");
        ItemJnlLine.Validate(Quantity, CWIPLine2.Quantity);
        ItemJnlLine.Validate("Unit Amount", CWIPLine2.Amount);
        ItemJnlLine.Validate("Shortcut Dimension 1 Code", CWIPLine."Shortcut Dimension 1 Code");
        ItemJnlLine.Validate("Shortcut Dimension 2 Code", CWIPLine."Shortcut Dimension 2 Code");
        ItemJnlLine.Validate("Dimension Set ID", CWIPLine."Dimension Set ID");
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;
}

