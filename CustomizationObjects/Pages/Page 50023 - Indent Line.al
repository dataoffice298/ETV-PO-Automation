page 50023 "Indent Line"
{
    //     // version PH1.0,PO1.0

    AutoSplitKey = true;
    //DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Indent Line";
    Caption = 'Indent Line';
    SourceTableView = where("Indent Transfer" = const(false));//BaluOn19Oct2022>>
    RefreshOnActivate = true;//B2BSSD22MAY2023


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
                    QuickEntry = true;

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
                    //B2BSSD25Apr2023<<
                    // trigger OnValidate()
                    // var
                    //     myInt: Integer;
                    // begin
                    //     if Rec.Type = Rec.type::Item then begin//B2BSSD27APR2023
                    //         if rec."Req.Quantity" > rec."Avail.Qty" then
                    //             Error('Requested Quantity should not be greater than Available Quantity');
                    //     end;
                    // end;
                    //B2BSSD25Apr2023>>
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
                    Caption = 'Qty. to Issue';
                }
                field("Qty Issued"; Rec."Qty Issued")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Qty To Return"; Rec."Qty To Return")
                {
                    ApplicationArea = all;
                    Caption = 'Qty To Return';
                }
                field("Qty Returned"; Rec."Qty Returned")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Issue Location"; rec."Issue Location")
                {
                    ApplicationArea = all;
                    //B2BSS11APR2023<<
                    Caption = 'From Location';
                    trigger OnValidate()
                    var
                        UserWiseLocation: Record "Location Wise User";
                        UserwiseSecurity: Codeunit UserWiseSecuritySetup;
                    begin
                        if not UserwiseSecurity.CheckUserLocation(UserId, Rec."Issue Location", 5) then
                            Error('User %1 dont have permission to location %2', UserId, Rec."Issue Location");
                    end;
                    //B2BSS11APR2023<<
                }
                field("Issue Sub Location"; rec."Issue sub Location")
                {
                    ApplicationArea = all;
                    Caption = 'To Location';//B2BSSD05APR2023
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
                /*action(createFAMovement)
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
                }*/

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
                        Rec.TestField(Select, true);//B2BSSD13APR2023
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
                        indentHeader: Record "Indent Header";
                        indentLine: Record "Indent Line";
                        FixedAsset: Record "Fixed Asset";
                        ERRORmsg: Label 'Fixed Assets is Not Available for Transfer';
                    begin
                        if Rec.Type = Rec.Type::Item then begin
                            Rec.TestField(Select, true);
                            Rec.TestField("Issue Location");
                            Rec.TestField("Issue Sub Location");
                            //B2BSSD26APR2023>>
                            Rec.CalcFields("Qty Issued");
                            if Rec."Qty Returned" = 0 then
                                error('Quantity Returned is Zero');
                            //B2BSSD26APR2023>>
                        end;

                        if Rec.Type = Rec.Type::"Fixed Assets" then begin
                            Rec.TestField(Acquired, true);
                            Rec.TestField(Select, true);

                            //B2BSSD21APR2023>>
                            indentLine.Reset();
                            indentLine.SetRange("Document No.", Rec."Document No.");
                            indentLine.SetRange("Line No.", Rec."Line No.");
                            if indentLine.FindSet() then begin
                                if indentLine."Avail/UnAvail" = true then
                                    Error(ERRORmsg);
                            end;
                            //B2BSSD21APR2023<<
                        end;
                        CreateRGPfromIndent(GateEntryType::Outward, GateEntryDocType::RGP);
                    end;
                }
                // //B2BSSD09MAR2023<<
                action(CretaeNRGPOutward)
                {
                    Caption = 'Create NRGP Outward';
                    Image = CreateDocument;
                    trigger OnAction()
                    var
                        ERRORmsg: Label 'Fixed Assets is Not Available for Transfer';
                    begin
                        if Rec.Type = Rec.Type::Item then
                            Rec.TestField(Select, true);
                        Rec.TestField("Qty Issued");
                        if Rec.Type = Rec.Type::"Fixed Assets" then begin
                            Rec.TestField(Acquired, true);
                            //B2BSSD21APR2023>>
                            indentLine.Reset();
                            indentLine.SetRange("Document No.", Rec."Document No.");
                            indentLine.SetRange("Line No.", Rec."Line No.");
                            if indentLine.FindSet() then begin
                                //repeat
                                if indentLine."Avail/UnAvail" = true then
                                    Error(ERRORmsg);
                                //until indentLine.Next() = 0;
                            end;
                            //B2BSSD21APR2023<<
                        end;
                        CreateRGPfromIndent(GateEntryType::Outward, GateEntryDocType::NRGP);
                    end;
                }
                //B2BSSD09MAR2023>>

                //B2BSSD02MAR2023>>

                //B2BSSD14MAR2023<<
                action(FromIndOpenGateEntries)
                {
                    ApplicationArea = All;
                    Image = Open;
                    Caption = 'Inward/Outward Entries';
                    trigger OnAction()
                    var
                        GateEntryHdr: Record "Gate Entry Header_B2B";
                    begin
                        GateEntryHdr.Reset();
                        GateEntryHdr.FilterGroup(2);
                        GateEntryHdr.SetRange("Indent Document No", Rec."Document No.");
                        GateEntryHdr.SetRange("Indent Line No", Rec."Line No.");
                        GateEntryHdr.FilterGroup(0);
                        Page.RunModal(Page::"Gate Entry List", GateEntryHdr);
                    end;
                }
                action(FromIndOpenPostedGateEntries)
                {
                    ApplicationArea = All;
                    Image = History;
                    Caption = 'Posted Inward/Outward Entries';
                    trigger OnAction()
                    var
                        PostedGateEntryHdr: Record "Posted Gate Entry Header_B2B";
                    begin
                        PostedGateEntryHdr.Reset();
                        PostedGateEntryHdr.FilterGroup(2);
                        PostedGateEntryHdr.SetRange("Indent Document No", Rec."Document No.");
                        PostedGateEntryHdr.SetRange("Indent Line No", Rec."Line No.");
                        PostedGateEntryHdr.FilterGroup(0);
                        Page.RunModal(Page::"Posted Gate Entries List", PostedGateEntryHdr);
                    end;
                }
            }
            //B2BSSD14MAR2023>>
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
        item: Record Item;
        FA: Record "Fixed Asset";
        indentLine: Record "Indent Line";
    begin
        //B2BSSD17APR2023>>
        indentLine.Reset();
        indentLine.SetRange("Document No.", Rec."Document No.");
        indentLine.SetRange("Release Status", Rec."Release Status"::Released);
        if not indentLine.FindSet() then
            Error('Status Must Be equals to Release');
        //B2BSSD17APR2023<<
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."Document No.");
        IndentLine.SetRange(Select, true);
        if IndentLine.FindSet() then begin

            GateEntryHeader.Init();
            if DocType = DocType::RGP then
                GateEntryHeader.Type := GateEntryHeader.Type::RGP
            else
                if DocType = DocType::NRGP then
                    GateEntryHeader.Type := GateEntryHeader.Type::NRGP;

            //B2BSSD03MAY2023>>
            if EntryType = EntryType::Inward then begin
                GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Inward;
                GateEntryHeader.Validate("Location Code", Rec."Issue Sub Location");
                GateEntryHeader.Validate("To Location", Rec."Issue Location");
            end
            else
                if EntryType = EntryType::Outward then begin
                    GateEntryHeader."Entry Type" := GateEntryHeader."Entry Type"::Outward;
                    GateEntryHeader.Validate("Location Code", Rec."Issue Location");
                    GateEntryHeader."To Location" := Rec."Issue Sub Location";
                end;
            //B2BSSD03MAY2023<<

            GateEntryHeader.Insert(true);
            GateEntryHeader."Indent Document No" := Rec."Document No.";
            GateEntryHeader."Indent Line No" := Rec."Line No.";
            GateEntryHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
            GateEntryHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            GateEntryHeader."Shortcut Dimension 9 Code" := Rec."Shortcut Dimension 9 Code";
            GateEntryHeader.SubLocation := Rec."Issue Location";

            //B2BSSD07APR2023<<
            IndentHeader.Reset();
            IndentHeader.SetRange("No.", Rec."Document No.");
            if IndentHeader.FindFirst() then begin
                IndentLine.Reset();
                IndentLine.SetRange("Document No.", GateEntryHeader."Indent Document No");
                if IndentLine.FindFirst() then
                    GateEntryHeader.Purpose := IndentHeader.Purpose;
                GateEntryHeader.Program := IndentHeader."programme Name";
            end;
            //B2BSSD07APR2023>>
            GateEntryHeader.Modify();
            LineNo := 10000;
            repeat


                GateEntryLine.Init();
                GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                GateEntryLine.Type := GateEntryHeader.Type;
                GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                GateEntryLine."Line No." := LineNo;
                GateEntryLine.Insert(true);
                if IndentLine.Type = IndentLine.Type::Item then begin
                    GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
                end else
                    if IndentLine.Type = IndentLine.Type::"Fixed Assets" then
                        GateEntryLine."Source Type" := GateEntryLine."Source Type"::"Fixed Asset";
                GateEntryLine."Source No." := IndentLine."No.";

                //B2BSSD17APR2023>>
                FixedAsset.Reset();
                FixedAsset.SetRange("No.", GateEntryLine."Source No.");
                if FixedAsset.FindFirst() then begin
                    FixedAsset."available/Unavailable" := true;
                    FixedAsset.Modify();
                end;
                //B2BSSD17APR2023<<

                GateEntryLine.Variant := IndentLine."Variant Code";
                indentLine.CalcFields("Qty Issued");//B2BSSD28APR2023
                GateEntryLine.Quantity := abs(IndentLine."Qty Issued");//B2BSSD07APR2023
                GateEntryLine."Source Name" := IndentLine.Description;
                GateEntryLine.Description := IndentLine.Description;
                LineNo += 10000;
                GateEntryLine."Avail Qty" := IndentLine."Avail.Qty";//B2BSSD03APR2023
                GateEntryLine."Unit of Measure" := Rec."Unit of Measure";
                if FA.Get(GateEntryLine."Source No.") then
                    GateEntryLine.ModelNo := FA."Model No.";
                GateEntryLine.SerialNo := FA."Serial No.";
                GateEntryLine.Variant := FA.Make_B2B;
                GateEntryLine.Modify();

            until IndentLine.Next() = 0;
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

    //B2BSSD22MAY2023>>
    trigger OnAfterGetCurrRecord()//B2BSSD06JUN2023
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        Rec."Avail.Qty" := 0;
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", Rec."No.");
        ItemLedgerEntry.SETRANGE("Variant Code", Rec."Variant Code");
        ItemLedgerEntry.SETRANGE("Location Code", Rec."Delivery Location");
        IF ItemLedgerEntry.FindSet() THEN begin
            ItemLedgerEntry.CalcSums(Quantity);
            Rec."Avail.Qty" := ItemLedgerEntry.Quantity;
        end;
    end;
    //B2BSSD22MAY2023<<

    var
        ItemLedgerEntry: Record 32;
        IndentHeader: Record "Indent Header";
        IndentLine: Record "Indent Line";
        FieldEditable: Boolean;
        SelectErr: Label 'No Lines Selected';
        Attachemnets: Codeunit Attachments;
        GateEntryType: Option Inward,Outward;
        GateEntryDocType: Option RGP,NRGP;
        FixedAsset: Record "Fixed Asset";
}