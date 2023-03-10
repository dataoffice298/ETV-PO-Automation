page 50023 "Indent Line"
{
    // version PH1.0,PO1.0

    AutoSplitKey = true;
    //DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Indent Line";
    Caption = 'Indent Line';
    SourceTableView = where("Indent Transfer" = const(false));//BaluOn19Oct2022>>


    layout
    {
        area(content)
        {
            repeater("Control")
            {
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Indentor Description"; Rec."Indentor Description")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field(Select; Rec.Select)//B2BSSD30Jan2023
                {
                    ApplicationArea = All;
                }
                field("Spec Id"; rec."Spec Id")
                {
                    ApplicationArea = all;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field(Acquired; Rec.Acquired)//B2BSSD01MAR2023
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    //Caption = 'Make';
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field(Department; rec.Department)
                {
                    Visible = false;
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Delivery Location"; rec."Delivery Location")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Avail.Qty"; Rec."Avail.Qty")
                {
                    ApplicationArea = all;
                    Editable = FieldEditable;
                }
                field("Req.Quantity"; rec."Req.Quantity")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Unit of Measure"; rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Indent Status"; rec."Indent Status")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field(Remarks; rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = FieldEditable;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = FieldEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = FieldEditable;
                }
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")//B2BSSD20Feb2023
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 9 Code';
                    Editable = FieldEditable;
                }
                field("Qty To Issue"; Rec."Qty To Issue")
                {
                    ApplicationArea = all;
                    Caption = 'Qty. to Issue/Return';
                }
                field("Qty Issued"; Rec."Qty Issued")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Qty To Return"; Rec."Qty To Return")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Qty Returned"; Rec."Qty Returned")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Issue Location"; rec."Issue Location")
                {
                    ApplicationArea = all;
                }
                field("Issue Sub Location"; rec."Issue sub Location")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(ShowItemJournalIssue)
                {
                    ApplicationArea = ALL;
                    Caption = 'Show Item Journal Issue';
                    Image = ShowList;
                    trigger onaction()
                    var
                        ItemJournalLine: Record "Item Journal Line";
                        ItemJournal: Page "Item Journal";
                        PurchaseSetup: Record "Purchases & Payables Setup";
                    BEGIN
                        PurchaseSetup.Get();
                        ItemJournalLine.reset;
                        ItemJournalLine.SetRange("Journal Template Name", PurchaseSetup."Indent Issue Jnl. Template");
                        ItemJournalLine.SetRange("Journal Batch Name", PurchaseSetup."Indent Issue Jnl. Batch");
                        ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
                        ItemJournalLine.SetRange("Item No.", Rec."No.");
                        IF ItemJournalLine.findset then;
                        Page.RunModal(40, ItemJournalLine);
                    END;
                }

                action(ShowItemJournalBatchReturn)
                {
                    ApplicationArea = ALL;
                    Caption = 'Show ItemJournal Batch Return';
                    Image = ShowList;
                    trigger onaction()
                    var
                        ItemJournalLine: Record "Item Journal Line";
                        ItemJournal: Page "Item Journal";
                        PurchaseSetup: Record "Purchases & Payables Setup";
                    BEGIN
                        PurchaseSetup.Get();
                        ItemJournalLine.reset;
                        ItemJournalLine.SetRange("Journal Template Name", PurchaseSetup."Indent Return Jnl. Template");
                        ItemJournalLine.SetRange("Journal Batch Name", PurchaseSetup."Indent Return Jnl. Batch");
                        ItemJournalLine.SetRange("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
                        ItemJournalLine.SetRange("Item No.", Rec."No.");
                        IF ItemJournalLine.findset then;
                        Page.RunModal(40, ItemJournalLine);
                    END;
                }
                action(createFAMovement)
                {
                    ApplicationArea = ALL;
                    Caption = 'create FA Movement';
                    Image = CreateMovement;
                    trigger onaction()
                    var
                        FAMovement: Codeunit MyBaseSubscr;
                    BEGIN
                        Rec.TestField(Type, Rec.Type::"Fixed Assets");
                        FAMovement.CreateFAMovememt(rec);
                    END;
                }
                action(OpenFAMovementEntries)
                {
                    ApplicationArea = ALL;
                    Caption = 'FA Movement Entries';
                    Image = Entries;
                    trigger onaction()
                    var
                        FAMovement: Record "Fixed Asset Movements";
                    BEGIN
                        Rec.TestField(Type, Rec.Type::"Fixed Assets");
                        FAMovement.Reset();
                        FAMovement.SetRange("Document No.", Rec."Document No.");
                        FAMovement.SetRange("Document Line No.", Rec."Line No.");
                        if FAMovement.FindSet() then
                            Page.Run(0, FAMovement);
                    END;
                }
                //B2BSSD30Jan2023<<
                action("Item Specification")
                {
                    ApplicationArea = All;
                    Image = Import;
                    Caption = 'Specification ID Import';
                    trigger OnAction()
                    var
                        TechnicalSpec: Record "Technical Specifications";
                    begin
                        if Rec.Select = false then
                            Error(SelectErr);
                        TechnicalSpec.ReadExcelSheet();
                        TechnicalSpec.ImportExcelData();
                    end;
                }
                action("Item TechnicalSpec")
                {
                    ApplicationArea = All;
                    Image = Import;
                    Caption = 'Specification';
                    trigger OnAction()
                    var
                        TechnicalSpec: Page TechnicalSpecifications;
                        TechnicalspecRec: Record "Technical Specifications";
                    begin
                        if Rec.Select = false then
                            Error(SelectErr);
                        TechnicalspecRec.Reset();
                        TechnicalspecRec.SetRange("Item No.", Rec."No.");
                        TechnicalspecRec.SetRange("Document No.", Rec."Document No.");
                        TechnicalspecRec.SetRange("Line No.", Rec."Line No.");
                        TechnicalSpec.SetTableView(TechnicalspecRec);
                        TechnicalSpec.Run();
                    end;
                }
                //B2BSSD30Jan2023>> 

                //B2BSSD31Jan2023<<
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        DocumentAttRec: Record "Document Attachment";
                        RecRef: RecordRef;
                    begin
                        if Rec.Select = false then
                            Error(SelectErr);

                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                        CurrPage.Update();
                    end;
                }
                //B2BSSD31Jan2023>>
            }
            //B2BSSD02MAR2023<<
            group(RGP)
            {
                action(CreateRPGInward)
                {
                    Caption = 'Create RGP Inward';
                    Image = CreateDocument;
                    trigger OnAction()
                    var
                    begin
                        if Rec.Type = Rec.Type::Item then
                            Rec.TestField(Select, true);
                        if Rec.Type = Rec.Type::"Fixed Assets" then
                            Rec.TestField(Acquired, true);
                        CreateRGPfromIndent(GateEntryType::Inward, GateEntryDocType::RGP);
                    end;
                }
                action(CreateRGPOutward)
                {
                    Caption = 'Create RGP Outward';
                    Image = CreateDocument;
                    trigger OnAction()
                    var
                        myInt: Integer;
                    begin
                        if Rec.Type = Rec.Type::Item then
                            Rec.TestField(Select, true);
                        if Rec.Type = Rec.Type::"Fixed Assets" then
                            Rec.TestField(Acquired, true);
                        CreateRGPfromIndent(GateEntryType::Outward, GateEntryDocType::RGP);
                    end;
                }
                //B2BSSD09MAR2023<<
                action(CretaeNRGPOutward)
                {
                    Caption = 'Create NRGP Outward';
                    Image = CreateDocument;
                    trigger OnAction()
                    var
                    begin
                        if Rec.Type = Rec.Type::Item then
                            Rec.TestField(Select, true);
                        if Rec.Type = Rec.Type::"Fixed Assets" then
                            Rec.TestField(Acquired, true);
                        CreateRGPfromIndent(GateEntryType::Outward, GateEntryDocType::NRGP);
                    end;
                }
                //B2BSSD09MAR2023>>
            }
            //B2BSSD02MAR2023>>
        }
    }
    //B2BSSD02MAR2023<<
    local procedure CreateRGPfromIndent(EntryType: Option Inward,Outward; DocType: Option RGP,NRGP)
    var
        GateEntryHeader: Record "Gate Entry Header_B2B";
        GateEntryLine: Record "Gate Entry Line_B2B";
        LineNo: Integer;
        OpenText: Label 'An Gate Entry document - %1 is created. \Do you want to open the document?';
        SelErr: Label 'No line selected.';
    begin
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."Document No.");
        IndentLine.SetRange(Select, true);
        if IndentLine.FindFirst() then
            Rec.TestField("Qty Issued");

        GateEntryHeader.Reset();
        GateEntryHeader.SetRange("Indent Document No", Rec."Document No.");
        GateEntryHeader.SetRange("Indent Line No", Rec."Line No.");
        if GateEntryHeader.FindFirst() then
            if EntryType = EntryType::Outward then
                Rec.TestField("Qty Issued")
            else
                if EntryType = EntryType::Inward then
                    Rec.TestField("Qty Returned");

        GateEntryHeader.Init();
        if EntryType = EntryType::Inward then
            GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Inward
        else
            if EntryType = EntryType::Outward then
                GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Outward;

        if DocType = DocType::RGP then
            GateEntryHeader.Type := GateEntryHeader.Type::RGP
        else
            if DocType = DocType::NRGP then
                GateEntryHeader.Type := GateEntryHeader.Type::NRGP;

        GateEntryHeader.Validate("Location Code", Rec."Issue Location");
        GateEntryHeader.Insert(true);
        GateEntryHeader."Indent Document No" := Rec."Document No.";
        GateEntryHeader."Indent Line No" := Rec."Line No.";
        GateEntryHeader."Item Description" := Rec.Description;
        GateEntryHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        GateEntryHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        GateEntryHeader."Shortcut Dimension 9 Code" := Rec."Shortcut Dimension 9 Code";
        GateEntryHeader.SubLocation := Rec."Issue Sub Location";
        GateEntryHeader.Modify();
        //end;

        if IndentLine.Type = IndentLine.Type::Item then begin
            GateEntryLine.Init();
            GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
            GateEntryLine.Type := GateEntryHeader.Type;
            GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
            GateEntryLine."Line No." := 10000;
            GateEntryLine.Insert(true);
            GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
            GateEntryLine."Source No." := Rec."No.";
            GateEntryLine.Variant := Rec."Variant Code";
            GateEntryLine."Source Name" := Rec.Description;
            GateEntryLine.Description := Rec.Description;
            if EntryType = EntryType::Outward then
                GateEntryLine.Validate(Quantity, Abs(Rec."Qty Issued"))
            else
                if EntryType = EntryType::Inward then
                    GateEntryLine.Validate(Quantity, Abs(Rec."Qty Returned"));
            GateEntryLine."Unit of Measure" := Rec."Unit of Measure";
            GateEntryLine.Modify();
        end;

        if IndentLine.Type = IndentLine.Type::"Fixed Assets" then begin
            GateEntryLine.Init();
            GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
            GateEntryLine.Type := GateEntryHeader.Type;
            GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
            GateEntryLine."Line No." := 10000;
            GateEntryLine.Insert(true);
            GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
            GateEntryLine."Source No." := Rec."No.";
            GateEntryLine.Variant := Rec."Variant Code";
            GateEntryLine."Source Name" := Rec.Description;
            GateEntryLine.Description := Rec.Description;
            if EntryType = EntryType::Outward then
                GateEntryLine.Validate(Quantity, Abs(Rec."Qty Issued"))
            else
                if EntryType = EntryType::Inward then
                    GateEntryLine.Validate(Quantity, Abs(Rec."Qty Returned"));
            GateEntryLine."Unit of Measure" := Rec."Unit of Measure";
            GateEntryLine.Modify();
        end;

        if Confirm(OpenText, false, GateEntryHeader."No.") then
            if (EntryType = EntryType::Inward) and (DocType = DocType::RGP) then
                Page.Run(Page::"Inward Gate Entry-RGP", GateEntryHeader)
            else
                if (EntryType = EntryType::Inward) and (DocType = DocType::NRGP) then
                    Page.Run(Page::"Inward Gate Entry-NRGP", GateEntryHeader)
                else
                    if (EntryType = EntryType::Outward) and (DocType = DocType::RGP) then
                        Page.Run(Page::"Outward Gate Entry - RGP", GateEntryHeader)
                    else
                        if (EntryType = EntryType::Outward) and (DocType = DocType::NRGP) then
                            Page.Run(Page::"Outward Gate Entry - NRGP", GateEntryHeader);
    end;

    //B2BSSD02MAR2023>>

    //B2BMSOn04Nov2022>>
    trigger OnInit()
    begin
        FieldEditable := true;
    end;

    trigger OnAfterGetRecord()
    var
        IndentHdr: Record "Indent Header";
    begin
        if IndentHdr.Get(Rec."Document No.") then;
        if (IndentHdr."Released Status" = IndentHdr."Released Status"::Released) then
            FieldEditable := false
        else
            FieldEditable := true;
    end;
    //B2BMSOn04Nov2022<<
    trigger OnOpenPage()
    var
        TechnicalSpec: Record "Technical Specifications";
    begin

    end;

    var
        ItemLedgerEntry: Record 32;
        IndentHeader: Record "Indent Header";
        IndentLine: Record "Indent Line";
        FieldEditable: Boolean;
        SelectErr: Label 'No Lines Selected';
        Attachemnets: Codeunit Attachments;
        GateEntryType: Option Inward,Outward;
        GateEntryDocType: Option RGP,NRGP;
}

