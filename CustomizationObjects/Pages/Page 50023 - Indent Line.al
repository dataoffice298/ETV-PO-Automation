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

                    //B2BSSD13MARCH2024 >>

                    trigger OnValidate()
                    var
                        IndentHeaderL: Record "Indent Header";
                    begin
                        if IndentHeaderL.Get(Rec."Document No.") then begin
                            Rec."Issue Location" := IndentHeaderL."Delivery Location";
                            Rec."Issue Sub Location" := IndentHeaderL."Delivery Location";
                        end;
                    end;
                    //B2BSSD13MARCH2024 <<
                }
                field(Select; Rec.Select)//B2BSSD30Jan2023
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Spec Id"; rec."Spec Id")
                {
                    ApplicationArea = all;
                    Editable = FieldEditable;
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
                    // Editable = FieldEditable;
                    Editable = false; //B2BSCM07SEP2023
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    //Caption = 'Make';
                    ApplicationArea = All;
                    // Editable = FieldEditable;
                    Editable = false;
                }
                //B2B
                field("Variant Description"; "Variant Description")
                {
                    Caption = 'Variant Description';
                    ApplicationArea = All;
                    Editable = FieldEditable; //B2B22AUG2023
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    Editable = false;
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
                    // Editable = FieldEditable;
                    Editable = false;//B2BSCM30AUG2023
                }
                field("Avail/UnAvail"; Rec."Avail/UnAvail")//B2BSSD02AUG2023
                {
                    ApplicationArea = All;
                    Caption = 'Avail/UnAvail';
                    Editable = false;
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
                    Editable = FieldEditable; //B2BSCM21AUG2023
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable; //B2BSCM21AUG2023
                }
                field("Indent Status"; rec."Indent Status")
                {
                    ApplicationArea = All;
                    Editable = FieldEditable; //B2BSCM21AUG2023
                }
                field(Remarks; rec.Remarks)
                {
                    ApplicationArea = All;
                    Editable = FieldEditable; //B2BSCM21AUG2023
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = FieldEditable; //B2BSCM21AUG2023
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = FieldEditable; //B2BSCM21AUG2023
                }
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")//B2BSSD20Feb2023
                {
                    ApplicationArea = All;
                    Caption = 'Shortcut Dimension 9 Code';
                    Editable = FieldEditable; //B2BSCM21AUG2023
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Project Code';
                    Editable = false;
                }
                field("Qty To Issue"; Rec."Qty To Issue")
                {
                    ApplicationArea = all;
                    Caption = 'Qty. to Issue';
                    //Editable = FieldEditable; //B2BSCM21AUG2023
                    trigger OnValidate()
                    begin
                        if (Rec."ShortClose Status" = Rec."ShortClose Status"::ShortClose) OR (Rec."ShortClose Status" = Rec."ShortClose Status"::Cancel) then
                            Error(TextLbl, Rec."Line No.", Rec."ShortClose Status");
                    end;
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
                    //Editable = FieldEditable; //B2BSCM21AUG2023 //B2BVCOn01Feb2024 Comment
                    trigger OnValidate()
                    begin
                        Rec.CalcFields("Qty Issued");
                        if Rec."Req.Quantity" = Abs(Rec."Qty Issued") then begin
                            if Rec."ShortClose Status" = Rec."ShortClose Status"::" " then begin
                                Rec.Closed := true;
                                Rec."ShortClose Status" := Rec."ShortClose Status"::Closed;
                            end;
                        end;
                    end;
                }
                field("Archive Indent"; "Archive Indent")
                {
                    ApplicationArea = all;
                    Caption = 'Archive Indent';
                    Editable = false;
                }
                //B2BVCOn17Jun2024 >>
                field(ShortClose; Rec.ShortClose)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CancelIndent; Rec.CancelIndent)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("ShortClose Status"; Rec."ShortClose Status")
                {
                    ApplicationArea = All;
                }
                //B2BVCOn17Jun2024 <<
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
                        ItemJournalLine.SetRange("Indent Line No.", Rec."Line No.");
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
                        ItemJournalLine.SetRange("Indent Line No.", Rec."Line No.");
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

                //B2BVCOn17Jun2024 >>
                action("ShortClose IndentDoc")
                {
                    ApplicationArea = All;
                    Caption = 'ShortClose';
                    Image = PostOrder;
                    ToolTip = 'Short Close the order based on Qty Issued';
                    trigger OnAction()
                    begin
                        ShortCloseIndent();
                    end;
                }
                action("Cancle IndentDoc")
                {
                    ApplicationArea = All;
                    Caption = 'Cancle Indent';
                    Image = CancelLine;
                    trigger OnAction()
                    begin
                        CancleIndentDoc();
                    end;

                }
                //B2BVCOn17Jun2024 <<
            }
            //B2BSSD02MAR2023<<
            group("NRGP/RGP")
            {
                Caption = 'NRGP/RGP';
                action(CreateRPGInward)
                {
                    Caption = 'Create RGP Inward';
                    Image = CreateDocument;
                    trigger OnAction()
                    var
                        Errorinward: TextConst ENN = 'Type must Be Item Or Fixed Asset';
                        Errorinward1: TextConst ENN = 'You cant create Inward More then qty Issued';
                        Errorinward2: Label 'You cannot create RGP In from this indent';//B2BSCM25AUG2023
                        PostedRGPOutEntries: Record "Posted Gate Entry Header_B2B";
                        PostedRGPOutEntriesLine: Record "Posted Gate Entry Line_B2B";
                        IndentLIne: record "Indent Line";
                        IndentLIne1: record "Indent Line";//B2BSCM06SEP2023
                    begin
                        permissionRGPInward(); //B2BSCM24AUG2023
                        // if Rec.Type = Rec.Type::Item then
                        //     Rec.TestField(Select, true);
                        // if Rec.Type = Rec.Type::"Fixed Assets" then begin
                        //     Rec.TestField(Acquired, true);
                        //     Rec.TestField("Avail/UnAvail", true);
                        // end;

                        // Rec.TestField(Select, true);//B2BSSD13APR2023
                        //B2BSCM25AUGug2023>>
                        IndentLIne.Reset();
                        IndentLIne.SetRange("Document No.", IndentLIne1."Document No.");//B2BSCM06SEP2023
                        IndentLIne.SetRange(Type, IndentLIne.Type::"Fixed Assets");//B2BSCM06SEP2023
                        IndentLIne.SetRange(Select, true); //B2BSCM30AUG2023
                        if IndentLIne.FindFirst() then
                            repeat
                                PostedRGPOutEntriesLine.Reset();
                                PostedRGPOutEntriesLine.SetRange("Source No.", IndentLIne."No.");//B2BSCM06SEP2023
                                PostedRGPOutEntriesLine.SetRange("Source Type", PostedRGPOutEntriesLine."Source Type"::"Fixed Asset");
                                if PostedRGPOutEntriesLine.FindLast() then begin
                                    PostedRGPOutEntries.Reset();
                                    PostedRGPOutEntries.SetRange("No.", PostedRGPOutEntriesLine."Gate Entry No.");
                                    if PostedRGPOutEntries.FindFirst() then
                                        if PostedRGPOutEntries."Indent Document No" <> Rec."Document No." then
                                            Error(Errorinward2);
                                end;
                            until IndentLIne.Next() = 0;
                        //B2BSCM25AUG2023<<
                        IndentLine.Reset();//B2BSSD02AUG2023
                        IndentLine.SetRange("Document No.", Rec."Document No.");//B2BSCM06SEP2023
                        IndentLine.SetRange(Type, IndentLine.Type::Item);//B2BSCM06SEP2023
                        IndentLine.SetRange(Select, true);//B2BSCM23AUG2023
                        if IndentLine.FindSet() then begin
                            repeat
                                IndentLine.CalcFields("Qty Returned");
                                IndentLine.TestField("Qty Returned");
                                indentLine.CalcFields("Qty Returned", "Qty Issued");
                                if IndentLine."Qty Returned" > Abs(IndentLine."Qty Issued") then
                                    Error(Errorinward1);
                            until IndentLine.Next() = 0;
                        end;


                        IndentLine.Reset();//B2BSSD02AUG2023
                        IndentLine.SetRange("Document No.", Rec."Document No.");
                        IndentLine.SetRange(Select, true);
                        IndentLine.SetRange(Type, Rec.Type::Description);
                        if IndentLine.FindSet() then
                            Error(Errorinward);

                        CreateRGPfromIndent(GateEntryType::Inward, GateEntryDocType::RGP);
                        IndentLine."Avail/UnAvail" := false;
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
                        indentLine1: Record "Indent Line";//B2BSCM05SEP2023
                        FixedAsset: Record "Fixed Asset";
                        ERRORmsg: Label 'Fixed Assets is Not Available for Transfer';
                        ErrorOutward: TextConst ENN = 'Type must Be Item Or Fixed Asset';
                        ErrorOutward1: TextConst ENN = 'Quantity Issed Must Have a Values';
                        ErrorOutward2: TextConst ENN = 'You cant create Outward More then qty Issued';
                    begin
                        permissionRGPOutward(); //B2BSCM24AUG2023
                        indentLine.Reset();//B2BSSD10AUG2023
                        indentLine.SetRange("Document No.", Rec."Document No.");
                        indentLine.SetRange(Select, true);
                        indentLine.SetRange(Type, Rec.Type::Item);
                        if indentLine.FindSet() then begin //B2BSCM05SEP2023
                            repeat
                                indentLine.TestField("Issue Location");//B2BSCM05SEP2023
                                indentLine.TestField("Issue Sub Location");//B2BSCM05SEP2023
                                //B2BSSD26APR2023>>
                                indentLine.CalcFields("Qty Issued");
                                if indentLine."Qty Issued" = 0 then
                                    Error(ErrorOutward1);
                            until indentLine.Next() = 0;
                        end;

                        IndentLine.Reset();//B2BSSD02AUG2023
                        IndentLine.SetRange("Document No.", Rec."Document No.");
                        IndentLine.SetRange(Select, true);
                        IndentLine.SetRange(Type, Rec.Type::Description);
                        if IndentLine.FindSet() then
                            Error(ErrorOutward);

                        indentLine.Reset();//B2BSSD03AUG2023
                        indentLine.SetRange("Document No.", Rec."Document No.");
                        if indentLine.FindSet() then begin
                            repeat
                                indentLine.CalcFields("Qty Issued");
                                if indentLine."Req.Quantity" < Abs(indentLine."Qty Issued") then
                                    Error(ErrorOutward2);
                            until indentLine.Next() = 0;
                        end;
                        GateEntryHeaderOutwardGvar.Reset();//B2BSSD03AUG2023
                        GateEntryHeaderOutwardGvar.SetRange("Indent Document No", Rec."Document No.");
                        GateEntryHeaderOutwardGvar.SetRange("Indent Line No", Rec."Line No.");//B2BSCM23AUG2023
                        if GateEntryHeaderOutwardGvar.FindFirst() then
                            Error('Rgp Outward Already Created');

                        if indentLine.Type = indentLine.Type::"Fixed Assets" then begin//B2BSCM05SEP2023
                            repeat
                                indentLine.TestField(Acquired, true);//B2BSCM05SEP2023
                            // Rec.TestField(Select, true);
                            until indentLine.Next() = 0;//B2BSCM05SEP2023
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
                        ErrorNRGPOutward: TextConst ENN = 'Type must Be Item Or Fixed Asset';
                    begin
                        PermissionOfNRGP();//B2BSCM23AUG2023
                        IndentLine.Reset();//B2BSSD02AUG2023
                        IndentLine.SetRange("Document No.", Rec."Document No.");
                        IndentLine.SetRange(Select, true);
                        IndentLine.SetRange(Type, Rec.Type::Description);
                        if IndentLine.FindSet() then
                            Error(ErrorNRGPOutward);

                        if Rec.Type = Rec.Type::Item then begin
                            Rec.TestField(Select, true);
                            Rec.TestField("Qty Issued");
                        end;

                        if Rec.Type = Rec.Type::"Fixed Assets" then begin
                            //B2BSSD21APR2023>>
                            indentLine.Reset();
                            indentLine.SetRange("Document No.", Rec."Document No.");
                            indentLine.SetRange("Line No.", Rec."Line No.");
                            if indentLine.FindSet() then begin
                                repeat
                                    IndentLine.TestField(Acquired, true);
                                    IndentLine.TestField(Select, true);
                                    if indentLine."Avail/UnAvail" = true then
                                        Error(ERRORmsg);
                                until indentLine.Next() = 0;
                            end;
                            //B2BSSD21APR2023<<
                        end;
                        CreateRGPfromIndent(GateEntryType::Outward, GateEntryDocType::NRGP);
                    end;
                }
                //B2BSSD09MAR2023>>

                //B2BSSD02MAR2023>>

                //B2BSSD14MAR2023<<
                action(FromIndOpenRGPGateEntries)
                {
                    ApplicationArea = All;
                    Image = Open;
                    Caption = 'RGP Inward/Outward Entries';
                    trigger OnAction()
                    var
                        GateEntryHdr: Record "Gate Entry Header_B2B";
                    begin
                        GateEntryHdr.Reset();
                        GateEntryHdr.FilterGroup(2);
                        GateEntryHdr.SetRange("Indent Document No", Rec."Document No.");
                        GateEntryHdr.SetRange("Indent Line No", Rec."Line No.");
                        GateEntryHdr.SetRange(Type, GateEntryHdr.Type::RGP);//B2BSSD10AUG2023
                        GateEntryHdr.FilterGroup(0);
                        Page.RunModal(Page::"Gate Entry List", GateEntryHdr);
                    end;
                }
                action(FromIndOpenNRGPGateEntries)//B2BSSD10AUG2023
                {
                    ApplicationArea = All;
                    Image = Open;
                    Caption = 'NRGP Inward/Outward Entries';
                    trigger OnAction()
                    var
                        GateEntryHdr: Record "Gate Entry Header_B2B";
                    begin
                        GateEntryHdr.Reset();
                        GateEntryHdr.FilterGroup(2);
                        GateEntryHdr.SetRange("Indent Document No", Rec."Document No.");
                        GateEntryHdr.SetRange("Indent Line No", Rec."Line No.");
                        GateEntryHdr.SetRange(Type, GateEntryHdr.Type::NRGP);
                        GateEntryHdr.FilterGroup(0);
                        Page.RunModal(Page::"Gate Entry List", GateEntryHdr);
                    end;
                }

                action(FromIndOpenPostedRGPGateEntries)
                {
                    ApplicationArea = All;
                    Image = History;
                    Caption = 'Posted RGP Inward/Outward Entries';
                    trigger OnAction()
                    var
                        PostedGateEntryHdr: Record "Posted Gate Entry Header_B2B";
                    begin
                        PostedGateEntryHdr.Reset();
                        PostedGateEntryHdr.FilterGroup(2);
                        PostedGateEntryHdr.SetRange("Indent Document No", Rec."Document No.");
                        // PostedGateEntryHdr.SetRange("Indent Line No", Rec."Line No.");
                        PostedGateEntryHdr.SetRange(Type, PostedGateEntryHdr.Type::RGP);
                        PostedGateEntryHdr.FilterGroup(0);
                        Page.RunModal(Page::"Posted Gate Entries List", PostedGateEntryHdr);
                    end;
                }

                action(FromIndOpenPostedNRGPGateEntries)//B2BSSD10AUG2023
                {
                    ApplicationArea = All;
                    Image = History;
                    Caption = 'Posted NRGP Inward/Outward Entries';
                    trigger OnAction()
                    var
                        PostedGateEntryHdr: Record "Posted Gate Entry Header_B2B";
                    begin
                        PostedGateEntryHdr.Reset();
                        PostedGateEntryHdr.FilterGroup(2);
                        PostedGateEntryHdr.SetRange("Indent Document No", Rec."Document No.");
                        PostedGateEntryHdr.SetRange("Indent Line No", Rec."Line No.");
                        PostedGateEntryHdr.SetRange(Type, PostedGateEntryHdr.Type::NRGP);
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
        indentLine1: Record "Indent Line"; //B2BSCM29AUG2023
        PostedGEH: Record "Posted Gate Entry Header_B2B";

    begin
        //B2BSSD17APR2023>>
        indentLine.Reset();
        indentLine.SetRange("Document No.", Rec."Document No.");
        indentLine.SetRange("Release Status", Rec."Release Status"::Released);
        if not indentLine.FindSet() then
            Error('Status Must Be equals to Release');
        //B2BSSD17APR2023<<
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
            repeat  //B2BSCM28AUG2023
                if indentLine.Select = true then begin //B2BSCM30AUG2023
                    GateEntryLine.Init();
                    GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                    GateEntryLine.Type := GateEntryHeader.Type;
                    GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                    GateEntryLine."Line No." := LineNo;
                    GateEntryLine.Insert(true);
                    if (IndentLine.Type = IndentLine.Type::Item) then begin
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
                    if GateEntryLine."Entry Type" = GateEntryLine."Entry Type"::Outward then begin
                        indentLine.CalcFields("Qty Issued");//B2BSSD28APR2023
                        GateEntryLine.Quantity := Abs(indentLine."Qty Issued");
                    end else
                        if GateEntryLine."Entry Type" = GateEntryLine."Entry Type"::Inward then begin
                            indentLine.CalcFields("Qty Returned");
                            GateEntryLine.Quantity := Abs(indentLine."Qty Returned");
                        end;

                    if indentLine.Type = indentLine.Type::"Fixed Assets" then begin//B2BSSD10AUG2023
                        GateEntryLine.Quantity := indentLine."Req.Quantity";
                    end;
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


                    if indentLine.Type = indentLine.Type::Item then
                        indentLine."Qty To Issue" := 0;
                    indentLine."Qty To Return" := 0;
                    indentLine.Modify();

                    //B2BSCM29AUG2023>>
                    indentLine1.Reset();
                    indentLine1.SetRange("No.", GateEntryLine."Source No.");
                    indentLine1.SetRange(Type, Rec.Type::"Fixed Assets");
                    if indentLine1.FindFirst() then begin
                        if GateEntryLine."Entry Type" = GateEntryLine."Entry Type"::Outward then
                            indentLine1."Avail/UnAvail" := true
                        else
                            if GateEntryLine."Entry Type" = GateEntryLine."Entry Type"::Inward then
                                indentLine1."Avail/UnAvail" := false;
                        indentLine1.Modify(); //B2BSCM29AUG2023<<
                    end;
                end;//B2BSCM30AUG2023
            until indentLine.Next() = 0; //B2BSCM28AUG2023
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
        if (IndentHdr."Released Status" = IndentHdr."Released Status"::Released) then begin
            FieldEditable := false;
        end
        else begin
            FieldEditable := true;
        end;

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
        if rec."Qty To Issue" = 0 then
            Rec.QTyToIssueEditable := true;
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

        GateEntryHeaderOutwardGvar: Record "Gate Entry Header_B2B";
        TextLbl: Label 'Qty To Issue not allowed, Line No. %1 already %2.';
    //B2BSSD03AUG2023>>
    procedure QTyToIssueNonEditable()
    begin
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."Document No.");
        if IndentLine.FindSet() then begin
            repeat
                if IndentLine."Qty To Issue" = 0 then
                    IndentLine.QTyToIssueEditable := true
                else
                    IndentLine.QTyToIssueEditable := false;
                IndentLine.Modify();
            until IndentLine.Next() = 0;
        end;
    end;
    //SSD03AUG2023<<

    local procedure ShortCloseIndent()
    var
        ConfirmText: Label 'Do you want to Short Close the Indent No. %1 and Line No. %2 ?';
        NotApplicableErr: Label 'Indent Line No. %1 can not be Shortclosed, Req.Qty and Qty Issue is same';
        SuccessMsg: Label 'Indent Doucument No. %1 and Line No. %2 is Short Closed';
        ShortClosed: Boolean;
        AlredyShortclose: Label 'Indent Document  %1 is already shortclosed';
    begin
        if Rec.ShortClose then
            Error(AlredyShortclose, Rec."Document No.");
        Rec.TestField("Qty Issued");
        if Rec."Req.Quantity" = Abs(Rec."Qty Issued") then
            Error(NotApplicableErr, Rec."Line No.");
        if not Confirm(StrSubstNo(ConfirmText, Rec."Document No.", Rec."Line No."), false) then
            exit;

        Rec.ShortClose := true;
        if Rec."ShortClose Status" = Rec."ShortClose Status"::" " then
            Rec."ShortClose Status" := Rec."ShortClose Status"::ShortClose;
        Rec."ShortClose Qty" := Rec."Req.Quantity" - Abs(Rec."Qty Issued");
        Rec."Req.Quantity" := Abs(Rec."Qty Issued");
        Rec."ShortClosed By" := UserId;
        Rec."ShortClose Date & Time" := CurrentDateTime;
        Rec.Modify();
        if Rec.ShortClose then
            Message(SuccessMsg, Rec."Document No.", Rec."Line No.");
    end;

    local procedure CancleIndentDoc()
    var
        ConfirmText: Label 'Do you want to Cancelled the Indent Doc No. %1 and Line No. %2?';
        AlredyCancelledOrder: Label 'Indent Document  %1 is already Cancelled';
        SuccessMsg: Label 'Indent Document No. %1 and Line No. %2 is Cancelled';
        ErrorMsg: Label 'Qty Issued Must be Zero, Document No. %1, Line No. %2';
    begin
        if Rec.CancelIndent then
            Error(AlredyCancelledOrder, Rec."Document No.");
        if not Confirm(StrSubstNo(ConfirmText, Rec."Document No.", Rec."Line No."), false) then
            exit;
        if Abs(Rec."Qty Issued") <> 0 then
            Error(ErrorMsg, Rec."Document No.", Rec."Line No.");

        if Abs(Rec."Qty Issued") = 0 then begin
            Rec.CancelIndent := true;
            if Rec."ShortClose Status" = Rec."ShortClose Status"::" " then
                Rec."ShortClose Status" := Rec."ShortClose Status"::Cancel;
            Rec.Modify;
        end;
        if Rec.CancelIndent then
            Message(SuccessMsg, Rec."Document No.", Rec."Line No.");
    end;
}