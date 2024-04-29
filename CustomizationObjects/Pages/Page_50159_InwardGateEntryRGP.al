page 50159 "Inward Gate Entry-RGP"
{
    Caption = 'RGP-INWARD';
    PageType = Document;
    SourceTable = "Gate Entry Header_B2B";
    SourceTableView = SORTING("Entry Type", "No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = CONST(Inward), Type = const(RGP));

    layout
    {
        area(content)
        {
            group(General)
            {
                /* field(Type; Type)
                 {
                     ApplicationArea = all;
                 }*/
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = ALL;
                    //B2BSSD11APR2023<<
                    trigger OnValidate()
                    var
                        Userwisesetup: Codeunit UserWiseSecuritySetup;
                    begin
                        if not Userwisesetup.CheckUserLocation(UserId, Rec."Location Code", 2) then
                            Error('User %1 dont have permission to location %2', UserId, Rec."Location Code");
                    end;
                    //B2BSSD11APR2023>>
                }
                field("To Location"; Rec."To Location")//B2BSSD31MAR2023
                {
                    ApplicationArea = All;
                    Caption = 'To Location';
                    TableRelation = Location;//B2BSSD31MAR2023
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = ALL;
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.UPDATE;
                        /*
                            GateEntryLocSetup.GET("Entry Type","Location Code");
                          GateEntryLocSetup.TESTFIELD("Posting No. Series");
                          IF NoSeriesMgt.SelectSeries(GateEntryLocSetup."Posting No. Series","No.","No. Series") THEN
                             NoSeriesMgt.SetSeries("No.");
                        */

                    end;
                }

                field("Station From/To"; Rec."Station From/To")
                {
                    ApplicationArea = ALL;
                    Visible = false;

                }
                field("Gate No."; Rec."Gate No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = ALL;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = ALL;
                }
                field("Document Time"; Rec."Document Time")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }
                field("Posting Time"; Rec."Posting Time")
                {
                    ApplicationArea = ALL;
                    Visible = false;
                }

                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = ALL;
                    //Visible = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = ALL;
                }
                //BaluonNov82022>>
                field(Purpose; rec.Purpose)
                {
                    Importance = Additional;//B2BSSD31MAR2023
                }
                field(InstallationFromDate; rec.InstallationFromDate)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(InstallationToDate; rec.InstallationToDate)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(ShootingStartDate; rec.ShootingStartDate)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(ShootingEndDate; rec.ShootingEndDate)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(ExpectedDateofReturn; rec.ExpectedDateofReturn)
                {
                    ApplicationArea = all;
                    Importance = Additional;

                }
                field(SubLocation; rec.SubLocation)
                {
                    ApplicationArea = all;
                    Importance = Additional;//B2BSSD31MAR2023
                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 9 Code"; Rec."Shortcut Dimension 9 Code")//B2BSSD22FEB2023
                {
                    ApplicationArea = All;
                }
                field(Designation; rec.Designation)
                {
                    ApplicationArea = all;
                    Importance = Additional;//B2BSSD31MAR2023
                }
                field(Program; rec.Program)
                {
                    Importance = Additional;//B2BSSD31MAR2023
                }
                //BaluonNov82022<<

                //B2BSSD16Dec2022<<
                field("Posted RGP Outward NO."; Rec."Posted RGP Outward NO.")
                {
                    ApplicationArea = All;
                    Editable = false;//B2BSSD07APR2023
                }
                field("Posted RGP Outward Date"; Rec."Posted RGP Outward Date")
                {
                    ApplicationArea = All;
                    Editable = false;//B2BSSD07APR2023
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true; //B2BSCM11SEP2023
                }
                field("LR/RR Date"; Rec."LR/RR Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;//B2BSSD31MAR2023
                    ShowMandatory = true; //B2BSCM11SEP2023
                }

                //B2BSSD16Dec2022>>

                //B2BSSD22Dec2022<<
                field("Receipt Date"; Rec."Receipt Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;//B2BSSD31MAR2023
                    ShowMandatory = true;
                }
                //B2BSSD22Dec2022>>
                field("Challan No."; Rec."Challan No.")
                {
                    ApplicationArea = All;
                    Caption = 'Challan No.';
                    ShowMandatory = true; //B2BSCM11SEP2023
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    ApplicationArea = All;
                    Caption = 'Challan Date';
                    Importance = Additional;//B2BSSD31MAR2023
                    ShowMandatory = true; //B2BSCM11SEP2023
                }
            }
            part(Control1500028; "Inward Gate Entry SubFrm-RGP")
            {
                SubPageLink = "Entry Type" = FIELD("Entry Type"),
                "type" = field("Type"),
                              "Gate Entry No." = FIELD("No.");
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("P&osting")
            {
                Image = Post;
                action("Po&st")
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //RunObject = Codeunit "Gate Entry- Post (Yes/No)";
                    ShortCutKey = 'F9';
                    trigger OnAction()
                    var
                        RGPLineRec: Record "Gate Entry Line_B2B";
                        PRGPLineRec: Record "Posted Gate Entry Line_B2B";
                        PostCU: Codeunit "Gate Entry- Post Yes/No";
                        PostedGateEntryLineB2B: Record "Posted Gate Entry Line_B2B";
                        QtytoReceive: Decimal;
                        PurchaseLineRec: Record "Purchase Line";
                        GateEntryHeader: Record "Gate Entry Header_B2B";
                        PostedGateEntryHeaderB2B: Record "Posted Gate Entry Header_B2B";
                    begin
                        Rec.TestField("Challan No.");//B2BSSD15MAR2023
                        Rec.TestField("Challan Date");//B2BSSD23MAR2023
                        RGPLineRec.RESET;
                        RGPLineRec.SETRANGE("Entry Type", Rec."Entry Type");
                        RGPLineRec.SETRANGE(Type, Rec.Type);
                        RGPLineRec.SETRANGE("Gate Entry No.", Rec."No.");
                        RGPLineRec.SETFILTER(Quantity, '>%1', 0);
                        IF RGPLineRec.FINDFIRST THEN
                            REPEAT
                                PRGPLineRec.Reset();
                                PRGPLineRec.SetRange("Entry Type", PRGPLineRec."Entry Type"::Outward);
                                PRGPLineRec.SetRange(Type, PRGPLineRec.Type::RGP);
                                PRGPLineRec.SetRange("Gate Entry No.", RGPLineRec."Posted RGP OUT NO.");
                                PRGPLineRec.SetRange("Source Type", RGPLineRec."Source Type");
                                PRGPLineRec.SetRange("Source No.", RGPLineRec."Source No.");
                                PRGPLineRec.SetRange("Line No.", RGPLineRec."Posted RGP OUT NO. Line");
                                IF PRGPLineRec.FINDFIRST THEN BEGIN
                                    PRGPLineRec.CALCFIELDS("Quantity Received");
                                    IF (RGPLineRec.Quantity + PRGPLineRec."Quantity Received") > PRGPLineRec.Quantity THEN
                                        Error('Total Quantity should less than sent quantity.');
                                end;
                            UNTIL RGPLineRec.NEXT = 0;
                        PostCU.RUN(Rec);
                        /* PostedGateEntryLineB2B.Reset();
                        PostedGateEntryLineB2B.SetRange("Entry Type", PostedGateEntryLineB2B."Entry Type"::Inward);
                        PostedGateEntryLineB2B.SetRange(Type, PostedGateEntryLineB2B.Type::RGP);
                        PostedGateEntryLineB2B.SetRange("Purchase Order No.", Rec."Purchase Order No.");
                        PostedGateEntryLineB2B.SetRange("Purchase Order Line No.", Rec."Purchase Order Line No.");
                        if PostedGateEntryLineB2B.FindFirst() then begin
                            repeat
                                QtytoReceive += PostedGateEntryLineB2B.Quantity;
                            until PostedGateEntryLineB2B.Next() = 0;
                            PurchaseLineRec.Reset();
                            PurchaseLineRec.SetRange("Document No.", PostedGateEntryLineB2B."Purchase Order No.");
                            PurchaseLineRec.SetRange("Line No.", PostedGateEntryLineB2B."Purchase Order Line No.");
                            if PurchaseLineRec.FindSet() then begin
                                PurchaseLineRec."Qty. to Receive" := QtytoReceive;
                                PurchaseLineRec.Modify();
                            end;
                        End; */
                    End;
                    //End;
                }
            }
            group(Approval)
            {
                Image = Approvals;
                action("Re&lease")
                {
                    ApplicationArea = all;
                    Caption = 'Re&lease';
                    ShortCutKey = 'Ctrl+F11';
                    Image = ReleaseDoc;
                    trigger OnAction()
                    begin
                        Rec.TestField("Receipt Date"); //B2BKM29APR2024
                        Rec.CHECKMAND();
                        // IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendGATEforApprovalCode()) then
                        //   error('Workflow is enabled. You can not release manually.');

                        IF Rec."Approval Status" <> Rec."Approval Status"::Released then BEGIN
                            Rec."Approval Status" := Rec."Approval Status"::Released;
                            Rec.Modify();
                            Message('Document has been Released.');
                        end;
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = all;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    trigger OnAction();
                    begin
                        RecordRest.Reset();
                        RecordRest.SetRange(ID, 50031);
                        RecordRest.SetRange("Record ID", Rec.RecordId());
                        IF RecordRest.FindFirst() THEN
                            error('This record is under in workflow process. Please cancel approval request if not required.');
                        IF Rec."Approval Status" <> Rec."Approval Status"::Open then BEGIN
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            Rec.Modify();
                            Message('Document has been Reopened.');
                        end;
                    end;
                }

                action(Approve)
                {
                    ApplicationArea = All;
                    Image = Action;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        approvalmngmt.ApproveRecordApprovalRequest(Rec.RecordId());
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = All;
                    Image = SendApprovalRequest;
                    Visible = Not OpenApprEntrEsists and CanrequestApprovForFlow;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        Rec.CHECKMAND();
                        //IF allinoneCU.CheckGATEApprovalsWorkflowEnabled(Rec) then
                        //   allinoneCU.OnSendGATEForApproval(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Visible = CanCancelapprovalforrecord or CanCancelapprovalforflow;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        // allinoneCU.OnCancelGATEForApproval(Rec);
                    end;
                }
            }
            //B2BSSD23MAR2023<<
            group("Get Posted Rgp OutWard")
            {
                action(GETPostedRgpOutwardLines)
                {
                    Image = GetEntries;
                    Caption = 'Get Posted RGP OutWard Entries';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        PostedRGPOutward: Record "Posted Gate Entry Header_B2B";
                        PostedOutwardGateEntryList: Page "PostedOutwardGateEntryList-RGP";
                        PostedRGPOutward1: Record "Posted Gate Entry Header_B2B";
                        InwardGateEntry: Record "Gate Entry Header_B2B";
                        LineNo: Integer;
                        PostedGateEntryLIne: Record "Posted Gate Entry Line_B2B";
                        RgpGateEntryInwardLine: Record "Gate Entry Line_B2B";
                        RGPGateEntryInward: Record "Gate Entry Header_B2B";
                    begin
                        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
                        //B2BSSD05APR2023<<
                        PostedRGPOutward.Reset();
                        if PostedRGPOutward.FindSet() then begin
                            if page.RunModal(Page::"PostedOutwardGateEntryList-RGP", PostedRGPOutward) = Action::LookupOK then begin


                                Rec."Location Code" := PostedRGPOutward.SubLocation;//B2BSSD10AUG2023
                                Rec."To Location" := PostedRGPOutward."To Location";//B2BSSD10AUG2023
                                Rec."Vehicle No." := PostedRGPOutward."Vehicle No.";
                                Rec.Description := PostedRGPOutward.Description;
                                Rec."Shortcut Dimension 1 Code" := PostedRGPOutward."Shortcut Dimension 1 Code";
                                Rec."Shortcut Dimension 2 Code" := PostedRGPOutward."Shortcut Dimension 2 Code";
                                Rec."Shortcut Dimension 9 Code" := PostedRGPOutward."Shortcut Dimension 9 Code";
                                Rec."Posted RGP Outward NO." := PostedRGPOutward."No.";
                                Rec."Posted RGP Outward Date" := PostedRGPOutward."Document Date";
                                Rec."LR/RR No." := PostedRGPOutward."LR/RR No.";
                                Rec."LR/RR Date" := PostedRGPOutward."LR/RR Date";
                                Rec."Challan No." := PostedRGPOutward."Challan No.";
                                Rec."Challan Date" := PostedRGPOutward."Challan Date";
                                Rec.Purpose := PostedRGPOutward.Purpose;
                                Rec.Program := PostedRGPOutward.Program;
                                Rec.ExpectedDateofReturn := PostedRGPOutward.ExpectedDateofReturn;//B2BSSD07APR2023
                                Rec."Indent Document No" := PostedRGPOutward."Indent Document No";
                                Rec."Indent Line No" := PostedRGPOutward."Indent Line No";
                                Rec.Modify();
                                LineNo := 10000;
                                PostedGateEntryLIne.Reset();
                                PostedGateEntryLIne.SetRange("Gate Entry No.", PostedRGPOutward."No.");
                                if PostedGateEntryLIne.FindSet() then begin
                                    repeat
                                        RgpGateEntryInwardLine.Init();
                                        RgpGateEntryInwardLine."Entry Type" := rec."Entry Type";
                                        RgpGateEntryInwardLine."Gate Entry No." := Rec."No.";
                                        RgpGateEntryInwardLine.Type := Rec.Type;
                                        RgpGateEntryInwardLine."Line No." := LineNo;
                                        RgpGateEntryInwardLine.Insert(true);
                                        RgpGateEntryInwardLine."Source Type" := PostedGateEntryLIne."Source Type";
                                        RgpGateEntryInwardLine."Source No." := PostedGateEntryLIne."Source No.";
                                        RgpGateEntryInwardLine."Source Name" := PostedGateEntryLIne."Source No.";
                                        RgpGateEntryInwardLine.Quantity := PostedGateEntryLIne.Quantity;
                                        RgpGateEntryInwardLine."Unit of Measure" := PostedGateEntryLIne."Unit of Measure";
                                        RgpGateEntryInwardLine.Description := PostedGateEntryLIne.Description;
                                        LineNo += 10000;
                                        RgpGateEntryInwardLine.ModelNo := PostedGateEntryLIne.ModelNo;
                                        RgpGateEntryInwardLine.SerialNo := PostedGateEntryLIne.SerialNo;
                                        RgpGateEntryInwardLine.Make := PostedGateEntryLIne.Variant;
                                        RgpGateEntryInwardLine."Purchase Order No." := PostedGateEntryLIne."Purchase Order No.";
                                        RgpGateEntryInwardLine."Purchase Order Line No." := PostedGateEntryLIne."Purchase Order Line No.";
                                        RgpGateEntryInwardLine.Modify(true);
                                    until PostedGateEntryLIne.Next() = 0;
                                end;
                            end;
                        end;
                        //B2BSSD05APR2023>>
                    end;
                }
            }
            //B2BSSD23MAR2023>>
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(Rec.RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(Rec.RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        Rec.TestField("Approval Status", Rec."Approval Status"::Open);
    END;

    var
        approvalmngmt: Codeunit "Approvals Mgmt.";
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";
        OpenAppEntrExistsForCurrUser: Boolean;
        OpenApprEntrEsists: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;
        CanrequestApprovForFlow: Boolean;
        RecordRest: Record "Restricted Record";
        //allinoneCU: Codeunit Codeunit1;
        WorkflowManagement: Codeunit "Workflow Management";
}

