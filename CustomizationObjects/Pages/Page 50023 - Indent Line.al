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
        }
    }


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
}

