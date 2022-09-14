page 50159 "Inward Gate Entry-RGP"
{
    Caption = 'RGP-INWARD';
    UsageCategory = Documents;
    ApplicationArea = ALL;
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

                field("No."; "No.")
                {
                    ApplicationArea = ALL;
                    trigger OnAssistEdit();
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.UPDATE;
                        /*
                            GateEntryLocSetup.GET("Entry Type","Location Code");
                          GateEntryLocSetup.TESTFIELD("Posting No. Series");
                          IF NoSeriesMgt.SelectSeries(GateEntryLocSetup."Posting No. Series","No.","No. Series") THEN
                             NoSeriesMgt.SetSeries("No.");
                        */

                    end;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = ALL;
                }
                field("Station From/To"; "Station From/To")
                {
                    ApplicationArea = ALL;

                }
                field("Gate No."; "Gate No.")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        TestField("Approval Status", "Approval Status"::Open);
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = ALL;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = ALL;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = ALL;
                }
                field("Document Time"; "Document Time")
                {
                    ApplicationArea = ALL;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = ALL;
                }
                field("Posting Time"; "Posting Time")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR No."; "LR/RR No.")
                {
                    ApplicationArea = ALL;
                }
                field("LR/RR Date"; "LR/RR Date")
                {
                    ApplicationArea = ALL;
                }
                field("Vehicle No."; "Vehicle No.")
                {
                    ApplicationArea = ALL;
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = ALL;
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
                    begin
                        RGPLineRec.RESET;
                        RGPLineRec.SETRANGE("Entry Type", "Entry Type");
                        RGPLineRec.SETRANGE(Type, Type);
                        RGPLineRec.SETRANGE("Gate Entry No.", "No.");
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
                    end;
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
                        CHECKMAND();
                        // IF WorkflowManagement.CanExecuteWorkflow(Rec, allinoneCU.RunworkflowOnSendGATEforApprovalCode()) then
                        //   error('Workflow is enabled. You can not release manually.');

                        IF "Approval Status" <> "Approval Status"::Released then BEGIN
                            "Approval Status" := "Approval Status"::Released;
                            Modify();
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
                        IF "Approval Status" <> "Approval Status"::Open then BEGIN
                            "Approval Status" := "Approval Status"::Open;
                            Modify();
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
                        approvalmngmt.ApproveRecordApprovalRequest(RecordId());
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
                        CHECKMAND();
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
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        OpenAppEntrExistsForCurrUser := approvalmngmt.HasOpenApprovalEntriesForCurrentUser(RecordId());
        OpenApprEntrEsists := approvalmngmt.HasOpenApprovalEntries(RecordId());
        CanCancelapprovalforrecord := approvalmngmt.CanCancelApprovalForRecord(RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        TestField("Approval Status", "Approval Status"::Open);
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

