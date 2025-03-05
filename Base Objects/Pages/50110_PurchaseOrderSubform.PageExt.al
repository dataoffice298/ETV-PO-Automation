pageextension 50110 PurchaseOrderSubform1 extends "Purchase Order Subform"
{
    //B2BVCOn03Oct22>>>
    layout
    {

        moveafter("No."; Description)
        moveafter(Description; Quantity)
        moveafter(Quantity; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Direct Unit Cost")
        movebefore("Item Reference No."; "Line Amount")
        moveafter("Line Amount"; "GST Group Code")
        moveafter("GST Group Code"; "HSN/SAC Code")
        moveafter("HSN/SAC Code"; "GST Credit")
        moveafter("GST Credit"; "GST Assessable Value")
        moveafter("GST Assessable Value"; "Variant Code")
        movebefore("Item Reference No."; "Quantity Received")
        movebefore("Item Reference No."; "Quantity Invoiced")

        addafter(Description)
        {
            field("Spec Id"; rec."Spec Id")
            {
                ApplicationArea = all;
                //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
                trigger OnValidate()
                var
                    myInt: Integer;
                    userSetup: Record "User Setup";
                    Text0001: Label 'You dont have permessions for entering Specifications';
                begin


                    if userSetup.Get(UserId) and (userSetup.Specifications = false) then
                        Error(Text0001);

                end;

            }
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
        addafter(Control1)
        {
            field("FA Posting Type"; Rec."FA Posting Type")
            {
                ApplicationArea = All;

            }
        }
        //B2BSSD16FEB2023<<
        // addafter("Item Reference No.")
        // {
        //     field("Depreciation Book Code"; Rec."Depreciation Book Code")
        //     {
        //         ApplicationArea = All;
        //     }
        // }
        // addafter("Depreciation Book Code")
        // {
        //     field("Posting Group"; Rec."Posting Group")
        //     {
        //         ApplicationArea = All;
        //         Editable = true;
        //     }
        // }
        //B2BSSD16FEB2023>>
        addafter("Quantity Invoiced")//B2BSSD15FEB2023
        {
            field("Indentor Description"; Rec."Indentor Description")//B2BSSD02Feb2023
            {
                ApplicationArea = All;
                Editable = FieldEditableVar1;
            }

            field(CWIP; Rec.CWIP)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the CWIP field.';
                Caption = 'CWIP';
            }

        }
        addafter("Location Code")
        {
            field("Sub Location Code"; Rec."Sub Location Code")
            {
                ApplicationArea = All;
            }
        }
        //B2BVCOn07Aug2024 >>
       /*  modify(Type)
        {
            Editable = FieldEditableVar1;
        }
        modify("No.")
        {
            Editable = FieldEditableVar1;
        }
        modify(Description)
        {
            Editable = FieldEditableVar1;
        }
        modify(Quantity)
        {
            Editable = FieldEditableVar1;
        }
        modify("Unit of Measure Code")
        {
            Editable = FieldEditableVar1;
        }
        modify("GST Credit")
        {
            Editable = FieldEditableVar1;
        }
        modify("Location Code")
        {
            Editable = FieldEditableVar1;
        }
        modify("Qty. to Invoice")
        {
            Editable = FieldEditableVar1;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = FieldEditableVar1;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = FieldEditableVar1;
        }
        modify("Unit Price (LCY)")
        {
            Editable = FieldEditableVar1;
        } */
        //B2BVCOn07Aug2024 <<

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

            field("Qty. to Reject B2B"; Rec."Qty. to Reject B2B")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    myInt: Integer;
                    userSetup: Record "User Setup";
                    Text0001: Label 'You dont have permessions for entering Accept/Reject values';
                begin


                    if userSetup.Get(UserId) and (userSetup."Accept/Reject" = false) then
                        Error(Text0001);

                end;
            }
            field("Rejection Comments B2B"; rec."Rejection Comments B2B")
            {
                Caption = 'Rejection Comments';
                ApplicationArea = all;
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
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Caption = 'Project Code';
                //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
                //Visible = false; //B2BKM25APR2024
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
                //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
            }
        }
        //B2BSSD14MAR2023<<
        addafter("GST Assessable Value")
        {
            field("Variant Code1"; Rec."Variant Code")
            {
                ApplicationArea = All;
                Caption = 'Variant Code';
            }
            field("Variant Description"; Rec."Variant Description") //B2BSCM11JAN2024
            {
                ApplicationArea = All;
                Editable = FieldEditableVar1;
            }
        }
        addafter("Direct Unit Cost")
        {
            field("LineDiscount %"; Rec."Line Discount %")
            {
                ApplicationArea = All;
                Caption = 'Line Discount %';
            }
        }
        /* modify("Direct Unit Cost")
        {
            Editable = FieldEditableVar1; //B2BVCOn07Aug2024
        } */
        modify("Variant Code")
        {
            Editable = FieldEditable1; //B2BVCOn07Aug2024
        }
        //B2BSSD14MAR2023>>
        addafter("Quantity Received")//B2BSSD15MAY2023
        {
            field("Qty to Inward_B2B"; Rec."Qty to Inward_B2B")
            {
                ApplicationArea = All;
                caption = 'Qty to Inward';
                //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
            }
            field("Qty. to Accept B2B"; Rec."Qty. to Accept B2B")
            {
                ApplicationArea = All;
                //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
                trigger OnValidate()
                var
                    myInt: Integer;
                    userSetup: Record "User Setup";
                    PostedGateEntryLine: Record "Posted Gate Entry Line_B2B";
                    Text0001: Label 'You dont have permessions for entering Accept/Reject values';
                    Text002: label 'Gate Entry Inward Must be Created.';
                    Text003: Label 'Qty. To Accept Exceeded than Inward Quantity.';
                begin
                    if userSetup.Get(UserId) and (userSetup."Accept/Reject" = false) then
                        Error(Text0001);

                    //B2BVCOn28Jun2024 >>
                    if not (Rec.Select) then
                        Error(Text002);
                    if (Rec.Select) And (Rec."Posted Gate Entry No." <> '') And (Rec.Inward = false) then
                        Error(Text002);

                    PostedGateEntryLine.Reset();
                    PostedGateEntryLine.SetRange("Gate Entry No.", Rec."Posted Gate Entry No.");
                    PostedGateEntryLine.SetRange("Line No.", Rec."Posted Gate Entry Line No.");
                    if PostedGateEntryLine.FindFirst() then begin
                        if Rec."Qty. to Accept B2B" > PostedGateEntryLine.Quantity then
                            Error(Text003);
                    end;

                    //B2BVCOn28Jun2024 <<

                end;
            }
            field("Quantity Accepted B2B"; Rec."Quantity Accepted B2B")
            {
                ApplicationArea = All;
            }
        }

        //B2BSSD16MAY2023>>
        addafter("Quantity Rejected B2B")
        {
            field("Qty Rejected OutWard_B2B"; Rec."Qty Rejected OutWard_B2B")
            {
                ApplicationArea = All;
                caption = 'Qty Rejected OutWard';
            }
        }
        addafter("Qty Rejected OutWard_B2B")
        {
            field("NRGP OutWard Qty B2B"; Rec."NRGP OutWard Qty B2B")
            {
                ApplicationArea = All;
                caption = 'NRGP OutWard Qty';
            }
        }
        //B2BSSD16MAY2023<<
        addafter("Gen. Prod. Posting Group")
        {
            field("Depreciation Book Code"; Rec."Depreciation Book Code")
            {
                ApplicationArea = All;
                //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
            }
            field("Posted Gate Entry No."; Rec."Posted Gate Entry No.")
            {
                ApplicationArea = All;
                Caption = 'RGP Inward No.';
            }
            field("Posted Gate Entry Line No."; Rec."Posted Gate Entry Line No.")
            {
                ApplicationArea = All;
                Caption = 'RGP Inward Line No.';
            }
            field("RGP OutWard No."; Rec."RGP OutWard No.")
            {
                ApplicationArea = All;
                Caption = 'RGP Outward No.';
                Editable = false;
            }
            field("Short Close Quantity"; Rec."Short Close Quantity")
            {
                Caption = 'Short Closed Quantity';
                ApplicationArea = all;
                Editable = false;
            }
            field("Short Closed by"; Rec."Short Closed by")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Short Closed Date & Time"; Rec."Short Closed Date & Time")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(ShortClosed; Rec.ShortClosed)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(CancelOrder; Rec.CancelOrder)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        //B2BSCM11SEP2023>>
        modify("GST Group Code")
        {
            ShowMandatory = true;
            //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
        }
        modify("HSN/SAC Code")
        {
            ShowMandatory = true;
            //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
        }
        //B2BSCM11SEP2023<<

        modify("Qty. to Receive")
        {
            //Editable = FieldEditableVar1; //B2BVCOn07Aug2024
            trigger OnBeforeValidate()
            begin
                if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    if UserSetup.Get(PurchHeader."User ID") and not (UserSetup.Stores) then
                        Error('Qty.to Receive field must be Modify only the user Qty.to Return and Qty.to Receive must be true');
                end;

            end;
        }
        modify(ShortcutDimCode3) //B2BKM24APR2024
        {
            Visible = false;
        }
        /*  modify(Type)
         {
             trigger OnAfterValidate()
             var
                 myInt: Integer;
             begin
                 if Rec.Type = Rec.Type::Description then
                     Rec."No." := '01'
                 Else
                     exit;
             end;
         } */
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
                Enabled = FieldEditable; //B2BVCOn14Nov2023

                trigger OnAction()
                var
                    TrackImport: Report "Purchase Line Tracking Import";
                begin

                    if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                        if UserSetup.Get(PurchHeader."User ID") and not (UserSetup.Stores) then
                            Error(Text0005);
                    end;

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
                            PurchLineLRec: Record "Purchase Line";
                            //B2BKM2MAY2024 <<
                            UserSetup: Record "User Setup";
                            Email: Codeunit Email;
                            EmailMessage: Codeunit "Email Message";
                            Recipiants: Text;
                            CCRecipiants: List of [Text];
                            BCCRecipients: List of [Text];
                            Body: Text;
                            Sub: Label 'Quality Alert to Indent and Indent approver';
                            ApprovalEntryLRec: Record "Approval Entry";
                            GateEntryHeader: Record "Gate Entry Header_B2B";
                            Text001: Label 'Dear Sir/Madam, Please find Indent Number:  %1 dt.%2 is raised for the purpose %3.Material is received against PO Number.%4 Dt.%5 is waiting for Quality Inspection.Please approve the same for further process of Invoice.';
                            IndentHeader: Record "Indent Header";
                            UserSetupRec: Record "User Setup";
                        //B2BKM2MAY2024 >>
                        begin
                            PurchLineLRec.Reset();
                            PurchLineLRec.SetRange("Document No.", "Document No.");
                            PurchLineLRec.SetRange(Select, true);
                            if PurchLineLRec.FindSet() then begin
                                repeat
                                    //B2BSSD15MAY2023>>
                                    if PurchLineLRec.Quantity = PurchLineLRec."Quantity Accepted B2B" then
                                        Error('Rgp Inward Already Created');
                                    PurchLineLRec.TestField("Qty to Inward_B2B");
                                until PurchLineLRec.Next() = 0;
                            end;                                    //B2BSSD15MAY2023<<

                            //B2BSSDJan2023<<
                            PurChaseHeader.Reset();
                            PurChaseHeader.SetRange("No.", Rec."Document No.");
                            if PurChaseHeader.FindFirst() then begin
                                PurChaseHeader.TestField("Import Type");
                                PurChaseHeader.TestField("EPCG Scheme");//B2BSSD20MAR2023
                            end;
                            //B2BSSDJan2023>>
                            CreateGateEntries(GateEntryType::Inward, GateEntryDocType::RGP);
                            //B2BKM2MAY2024 <<
                            if Rec."Indent No." <> '' then begin //B2BKM6MAY2024
                                GateEntryHeader.Reset();
                                GateEntryHeader.SetRange("Indent Document No", Rec."Indent No.");
                                GateEntryHeader.SetRange("Purchase Order No.", Rec."Document No.");
                                if GateEntryHeader.FindSet() then begin
                                    if IndentHeader.Get(Rec."Indent No.") then begin
                                        if UserSetupRec.Get(IndentHeader."User Id") then begin
                                            UserSetupRec.TestField("E-Mail");
                                            if Recipiants <> '' then
                                                Recipiants += ';' + UserSetupRec."E-Mail"
                                            else
                                                Recipiants := UserSetupRec."E-Mail";
                                        end;
                                        ApprovalEntryLRec.Reset();
                                        ApprovalEntryLRec.SetRange("Document No.", IndentHeader."No.");
                                        if ApprovalEntryLRec.FindSet() then
                                            repeat
                                                if UserSetup.Get(ApprovalEntryLRec."Approver ID") then begin
                                                    UserSetup.TestField("E-Mail");
                                                    if Recipiants <> '' then
                                                        Recipiants += ';' + UserSetup."E-Mail"
                                                    else
                                                        Recipiants := UserSetup."E-Mail";
                                                end;
                                            until ApprovalEntryLRec.Next = 0;
                                    end;

                                    // CCRecipiants.Add(UserSetup."E-Mail");
                                    Body += StrSubstNo(Text001, Rec."Indent No.", IndentHeader."Document Date", IndentHeader.Purpose, Rec."Document No.", PurChaseHeader."Document Date");
                                    EmailMessage.Create(Recipiants, Sub, '', true);
                                    //EmailMessage.Create(Recipiants, Sub, '', true, CCRecipiants, BCCRecipients);
                                    EmailMessage.AppendToBody('Dear Sir/Madam,');
                                    EmailMessage.AppendToBody('<BR></BR>');
                                    EmailMessage.AppendToBody('<BR></BR>');
                                    EmailMessage.AppendToBody(Body);
                                    EmailMessage.AppendToBody('<BR></BR>');
                                    EmailMessage.AppendToBody('<BR></BR>');
                                    EmailMessage.AppendToBody('This is auto generated mail by system for approval information.');
                                    Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                                    Message('Email Send Successfully');
                                end;
                            end;
                        end;
                        //B2BKM2MAY2024 >>

                        //end;

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
                            Rec.TestField("Quantity Rejected B2B");//B2BSSD16MAY2023
                            Rec.TestField("Qty Rejected OutWard_B2B");//B2BSSD16MAY2023
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
                            GateEntryHdr1: Record "Gate Entry Header_B2B";
                            GateEntryLine: Record "Gate Entry Line_B2B";
                            I: Integer;
                            No: text[500];
                        begin
                            Clear(No);
                            i := 1;
                            GateEntryLine.Reset();
                            GateEntryLine.SetRange("Purchase Order No.", Rec."Document No.");
                            GateEntryLine.SetRange("Purchase Order Line No.", Rec."Line No.");
                            if GateEntryLine.FindSet() then
                                repeat
                                    if i = 1 then begin
                                        i := i + 1;
                                        No := GateEntryLine."Gate Entry No."
                                    end else
                                        No := No + '|' + GateEntryLine."Gate Entry No.";

                                until GateEntryLine.Next() = 0;

                            GateEntryHdr.Reset();
                            //GateEntryHdr.FilterGroup(2);
                            if No <> '' then
                                GateEntryHdr.SetFilter("No.", No)
                            else
                                GateEntryHdr.SetRange("No.", No);
                            // GateEntryHdr.SetRange("Purchase Order Line No.", Rec."Line No.");
                            // GateEntryHdr.FilterGroup(0);
                            //GateEntryHdr.FindSet();
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
                            PostedGateEntryLine: Record "Posted Gate Entry Line_B2B";
                            I: Integer;
                            No: text[500];
                        begin
                            Clear(No);
                            i := 1;
                            PostedGateEntryLine.Reset();
                            PostedGateEntryLine.SetRange("Purchase Order No.", Rec."Document No.");
                            PostedGateEntryLine.SetRange("Purchase Order Line No.", Rec."Line No.");
                            if PostedGateEntryLine.FindSet() then
                                repeat
                                    if i = 1 then begin
                                        No := PostedGateEntryLine."Gate Entry No.";
                                        i := i + 1;
                                    end else
                                        No := No + '|' + PostedGateEntryLine."Gate Entry No.";

                                until PostedGateEntryLine.Next() = 0;

                            PostedGateEntryHdr.Reset();
                            if No <> '' then
                                PostedGateEntryHdr.SetFilter("No.", No)
                            else
                                PostedGateEntryHdr.SetRange("No.", No);
                            // PostedGateEntryHdr.FilterGroup(2);
                            // PostedGateEntryHdr.SetFilter("No.", No);
                            // PostedGateEntryHdr.SetRange("Purchase Order No.", Rec."Document No.");
                            // PostedGateEntryHdr.SetRange("Purchase Order Line No.", Rec."Line No.");
                            //  PostedGateEntryHdr.FilterGroup(0);
                            Page.RunModal(Page::"Posted Gate Entries List", PostedGateEntryHdr);
                        end;
                    }
                }
            }
            //B2BMSOn03Nov2022<<
        }

        //B2BSSD07Feb2023 Fixed Assets functionality Start<<
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
                        PurchHeader1: Record "Purchase Header";
                        purchHeader2: Record "Purchase Header";
                        postedRgpInwardno: Record "Posted Gate Entry Header_B2B";//B2BSSD04APR2023
                    begin


                        //B2BSSD13MAR2023<< 
                        PurchHeader1.Reset();
                        PurchHeader1.SetRange("No.", Rec."Document No.");
                        if PurchHeader1.FindFirst() then begin
                            //B2BSSD21MAR2023<<
                            if PurchHeader1.Status = PurchHeader1.Status::Released then
                                PurchHeader1.Status := PurchHeader1.Status::Open;
                            PurchHeader1.Modify();
                            //B2BSSD21MAR2023>>
                        end;
                        //B2BSSD13MAR2023>>

                        postedRgpInwardno.Reset();
                        postedRgpInwardno.SetRange("Purchase Order No.", rec."Document No.");
                        if not postedRgpInwardno.FindFirst() then
                            Error(RGPError);

                        PurchaseLine1.Reset();
                        PurchaseLine1.SetRange("Document Type", Rec."Document Type");
                        PurchaseLine1.SetRange("Document No.", Rec."Document No.");
                        PurchaseLine1.SetRange(Select, true);
                        if not PurchaseLine1.FindFirst() then begin
                            Error('Please Select the Line to Import');
                        end;
                        // PurchaseLine1.Reset();
                        // PurchaseLine1.SetRange("Document Type", Rec."Document Type");
                        // PurchaseLine1.SetRange("Document No.", Rec."Document No.");
                        // PurchaseLine1.SetRange(Select, true);
                        // PurchaseLine1.SetFilter("No.", '%1', '');
                        //PurchaseLine1.DeleteAll();
                        FixedAssetsReadExcelSheet();
                        FixedAssetsImportExcelData();

                        //B2BSSD21MAR2023<<
                        purchHeader2.Reset();
                        purchHeader2.SetRange("No.", Rec."Document No.");
                        if purchHeader2.FindFirst() then begin
                            if purchHeader2.Status = purchHeader2.Status::Open then
                                purchHeader2.Status := PurchHeader1.Status::Released;
                            purchHeader2.Modify();
                        end;
                        //B2BSSD21MAR2023>>


                    end;

                }
            }
        }
        //B2BSSD07Feb2023 Fixed Assets functionality End>>

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
        modify(DocumentLineTracking)
        {
            trigger OnBeforeAction()
            begin
                if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    if UserSetup.Get(PurchHeader."User ID") THEN begin
                        IF (UserSetup.Stores = false) then
                            Error(Text0004);
                    END;
                end;
            end;
        }
        modify(CreateRGPInward)
        {
            trigger OnBeforeAction()
            var
                Text0003: Label 'You dont have Permessions to Open  CreateRGPInward';

            begin
                if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    if UserSetup.Get(PurchHeader."User ID") then begin
                        IF (UserSetup.Stores = false) then
                            Error(Text0003);
                    end;
                END;

            end;
        }

        modify(CreateRGPOutward)
        {
            trigger OnBeforeAction()
            var
                Text0002: Label 'You dont have Permessions to Open  CreateRGPOutward';

            begin
                if PurchHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                    if UserSetup.Get(PurchHeader."User ID") then begin
                        IF (UserSetup.Stores = false) then
                            Error(Text0002);
                    end;
                END;
            end;

        }
        modify(OrderTracking)
        {
            Enabled = FieldEditable; //B2BVCOn14Nov2023
        }
        addafter("&Line")
        {
            action("Short Close")
            {
                ApplicationArea = All;
                Ellipsis = true;
                Image = PostOrder;
                ToolTip = 'Short Close the order based on Qty Received and Invoiced';
                trigger OnAction()
                begin
                    ShortClose(); //B2BVCOn19Mar2024
                    if Rec.ShortClosed then begin
                        if IndentReqLine.Get(Rec."Indent Req No", Rec."Indent Req Line No") then begin
                            IndentReqLine.CalcFields("Received Quantity");
                            IndentReqLine."Qty. Ordered" := IndentReqLine."Received Quantity";
                            IndentReqLine.Validate("Remaining Quantity", (IndentReqLine.Quantity - IndentReqLine."Qty. Ordered"));
                            IndentReqLine."PO Vendor" := Rec."Buy-from Vendor No.";
                            IndentReqLine.Modify;
                        end;
                    end;

                end;
            }
            action("Cancel Order")
            {
                ApplicationArea = All;
                Ellipsis = true;
                Image = Cancel;
                trigger OnAction()
                begin
                    CancelOrder();
                    if Rec.CancelOrder then begin
                        if IndentReqLine.Get(Rec."Indent Req No", Rec."Indent Req Line No") then begin
                            IndentReqLine.CalcFields("Received Quantity");
                            IndentReqLine."Received Quantity" := 0;
                            IndentReqLine."Qty. Ordered" := IndentReqLine."Received Quantity";
                            IndentReqLine.Quantity := IndentReqLine."Remaining Quantity" + Rec.Quantity;
                            IndentReqLine.Validate("Remaining Quantity", IndentReqLine.Quantity);
                            IndentReqLine."PO Vendor" := Rec."Buy-from Vendor No.";
                            IndentReqLine.Modify;
                        end;
                    end;
                end;
            }

        }
        addlast("&Line")
        {
            action("CWIP Details")
            {
                ApplicationArea = all;
                Image = OpenJournal;
                Enabled = Rec.CWIP;
                ToolTip = 'Executes the CWIP Details action.';
                Caption = 'CWIP Details';
                trigger OnAction()
                begin

                    Rec.OpenCWIPDetails();
                    //  Rec.OpenCWIPDetails(); april27

                end;
            }

            //B2BVCOn20June2024 >>
            action("Import CWIP Details")
            {
                ApplicationArea = All;
                Image = Import;
                Enabled = Rec.CWIP;
                Caption = 'Import CWIP Details';
                trigger OnAction()
                begin
                    FixedAssetsReadExcelSheet();
                    CwIPImportExcelDate();
                end;
            }
            //B2BVCOn20June2024 <<
        }
    }

    trigger OnAfterGetRecord()
    begin
        //B2BVCOn07Aug2024 >>
        if PurchHeaderRec.Get(Rec."Document Type"::Order, Rec."Document No.") then begin
            if PurchHeaderRec.Status = PurchHeaderRec.Status::Open then
                FieldEditable1 := true
            else
                FieldEditable1 := false;
        end;
        //B2BVCOn07Aug2024 <<
    end;

    trigger OnAfterGetCurrRecord()
    begin
        //B2BVCOn07Aug2024 >>
        if Rec.CancelOrder then
            FieldEditableVar1 := false
        else
            FieldEditableVar1 := true;
        //B2BVCOn07Aug2024 <<
    end;

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
        purchaseline1: Record "Purchase Line";
        Inwardqty: Decimal;
        InwardQtyGVar: Decimal;

    begin
        //B2BSSD27APR2023>>
        if PurchHeader.get(Rec."Document Type", Rec."Document No.") then
            PurchHeader.TestField(Status, PurchHeader.status::Released);
        //B2BSSD27APR2023<<


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
            GateEntryHeader."Indent Document No" := rec."Indent No.";
            GateEntryHeader."Indent Line No" := rec."Indent Line No.";
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
                    GateEntryLine."Unit of Measure" := PurchLine."Unit of Measure Code"; //B2BSCM01FEB2024
                    GateEntryLine."Purchase Order No." := PurchLine."Document No.";
                    GateEntryLine."Purchase Order Line No." := PurchLine."Line No.";
                    //GateEntryLine.Validate(Quantity, ReservationEntry.Quantity);
                    //B2BSSD24Feb2023<<
                    GateEntryLine.Quantity := PurchLine.Quantity;
                    GateEntryLine.Make := PurchLine.Make_B2B;
                    GateEntryLine.ModelNo := PurchLine."Model No.";
                    GateEntryLine.SerialNo := PurchLine."Serial No.";
                    Inwardqty := (PurchLine."Qty to Inward_B2B" + PurchLine."Qty Accepted Inward_B2B");//B2BSSD15MAY2023
                    //B2BSSD24Feb2023>>
                    //GateEntryLine.ModelNo := ReservationEntry."Lot No.";
                    //GateEntryLine.SerialNo := ReservationEntry."Serial No.";
                    //GateEntryLine.Make := ReservationEntry."Variant Code";
                    GateEntryLine.Quantity := PurchLine."Qty to Inward_B2B";
                    GateEntryLine.Insert(true);
                    LineNo += 10000;
                    //B2BSSD30MAY2023
                    //GateEntryLine.Modify();//B2BSSD30MAY2023
                    PurchLine."Qty Accepted Inward_B2B" := Inwardqty;
                    PurchLine."Qty. to Receive (Base)" := 0;
                    PurchLine."Qty. to Invoice (Base)" := 0;
                    /* PurchLine."Qty. to Receive" := PurchLine."Qty to Inward_B2B" + PurchLine."Inward Qty";//B2BVCOn01Feb2024
                    PurchLine."Qty. to Invoice" := PurchLine."Qty to Inward_B2B" + PurchLine."Inward Qty"; //B2BVCOn01Feb2024
                    PurchLine."Inward Qty" := PurchLine."Qty. to Receive"; */ //B2BVCOn01Feb2024
                    PurchLine."Qty to Inward_B2B" := 0;
                    PurchLine.Modify();
                    //B2BSSD15MAY2023<<
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
                        GateEntryLine.ModelNo := FALRec."Model No.";
                        GateEntryLine.SerialNo := FALRec."Serial No.";
                        GateEntryLine."Purchase Order No." := PurchLine."Document No.";
                        GateEntryLine."Purchase Order Line No." := PurchLine."Line No.";
                        GateEntryLine.Make := FALRec.Make_B2B;
                        Inwardqty := (PurchLine."Qty to Inward_B2B" + PurchLine."Qty Accepted Inward_B2B");//B2BSSD25MAY2023
                        GateEntryLine.Insert(true);
                        LineNo += 10000;
                        //B2BSSD25MAY2023>>
                        PurchLine."Qty Accepted Inward_B2B" := Inwardqty;
                        GateEntryLine.Quantity := PurchLine."Qty to Inward_B2B";//B2BSSD30MAY2023
                        PurchLine."Qty to Inward_B2B" := 0;
                        GateEntryLine.Modify();//B2BSSD30MAY2023
                        //B2BSSD25MAY2023<<
                    end else
                        //B2BSSD20FEB2023<<
                        if PurchLine.Type = PurchLine.Type::Description then begin
                            GateEntryLine.Init();
                            GateEntryLine."Entry Type" := GateEntryHeader."Entry Type";
                            GateEntryLine.Type := GateEntryHeader.Type;
                            GateEntryLine."Gate Entry No." := GateEntryHeader."No.";
                            GateEntryLine."Line No." := LineNo;
                            GateEntryLine."Source Type" := GateEntryLine."Source Type"::Description;
                            GateEntryLine."Source No." := PurchLine."No.";
                            GateEntryLine."Unit of Measure" := Rec."Unit of Measure Code";//B2BSSD27APR2023
                            GateEntryLine.Description := PurchLine.Description;
                            GateEntryLine."Purchase Order No." := PurchLine."Document No.";
                            GateEntryLine."Purchase Order Line No." := PurchLine."Line No.";
                            GateEntryLine."Source Name" := PurchLine."Spec Id";//B2BSSD18APR2023   
                            Inwardqty := (PurchLine."Qty to Inward_B2B" + PurchLine."Qty Accepted Inward_B2B");//B2BSSD25MAY2023            
                            GateEntryLine.Insert(true);
                            LineNo += 10000;
                            //B2BSSD25MAY2023>>
                            PurchLine."Qty Accepted Inward_B2B" := Inwardqty;
                            PurchLine."Qty. to Receive (Base)" := PurchLine."Qty to Inward_B2B";
                            GateEntryLine.Quantity := PurchLine."Qty to Inward_B2B";//B2BSSD30MAY2023
                            PurchLine."Qty to Inward_B2B" := 0;
                            GateEntryLine.Modify();//B2BSSD30MAY2023
                            //B2BSSD25MAY2023<<
                        end;
                //B2BSSD20FEB2023>>

                //PurchLine.Select := false; //B2BSSD29JUN132023
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
    //B2BVCOn14Nov2023 >>

    local procedure ShortClose()
    var

        ConfirmText: Label 'Do you want to Short Close the Purchase Order %1 and Line No. %2 ?';
        NotApplicableErr: Label 'Qty Received and Qty Invoiced should be equal for Line %1';
        SuccessMsg: Label 'Purchase Order %1 is Short Closed';
        ShortClosed: Boolean;
        PurchaseHeaderLRec: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        CWIPVar: Boolean;
    begin
        Rec.TestField("Quantity Received");
        if Rec."Quantity Invoiced" <> Rec."Quantity Received" then
            Error(NotApplicableErr, Rec."Line No.");
        if not Confirm(StrSubstNo(ConfirmText, Rec."Document No.", Rec."Line No."), false) then
            exit;
        If PurchaseHeaderLRec.get(Rec."Document Type", Rec."Document No.") and (PurchaseHeaderLRec.Status = PurchaseHeaderLRec.Status::Released) then begin
            PurchaseHeaderLRec.Status := PurchaseHeaderLRec.Status::Open;
            PurchaseHeaderLRec.Modify();
        end;

        Rec.ShortClosed := true;
        if Rec.CWIP then begin
            Rec.CWIP := false;
            CWIPVar := true;
        end;
        Rec.validate(Quantity, Rec."Quantity Invoiced");
        Rec."Short Close Quantity" := Rec."Quantity Invoiced";
        if Rec."Short Close Quantity" <> 0 then begin
            Rec."Outstanding Quantity" := 0;
            Rec."Outstanding Qty. (Base)" := 0;
            Rec.Validate("Qty. to Receive", 0);
            Rec.Validate("Qty. to Invoice", 0);
        end;
        Rec."Short Closed by" := UserId;
        Rec."Short Closed Date & Time" := CurrentDateTime;
        Rec.Modify();
        If PurchaseHeaderLRec.get(Rec."Document Type", Rec."Document No.") and (PurchaseHeaderLRec.Status = PurchaseHeaderLRec.Status::Open) then begin
            PurchaseHeaderLRec.Status := PurchaseHeaderLRec.Status::Released;
            PurchaseHeaderLRec.Modify();
        end;
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine.SetRange("Posted Invioce", false);
        if PurchLine.FindSet() then begin
            PurchaseHeaderLRec."Posted Invioce" := false;
            PurchaseHeaderLRec.Modify();
        end else begin
            PurchaseHeaderLRec."Posted Invioce" := true;
            PurchaseHeaderLRec.Modify();
        end;
        if CWIPVar then
            Rec.CWIP := true;
        Message(SuccessMsg, Rec."No.");
    end;

    local procedure CancelOrder()
    var
        ConfirmText: Label 'Do you want to Cancelled the Purchase Order %1 and Line No. %2?';
        AlredyCancelledOrder: Label 'Purchase Order  %1 is already Order Cancelled';
        SuccessMsg: Label 'Purchase Order %1 and Line No. %2 is Cancelled';
        ErrorMsg: Label 'Quantity Received Must be Zero, Document No. %1, Line No. %2';
    begin
        if Rec.CancelOrder then
            Error(AlredyCancelledOrder, Rec."Document No.");
        if not Confirm(StrSubstNo(ConfirmText, Rec."Document No.", Rec."Line No."), false) then
            exit;
        if Rec."Quantity Received" <> 0 then
            Error(ErrorMsg, Rec."Document No.", Rec."Line No.");
        if Rec."Quantity Received" = 0 then begin
            Rec.CancelOrder := true;
            Rec.Modify;
        end;
        if Rec.CancelOrder then
            Message(SuccessMsg, Rec."Document No.", Rec."Line No.");
    end;

    trigger OnOpenPage()
    begin
        if UserSetupGRec.Get(UserId) then begin
            if UserSetupGRec.Stores then
                FieldEditable := true
            else
                FieldEditable := false;
        end;

    end;
    //B2BVCOn14Nov2023 <<
    var
        PurchHeaderRec: Record "Purchase Header";
        FieldEditable1: Boolean;
        GateEntryType: Option Inward,Outward;
        Text0004: Label 'You dont have Permessions to Open Documebt Tracking';
        Text0005: Label 'You dont have Permessions to Open Import Item Tracking';

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
        QtyToAcp: Integer;//B2BSSD21MAR2023
        QtyToRecj: Integer;//B2BSSD21MAR2023
        qtyAcp: Integer;//B2BSSD21MAR2023
        qtyRec: Integer;//B2BSSD21MAR2023
        warrantyRec: Code[30];//B2BSSD04APR2023
        IndentLineNo: Integer;//B2BSSD04APR2023
        indentReqLineNo: Integer; //B2BSSD04APR2023
        subLocation: Code[30];
        LineDiscount: Decimal;
        UnitofMeasure: Code[20];//B2BSSD27APR2023
        LineNo: Integer;
        CountGvar: Integer;//B2BSSD26MAY2023
        FALineNo: Integer;//B2BSSD26MAY2023
        //B2BSS07Feb2023>>
        purchaseline2: Record "Purchase Line";//B2BSSD26MAY2023
        UserSetup: Record "User Setup";
        PurchHeader: Record "Purchase Header";
        GateEntryNo: Code[20]; //B2BVCOn09Nov2023
        GateEntryLineNo: Integer;//B2BVCOn09Nov2023
        UserSetupGRec: Record "User Setup";
        FieldEditable: Boolean;
        IndentReqLine: Record "Indent Requisitions";
        FieldEditableVar1: Boolean;

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
        purchaseHeader: Record "Purchase Header";
        DocumentNo: Code[20];
        Error1: Label 'Quantity to Accept B2B is less than the excel rows %1';
        FixedAsset: Record "Fixed Asset";
    begin
        RowNo := 0;
        ColNo := 0;
        LineNo := 0;
        MaxRow := 0;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRow := TempExcelBuffer."Row No.";
        end;

        //B2BSSD25MAY2023>>
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document No.", Rec."Document No.");
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Select, true);
        if PurchaseLine.Findset() then begin
            //B2BSSD26MAY2023>>
            repeat
                Clear(FALineNo);
                Clear(CountGvar);
                for RowNo := 2 to MaxRow Do begin
                    evaluate(FALineNo, GetCellValue(RowNo, 10));
                    if PurchaseLine."Line No." = FALineNo then
                        CountGvar += 1;
                end;
                if PurchaseLine."Qty. to Accept B2B" <> CountGvar then
                    //if PurchaseLine."Quantity Accepted B2B" <> CountGvar then //B2BSSD08JUN2023
                    Error(Error1, PurchaseLine."Line No.");
            until PurchaseLine.Next() = 0;
            //PurchaseLine.DeleteAll();
            //B2BSSD26MAY2023<<
        end;
        //B2BSSD25MAY2023>>


        purChaseLine1.Reset();
        purChaseLine1.SetRange("Document Type", Rec."Document Type");
        purChaseLine1.SetRange("Document No.", Rec."Document No.");
        purChaseLine1.SetRange(Select, true);
        purChaseLine1.SetFilter("No.", '%1', '');
        //purChaseLine1.SetRange("Line No.", Rec."FA Line No.");//B2BSSD08JUN2023
        if purChaseLine1.FindSet() then begin
            repeat
                for RowNo := 2 to MaxRow Do begin

                    purchaseline2.SetRange("Document Type", purChaseLine1."Document Type");
                    purchaseline2.SetRange("Document No.", purChaseLine1."Document No.");
                    if purchaseline2.FindLast() then
                        LineNo := purchaseline2."Line No." + 10000
                    else
                        LineNo := 10000;

                    Evaluate(SourceType, GetCellValue(RowNo, 1));
                    Evaluate(No, GetCellValue(RowNo, 2));
                    Evaluate(SerialNo, GetCellValue(RowNo, 3));
                    Evaluate(ModelNo, GetCellValue(RowNo, 4));
                    Evaluate(Make, GetCellValue(RowNo, 5));
                    Evaluate(GSTGroupCode, GetCellValue(RowNo, 6));
                    Evaluate(HSNSACCode, GetCellValue(RowNo, 7));
                    Evaluate(GSTCredit, GetCellValue(RowNo, 8));
                    Evaluate(location, GetCellValue(RowNo, 9));
                    Evaluate(FALineNo, GetCellValue(RowNo, 10));//B2BSSD26MAY2023


                    if FALineNo = purChaseLine1."Line No." then begin
                        PurchaseLine.Init();
                        PurchaseLine."Document No." := Rec."Document No.";
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Line No." := LineNo;
                        PurchaseLine.Insert(true);
                        Evaluate(PurchaseLine.Type, SourceType);
                        PurchaseLine.Validate(Type);
                        PurchaseLine.Validate("No.", No);
                        PurchaseLine.Validate(Quantity, 1);
                        PurchaseLine.Validate("Quantity Accepted B2B", 1);
                        PurchaseLine.Validate("Qty Accepted Inward_B2B", 1);//B2BSSD27APR2023
                        PurchaseLine.Validate("Qty. to Reject B2B", 0);//B2BSSD27APR2023
                        PurchaseLine."Serial No." := SerialNo;
                        PurchaseLine."Model No." := ModelNo;
                        PurchaseLine.Make_B2B := Make;
                        PurchaseLine."GST Group Code" := GSTGroupCode;
                        PurchaseLine."HSN/SAC Code" := HSNSACCode;
                        PurchaseLine."GST Credit" := GSTCredit;
                        PurchaseLine."Location Code" := location;
                        PurchaseLine."FA Line No." := FALineNo;//B2BSSD26MAY2023


                        if PurchaseLine."Indent No." = '' then
                            PurchaseLine."Indent No." := purChaseLine1."Indent No.";
                        if PurchaseLine."Indent Req No" = '' then
                            PurchaseLine."Indent Req No" := purChaseLine1."Indent Req No";
                        if ShortcutDimension1 <> '' then
                            PurchaseLine.Validate("Shortcut Dimension 1 Code", purChaseLine1."Shortcut Dimension 1 Code");
                        if ShortCutDimension2 <> '' then
                            PurchaseLine.Validate("Shortcut Dimension 2 Code", purChaseLine1."Shortcut Dimension 2 Code");
                        if ShortCutDimention9 <> '' then
                            PurchaseLine.Validate("Shortcut Dimension 9 Code", purChaseLine1."Shortcut Dimension 9 Code");
                        if PurchaseLine."Direct Unit Cost" = 0 then
                            PurchaseLine.Validate("Direct Unit Cost", purChaseLine1."Direct Unit Cost");

                        if PurchaseLine."Line Discount %" = 0 then
                            PurchaseLine.Validate("Line Discount %", purChaseLine1."Line Discount %");//B2BSSD30MAY2023

                        if PurchaseLine."Indentor Description" = '' then
                            PurchaseLine."Indentor Description" := purChaseLine1."Indentor Description";
                        if PurchaseLine."Spec Id" = '' then
                            PurchaseLine."Spec Id" := purChaseLine1."Spec Id";
                        if PurchaseLine."Unit of Measure Code" = '' then//B2BSSD27APR2023
                            purchaseLine."Unit of Measure Code" := purChaseLine1."Unit of Measure Code";
                        //B2BSSD21MAR2023<<
                        // if PurchaseLine."Quantity Accepted B2B" = 0 then
                        //     PurchaseLine."Quantity Accepted B2B" := purChaseLine1."Quantity Accepted B2B";
                        if PurchaseLine."Quantity Rejected B2B" = 0 then
                            PurchaseLine."Quantity Rejected B2B" := purChaseLine1."Quantity Rejected B2B";
                        //B2BSSD21MAR2023<<

                        //B2BSSD04APR2023<<
                        if purChaseLine.warranty = '' then
                            PurchaseLine.warranty := purChaseLine1.warranty;
                        if purChaseLine."Indent Line No." = 0 then
                            purChaseLine."Indent Line No." := purChaseLine1."Indent Line No.";
                        if purChaseLine."Indent Req Line No" = 0 then
                            purChaseLine."Indent Req Line No" := purChaseLine1."Indent Req Line No";
                        //B2BSSD04APR2023>>
                        //B2BVCOn14Nov2023 >>
                        if PurchaseLine."Posted Gate Entry No." = '' then
                            PurchaseLine."Posted Gate Entry No." := purChaseLine1."Posted Gate Entry No.";
                        if PurchaseLine."Posted Gate Entry Line No." = 0 then
                            PurchaseLine."Posted Gate Entry Line No." := purChaseLine1."Posted Gate Entry Line No.";
                        //B2BVCOn14Nov2023 <<
                        PurchaseLine.validate("Qty. to Accept B2B", 0);
                        PurchaseLine.Modify(true);

                        if FixedAsset.Get(PurchaseLine."No.") then begin
                            FixedAsset."Serial No." := PurchaseLine."Serial No.";
                            FixedAsset.Make_B2B := PurchaseLine.Make_B2B;
                            FixedAsset."Model No." := PurchaseLine."Model No.";
                            FixedAsset."HSN/SAC Code" := PurchaseLine."HSN/SAC Code";
                            FixedAsset."GST Group Code" := PurchaseLine."GST Group Code";
                            FixedAsset."GST Credit" := PurchaseLine."GST Credit";
                            FixedAsset.Modify();
                        end;

                    end;
                end;
                purChaseLine1.Delete();
            until purChaseLine1.Next() = 0;
        end;
        Message(ExcelImportSuccess);
    end;
    //B2BSSD7Feb2023 Import End>>

    //B2BVCOn20June2024 >>
    procedure CwIPImportExcelDate()
    var
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRow: Integer;
        CWIPDetails: Record "CWIP Details";
        PurchLine: Record "Purchase Line";
        DocNo: Code[20];
        DocLineNo: Integer;
        ExcelImportSuccess: Label 'Excel File Imported Successfully';
    begin
        RowNo := 0;
        ColNo := 0;
        LineNo := 0;
        MaxRow := 0;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRow := TempExcelBuffer."Row No.";
        end;
        PurchLine.Reset();
        PurchLine.SetRange("Document No.", Rec."Document No.");
        if PurchLine.Find('-') then
            repeat
                Clear(LineNo);
                CWIPDetails.Reset();
                CWIPDetails.SetRange("Document No.", PurchLine."Document No.");
                CWIPDetails.SetRange("Document Line No.", PurchLine."Line No.");
                if CWIPDetails.FindLast() then
                    LineNo := CWIPDetails."Line No.";
                for RowNo := 2 to MaxRow do begin
                    Evaluate(DocNo, GetCellValue(RowNo, 1));
                    Evaluate(DocLineNo, GetCellValue(RowNo, 2));
                    if (PurchLine."Document No." = DocNo) And (PurchLine."Line No." = DocLineNo) then begin
                        LineNo := LineNo + 10000;
                        CWIPDetails.Init();
                        CWIPDetails."Document No." := PurchLine."Document No.";
                        CWIPDetails."Document Line No." := PurchLine."Line No.";
                        CWIPDetails."Item No." := PurchLine."No.";
                        CWIPDetails."Line No." := LineNo;
                        Evaluate(CWIPDetails.Make, GetCellValue(RowNo, 3));
                        Evaluate(CWIPDetails.Model, GetCellValue(RowNo, 4));
                        Evaluate(CWIPDetails."Serial No.", GetCellValue(RowNo, 5));
                        CWIPDetails.Insert();
                    end;
                end;
            until PurchLine.Next = 0;
        Message(ExcelImportSuccess);
    end;
    //B2BVCOn20June2024 <<
}