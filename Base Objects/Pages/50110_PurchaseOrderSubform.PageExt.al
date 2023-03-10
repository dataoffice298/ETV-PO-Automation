pageextension 50110 PurchaseOrderSubform1 extends "Purchase Order Subform"
{
    //B2BVCOn03Oct22>>>
    layout
    {
        addafter(Description)
        {
            field(Select; Rec.Select)
            {
                ApplicationArea = all;
            }
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter(Description)
        {
            field("FA Posting Type"; Rec."FA Posting Type")
            {
                ApplicationArea = All;

            }
        }
        //B2BSSD16FEB2023<<
        addafter("Item Reference No.")
        {
            field("Depreciation Book Code"; Rec."Depreciation Book Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Depreciation Book Code")
        {
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
        //B2BSSD16FEB2023>>
        addafter("No.")//B2BSSD15FEB2023
        {
            field("Indentor Description"; Rec."Indentor Description")//B2BSSD02Feb2023
            {
                ApplicationArea = All;
            }
            field("Spec Id"; rec."Spec Id")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location Code")
        {
            field("Sub Location Code"; Rec."Sub Location Code")
            {
                ApplicationArea = All;
            }
        }

        addbefore("Shortcut Dimension 1 Code")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Line No."; Rec."Indent Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Req No"; Rec."Indent Req No")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Indent Req Line No"; Rec."Indent Req Line No")
            {
                ApplicationArea = all;
                Editable = false;
            }
            //B2BMSOn03Nov2022>>
            field("QC Enabled B2B"; Rec."QC Enabled B2B")
            {
                ApplicationArea = All;
            }
            field("Qty. to Accept B2B"; Rec."Qty. to Accept B2B")
            {
                ApplicationArea = All;
            }
            field("Qty. to Reject B2B"; Rec."Qty. to Reject B2B")
            {
                ApplicationArea = All;
            }
            field("Rejection Comments B2B"; rec."Rejection Comments B2B")
            {
                Caption = 'Rejection Comments';
                ApplicationArea = all;
            }
            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                ApplicationArea = All;
            }
            field("Quantity Rejected B2B"; Rec."Quantity Rejected B2B")
            {
                ApplicationArea = All;
            }
            //B2BMSOn03Nov2022<<
            field(warranty; Rec.warranty)//B2BSSD08Feb2023
            {
                ApplicationArea = All;
                Caption = 'warranty';
            }
        }
        addafter("Gen. Prod. Posting Group")//B2BSSD24Feb2023
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                Caption = 'Gen. Prod. Posting Group';
            }
        }

        //B2BSSD24FEB2023<<
        addafter(warranty)
        {
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = All;
            }
            field("Model No."; Rec."Model No.")
            {
                ApplicationArea = All;
            }
            field(Make_B2B; Rec.Make_B2B)
            {
                ApplicationArea = All;
            }
        }
        //B2BSSD24FEB2023>>
        addafter("Shortcut Dimension 2 Code")//B2BSSD01MAR2023
        {
            field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")
            {
                ApplicationArea = All;
            }
        }

    }


    actions
    {
        //B2BMSOn28Oct2022>>
        addafter("Item Tracking Lines")
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import Item Tracking';
                Image = Import;

                trigger OnAction()
                var
                    TrackImport: Report "Purchase Line Tracking Import";
                begin
                    Clear(TrackImport);
                    TrackImport.GetValues(Rec);
                    TrackImport.Run();
                    Commit();
                    Rec.OpenItemTrackingLines;
                end;
            }
        }
        //B2BMSOn28Oct2022<<

        //B2BMSOn03Nov2022>>
        addlast("F&unctions")
        {
            group(RGP)
            {
                group(RGPInward)
                {
                    Caption = 'RGP Inward';
                    action(CreateRGPInward)
                    {
                        Caption = 'Create RGP Inward';
                        ApplicationArea = All;
                        Image = CreateDocument;
                        trigger OnAction()
                        var
                            PurChaseHeader: Record "Purchase Header";//B2BSSDJan2023
                        begin
                            //B2BSSDJan2023<<
                            PurChaseHeader.Reset();
                            PurChaseHeader.SetRange("No.", Rec."Document No.");
                            if PurChaseHeader.FindFirst() then begin
                                PurChaseHeader.TestField("Import Type");
                            end;
                            //B2BSSDJan2023>>
                            CreateGateEntries(GateEntryType::Inward, GateEntryDocType::RGP)
                        end;
                    }

                    action(CreateNRGPInward)
                    {
                        Caption = 'Create NRGP Inward';
                        ApplicationArea = All;
                        Image = Create;

                        trigger OnAction()
                        begin
                            CreateGateEntries(GateEntryType::Inward, GateEntryDocType::NRGP)
                        end;
                    }
                }
                group(RGPOutward)
                {
                    Caption = 'RGP Outward';
                    action(CreateRGPOutward)
                    {
                        Caption = 'Create RGP Outward';
                        ApplicationArea = All;
                        Image = CreateDocument;

                        trigger OnAction()
                        begin
                            CreateGateEntries(GateEntryType::Outward, GateEntryDocType::RGP)
                        end;
                    }

                    action(CreateNRGPOutward)
                    {
                        Caption = 'Create NRGP Outward';
                        ApplicationArea = All;
                        Image = Create;

                        trigger OnAction()
                        begin
                            CreateGateEntries(GateEntryType::Outward, GateEntryDocType::NRGP)
                        end;
                    }
                }
                group(Navigate)
                {
                    action(OpenGateEntries)
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
                            GateEntryHdr.SetRange("Purchase Order No.", Rec."Document No.");
                            GateEntryHdr.SetRange("Purchase Order Line No.", Rec."Line No.");
                            GateEntryHdr.FilterGroup(0);
                            Page.RunModal(Page::"Gate Entry List", GateEntryHdr);
                        end;
                    }
                    action(OpenPostedGateEntries)
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
                            PostedGateEntryHdr.SetRange("Purchase Order No.", Rec."Document No.");
                            PostedGateEntryHdr.SetRange("Purchase Order Line No.", Rec."Line No.");
                            PostedGateEntryHdr.FilterGroup(0);
                            Page.RunModal(Page::"Posted Gate Entries List", PostedGateEntryHdr);
                        end;
                    }
                }
            }
            //B2BMSOn03Nov2022<<
        }
        //B2BSSD07Feb2023<<
        addlast("O&rder")
        {
            group("Fixed Assets")
            {
                action("Fixed Asssets&Imports")
                {
                    ApplicationArea = All;
                    Caption = 'Import Fixed Assets';
                    Image = ImportExcel;
                    ToolTip = 'Executes the Excel Imported action.';
                    trigger OnAction()
                    var
                        RGPInward: Record "Gate Entry Header_B2B";
                        RGPInwardLine: Record "Gate Entry Line_B2B";
                        PurchaseLine1: Record "Purchase Line";
                        RGPError: TextConst ENU = 'RGP Inward No. Must Have an Value.';
                        FixedAssets: Record "Fixed Asset";
                    begin
                        /*PurchaseLine1.Reset();
                        PurchaseLine1.SetRange("Document No.", Rec."Document No.");
                        PurchaseLine1.SetRange("Line No.", Rec."Line No.");
                        if PurchaseLine1.FindSet() then begin
                            RGPInward.Reset();
                            RGPInward.SetRange("Purchase Order No.", PurchaseLine1."Document No.");
                            if not RGPInward.FindFirst() then
                                Error(RGPError);
                        end;*/
                        //Rec.TestField("Qty. to Accept B2B");//B2BSSD23FEB2023
                        PurchaseLine1.Reset();
                        PurchaseLine1.SetRange("Document No.", Rec."Document No.");
                        PurchaseLine1.SetRange("Document Type", Rec."Document Type");
                        if PurchaseLine1.FindFirst() then begin
                            IndentNo := PurchaseLine1."Indent No.";
                            IndetReqNo := PurchaseLine1."Indent Req No";
                            ShortcutDimension1 := PurchaseLine1."Shortcut Dimension 1 Code";
                            ShortCutDimension2 := PurchaseLine1."Shortcut Dimension 2 Code";
                            ShortCutDimention9 := PurchaseLine1."Shortcut Dimension 9 Code";
                            DirectUnitCost := PurchaseLine1."Direct Unit Cost";
                            IndentorDescription := PurchaseLine1."Indentor Description";
                            SpecID := PurchaseLine1."Spec Id";
                        end;
                        PurchaseLine1.Reset();
                        PurchaseLine1.SetRange("Document No.", Rec."Document No.");
                        PurchaseLine1.SetRange("Document Type", Rec."Document Type");
                        PurchaseLine1.SetFilter("No.", '%1', '');
                        PurchaseLine1.DeleteAll();
                        //Rec.DeleteAll();
                        FixedAssetsReadExcelSheet();
                        FixedAssetsImportExcelData();
                    end;
                }
            }
        }
        //B2BSSD07Feb2023>>

        //B2BSSD10Feb2023<<
        addlast("O&rder")
        {
            group(Specification)
            {
                action(Specification1)
                {
                    ApplicationArea = All;
                    Image = Import;
                    Caption = 'Specification';
                    RunObject = page TechnicalSpecifications;
                    RunPageLink = "Document No." = field("Indent No."), "Line No." = field("Indent Line No.");
                    trigger OnAction()
                    var
                    begin

                    end;
                }
                //B2BSSD14FEB2023<<
                action(DocAttachPurOrd)
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
                        IndentLine: Record "Indent Line";
                    begin
                        DocumentAttRec.Reset();
                        DocumentAttRec.SetRange("No.", Rec."Indent No.");
                        DocumentAttRec.SetRange("Line No.", Rec."Indent Line No.");
                        if DocumentAttRec.FindSet() then
                            Page.RunModal(50183, DocumentAttRec)
                        else begin
                            IndentLine.Get(Rec."Indent No.", Rec."Indent Line No.");
                            RecRef.GetTable(IndentLine);
                            DocumentAttachmentDetails.OpenForRecRef(RecRef);
                            DocumentAttachmentDetails.RunModal();
                        end;

                        CurrPage.Update();
                    end;
                }
                //B2BSSD14FEB2023>>
            }
        }
        //B2BSSD10Feb2023>>

    }

    procedure CreateGateEntries(EntryType: Option Inward,Outward; DocType: Option RGP,NRGP)
    var
        GateEntryHeader: Record "Gate Entry Header_B2B";
        GateEntryLine: Record "Gate Entry Line_B2B";
        OpenText: Label 'An Gate Entry document - %1 is created. \Do you want to open the document?';
        PurchLine: Record "Purchase Line";
        SelErr: Label 'No line selected.';
        ItemLRec: Record Item;
        FALRec: Record "Fixed Asset";
        ReservationEntry: Record "Reservation Entry";
        LineNo: Integer;
        PurchHeader: Record "Purchase Header";
    begin
        //Clear(ReservationEntry);
        LineNo := 10000;
        PurchLine.Reset();
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange(Select, true);
        if PurchLine.FindSet() then
            repeat
                Rec.CheckTracking(PurchLine);
            until PurchLine.Next() = 0;

        PurchLine.Reset();
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange(Select, true);
        if PurchLine.FindSet() then begin
            if EntryType = EntryType::Inward then
                Rec.TestField("Qty. to Receive")
            else
                if EntryType = EntryType::Outward then
                    Rec.TestField("Qty. to Reject B2B");

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

            GateEntryHeader.Validate("Location Code", Rec."Location Code");
            GateEntryHeader."Purchase Order No." := Rec."Document No.";
            GateEntryHeader."Purchase Order Line No." := Rec."Line No.";
            //B2BSSD11Jan2023<<
            GateEntryHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
            GateEntryHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            GateEntryHeader."Shortcut Dimension 9 Code" := Rec."Shortcut Dimension 9 Code";
            GateEntryHeader.SubLocation := Rec."Sub Location Code";
            //B2BSSD11Jan2023>>
            GateEntryHeader.Insert(true);

            repeat
                if PurchLine.Type = PurchLine.Type::Item then begin
                    /*ReservationEntry.Reset();
                    ReservationEntry.SetRange("Item No.", PurchLine."No.");
                    ReservationEntry.SetRange("Source Type", 39);
                    ReservationEntry.SetRange("Source Subtype", 1);
                    ReservationEntry.SetRange("Location Code", PurchLine."Location Code");
                    ReservationEntry.SetRange("Source ID", PurchLine."Document No.");
                    ReservationEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
                    ReservationEntry.SetRange(Positive, true);
                    if ReservationEntry.Findset() then*/
                    //repeat
                    GateEntryLine.Init();
                    GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                    GateEntryLine.Type := GateEntryHeader.Type;
                    GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                    GateEntryLine."Line No." := LineNo;
                    GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
                    GateEntryLine.Validate("Source No.", PurchLine."No.");
                    ItemLRec.Get(PurchLine."No.");
                    GateEntryLine."Source Name" := ItemLRec.Description;
                    GateEntryLine.Description := ItemLRec.Description;
                    GateEntryLine.Variant := PurchLine."Variant Code";//B2BSSDOn13Dec2022
                    GateEntryLine."Unit of Measure" := PurchLine."Unit of Measure Code";
                    //GateEntryLine.Validate(Quantity, ReservationEntry.Quantity);
                    //B2BSSD24Feb2023<<
                    GateEntryLine.Quantity := PurchLine.Quantity;
                    GateEntryLine.Make := PurchLine.Make_B2B;
                    GateEntryLine.ModelNo := PurchLine."Model No.";
                    GateEntryLine.SerialNo := PurchLine."Serial No.";
                    //B2BSSD24Feb2023>>
                    //GateEntryLine.ModelNo := ReservationEntry."Lot No.";
                    //GateEntryLine.SerialNo := ReservationEntry."Serial No.";
                    //GateEntryLine.Make := ReservationEntry."Variant Code";
                    GateEntryLine.Insert(true);
                    LineNo += 10000;
                    //until ReservationEntry.Next() = 0;
                end else
                    if PurchLine.Type = PurchLine.Type::"Fixed Asset" then begin
                        GateEntryLine.Init();
                        GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                        GateEntryLine.Type := GateEntryHeader.Type;
                        GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                        GateEntryLine."Line No." := LineNo;
                        GateEntryLine."Source Type" := GateEntryLine."Source Type"::"Fixed Asset";
                        GateEntryLine.Validate("Source No.", PurchLine."No.");
                        FALRec.Get(PurchLine."No.");
                        GateEntryLine."Source Name" := FALRec.Description;
                        GateEntryLine.Description := FALRec.Description;
                        GateEntryLine."Unit of Measure" := Rec."Unit of Measure Code";
                        if EntryType = EntryType::Inward then
                            GateEntryLine.Validate(Quantity, PurchLine."Qty. to Accept B2B")
                        else
                            if EntryType = EntryType::Outward then
                                GateEntryLine.Validate(Quantity, Rec."Qty. to Reject B2B");
                        GateEntryLine.ModelNo := FALRec."Model No.";
                        GateEntryLine.SerialNo := FALRec."Serial No.";
                        GateEntryLine.Make := FALRec.Make_B2B;
                        GateEntryLine.Insert(true);
                        LineNo += 10000
                    end else
                        //B2BSSD20FEB2023<<
                        if PurchLine.Type = PurchLine.Type::Description then begin
                            GateEntryLine.Init();
                            GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                            GateEntryLine.Type := GateEntryHeader.Type;
                            GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                            GateEntryLine."Line No." := LineNo;
                            GateEntryLine."Source Type" := GateEntryLine."Source Type"::Item;
                            GateEntryLine.Validate("Source No.", PurchLine."No.");
                            ItemLRec.Get(PurchLine."No.");
                            GateEntryLine."Source Name" := ItemLRec.Description;
                            GateEntryLine.Description := ItemLRec.Description;
                            GateEntryLine.Variant := PurchLine."Variant Code";
                            GateEntryLine."Unit of Measure" := Rec."Unit of Measure Code";
                            GateEntryLine.Quantity := PurchLine.Quantity;
                            GateEntryLine.Insert(true);
                            LineNo += 10000;
                        end;
                //B2BSSD20FEB2023>>
                PurchLine.Select := false;
                if EntryType = EntryType::Outward then begin
                    PurchLine."Quantity Rejected B2B" += PurchLine."Qty. to Reject B2B";
                    PurchLine."Qty. to Reject B2B" := 0;
                end else
                    if EntryType = EntryType::Inward then begin
                        PurchLine."Quantity Accepted B2B" += PurchLine."Qty. to Accept B2B";
                        PurchLine."Qty. to Accept B2B" := 0;
                    end;
                PurchLine.Modify();
            until PurchLine.Next() = 0;

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
        end else
            Error(SelErr);
    end;

    var
        GateEntryType: Option Inward,Outward;
        GateEntryDocType: Option RGP,NRGP;
        //B2BSS07Feb2023<<
        ExcelImportSuccess: Label 'Excel File Imported Successfully';
        uplodMsg: Label 'Please Choose The Excel file';
        FileName: text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NoFileMsg: Label 'No excel File Found';
        IndentNo: Code[30];
        IndetReqNo: Code[30];
        ShortcutDimension1: Code[20];
        ShortCutDimension2: Code[20];
        ShortCutDimention9: Code[20];
        DirectUnitCost: Decimal;
        IndentorDescription: Code[250];
        SpecID: Code[250];
    //B2BSS07Feb2023>>

    //B2BSSD07Feb2023 Import Start >>
    local procedure FixedAssetsReadExcelSheet()
    var
        FileManagement: Codeunit "File Management";
        Istream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(uplodMsg, '', '', FromFile, Istream);
        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(Istream)
        end else
            Error(NoFileMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(Istream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    procedure GetCellValue(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value As Text")
        else
            exit('');
    end;

    procedure FixedAssetsImportExcelData()
    var
        PurchaseLine: Record "Purchase Line";
        purChaseLine1: Record "Purchase Line";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRow: Integer;
        No: code[20];
        //Quantity: Integer;
        //DirectUnitCost: Decimal;
        SerialNo: Code[50];
        ModelNo: Code[50];
        Make: Code[50];
        DepreciationBookCode: Code[30];
        PostingGroup: Code[30];
        GenProdPostingGroup: Code[50];
        GSTGroupCode: Code[50];
        HSNSACCode: Code[20];
        GSTCredit: Enum "GST Credit";
        SourceType: Text[20];
        FAPostingType: Option ,"Acquisition Cost",Maintenance,Appreciation;
        location: Text[50];
        GenBusPostingGroup: Code[30];

    begin
        RowNo := 0;
        ColNo := 0;
        LineNo := 0;
        MaxRow := 0;
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."Document No.");
        if PurchaseLine.FindLast() then
            LineNo := PurchaseLine."Line No."
        else
            //LineNo := 10000;
            TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRow := TempExcelBuffer."Row No.";
        end;
        for RowNo := 2 to MaxRow Do begin
            Evaluate(SourceType, GetCellValue(RowNo, 1));
            Evaluate(No, GetCellValue(RowNo, 2));
            //Evaluate(Quantity, GetCellValue(RowNo, 3));
            //Evaluate(DirectUnitCost, GetCellValue(RowNo, 3));
            Evaluate(SerialNo, GetCellValue(RowNo, 3));
            Evaluate(ModelNo, GetCellValue(RowNo, 4));
            Evaluate(Make, GetCellValue(RowNo, 5));
            Evaluate(GSTGroupCode, GetCellValue(RowNo, 6));
            Evaluate(HSNSACCode, GetCellValue(RowNo, 7));
            Evaluate(GSTCredit, GetCellValue(RowNo, 8));
            Evaluate(location, GetCellValue(RowNo, 9));

            PurchaseLine.Init();
            LineNo += 10000;
            PurchaseLine."Document No." := Rec."Document No.";
            PurchaseLine."Document Type" := Rec."Document Type";
            PurchaseLine."Line No." := LineNo;
            PurchaseLine.Insert();
            Evaluate(PurchaseLine.Type, SourceType);
            PurchaseLine.Validate("No.", No);
            PurchaseLine.Validate(Quantity, 1);
            PurchaseLine.Validate("Unit of Measure", 'Pieces');
            //PurchaseLine."Unit of Measure" := 'Pieces';
            PurchaseLine."Serial No." := SerialNo;
            PurchaseLine."Model No." := ModelNo;
            PurchaseLine.Make_B2B := Make;
            PurchaseLine."GST Group Code" := GSTGroupCode;
            PurchaseLine."HSN/SAC Code" := HSNSACCode;
            PurchaseLine."GST Credit" := GSTCredit;
            PurchaseLine."Location Code" := location;

            if PurchaseLine."Indent No." = '' then
                PurchaseLine."Indent No." := IndentNo;
            if PurchaseLine."Indent Req No" = '' then
                PurchaseLine."Indent Req No" := IndetReqNo;
            if PurchaseLine."Shortcut Dimension 1 Code" = '' then
                PurchaseLine.Validate("Shortcut Dimension 1 Code", ShortcutDimension1);
            if PurchaseLine."Shortcut Dimension 2 Code" = '' then
                PurchaseLine.Validate("Shortcut Dimension 2 Code", ShortCutDimension2);
            if PurchaseLine."Shortcut Dimension 9 Code" = '' then
                PurchaseLine.Validate("Shortcut Dimension 9 Code", ShortCutDimention9);
            if PurchaseLine."Direct Unit Cost" = PurchaseLine."Direct Unit Cost" then
                PurchaseLine.Validate("Direct Unit Cost", DirectUnitCost);
            if PurchaseLine."Indentor Description" = '' then
                PurchaseLine."Indentor Description" := IndentorDescription;
            if PurchaseLine."Spec Id" = '' then
                PurchaseLine."Spec Id" := SpecID;
            PurchaseLine.Modify(true);
        end;
        Message(ExcelImportSuccess);
    end;
    //B2BSSD07Feb2023 Import End>>
}