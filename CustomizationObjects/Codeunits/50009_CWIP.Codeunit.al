
codeunit 50009 CWIP

{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PurchRcpHdrNo: Code[20])
    var
        CWIPLedgerEntry: Record "CWIP Ledger Entry";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        CWIPDetails: Record "CWIP Details";
        CWIPCount: Integer;
        LastEntryNo: Integer;
    begin
        if PurchRcpHdrNo = '' then
            exit;
        if PurchRcptHeader.Get(PurchRcpHdrNo) then begin
            CWIPLedgerEntry.Reset();
            if CWIPLedgerEntry.FindLast() then
                LastEntryNo := CWIPLedgerEntry."Entry No." + 1
            else
                LastEntryNo := 1;

            PurchRcptLine.Reset();
            PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
            PurchRcptLine.SetRange(CWIP, true);
            if PurchRcptLine.FindSet() then
                repeat
                    CWIPCount := 0;
                    CWIPDetails.Reset();
                    CWIPDetails.SetRange("Document No.", PurchRcptLine."Order No.");
                    CWIPDetails.SetRange("Document Line No.", PurchRcptLine."Order Line No.");
                    CWIPDetails.SetRange(Posted, false);
                    if CWIPDetails.FindSet() then
                        repeat
                            CWIPCount := CWIPCount + 1;
                            CWIPLedgerEntry.Init();
                            CWIPLedgerEntry."Entry No." := LastEntryNo;
                            CWIPLedgerEntry."Posting Date" := PurchRcptHeader."Posting Date";
                            CWIPLedgerEntry."Receipt No." := PurchRcptLine."Document No.";
                            CWIPLedgerEntry."Receipt Line No." := PurchRcptLine."Line No.";
                            CWIPLedgerEntry."Order No." := PurchRcptLine."Order No.";
                            CWIPLedgerEntry."Order Line No." := PurchRcptLine."Order Line No.";
                            CWIPLedgerEntry."Item No." := PurchRcptLine."No.";
                            CWIPLedgerEntry.Description := PurchRcptLine.Description;
                            if PurchRcptLine."Unit of Measure Code" = 'NOS' then begin
                                CWIPLedgerEntry.Quantity := 1;
                                if PurchRcptLine."Line Discount %" = 0 then
                                    CWIPLedgerEntry.Amount := PurchRcptLine."Direct Unit Cost"
                                else begin
                                    CWIPLedgerEntry.Amount := Round(PurchRcptLine.Quantity * PurchRcptLine."Direct Unit Cost", 0.01);
                                    if CWIPLedgerEntry.Amount <> 0 then
                                        CWIPLedgerEntry.Amount := Round((CWIPLedgerEntry.Amount - (CWIPLedgerEntry.Amount * PurchRcptLine."Line Discount %") / 100) / PurchRcptLine.Quantity, 0.01);
                                end;
                            end else begin
                                CWIPLedgerEntry.Quantity := PurchRcptLine.Quantity;
                                CWIPLedgerEntry.Amount := Round(PurchRcptLine.Quantity * PurchRcptLine."Direct Unit Cost", 0.01);
                                if (CWIPLedgerEntry.Amount <> 0) and (PurchRcptLine."Line Discount %" <> 0) then
                                    CWIPLedgerEntry.Amount := Round((CWIPLedgerEntry.Amount - (CWIPLedgerEntry.Amount * PurchRcptLine."Line Discount %") / 100), 0.01);
                            end;
                            CWIPLedgerEntry."Vendor No." := PurchRcptHeader."Buy-from Vendor No.";
                            CWIPLedgerEntry."Vendor Name" := PurchRcptHeader."Buy-from Vendor Name";
                            CWIPLedgerEntry.Make := CWIPDetails.Make;
                            CWIPLedgerEntry.Model := CWIPDetails.Model;
                            CWIPLedgerEntry."Serial No." := CWIPDetails."Serial No.";
                            CWIPLedgerEntry.Open := true;
                            CWIPLedgerEntry."Global Dimension 1 Code" := PurchRcptLine."Shortcut Dimension 1 Code";
                            CWIPLedgerEntry."Global Dimension 2 Code" := PurchRcptLine."Shortcut Dimension 2 Code";
                            CWIPLedgerEntry."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
                            CWIPLedgerEntry."Location Code" := PurchRcptHeader."Location Code";
                            CWIPLedgerEntry."CWIP Detail Line No." := CWIPDetails."Line No.";
                            CWIPLedgerEntry.Insert(true);
                            LastEntryNo += 1;

                            CWIPDetails.Posted := true;
                            CWIPDetails.Modify();
                        until (CWIPDetails.Next() = 0) or (Round(PurchRcptLine.Quantity) = CWIPCount);
                until PurchRcptLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(var PurchLine: Record "Purchase Line"; Item: Record Item)
    begin
        PurchLine.CWIP := Item.CWIP;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterTestPurchLine', '', false, false)]
    local procedure OnAfterTestPurchLine(PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        CWIPDetails: Record "CWIP Details";
        ErrLbl: Label 'You must define CWIP details for the Item No. %1 and Line No. %2.';
        Err2Lbl: Label 'CWIP details must be defined for the total receiving quantity of Item No. %1 and Line No. %2.';
    begin
        if (PurchHeader.Receive) and (PurchLine.CWIP) then begin
            CWIPDetails.Reset();
            CWIPDetails.SetRange("Document No.", PurchLine."Document No.");
            CWIPDetails.SetRange("Document Line No.", PurchLine."Line No.");
            if not CWIPDetails.FindSet() then
                Error(ErrLbl, PurchLine."No.", PurchLine."Line No.")
            else
                if (CWIPDetails.Count < (PurchLine."Qty. to Receive" + PurchLine."Quantity Received")) and (PurchLine."Unit of Measure Code" = 'NOS') then
                    Error(Err2Lbl, PurchLine."No.", PurchLine."Line No.")
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; var NewSourceRecVar: Variant)
    var
        CWIPLedgerEntry: Record "CWIP Ledger Entry";
        Navigate: Page Navigate;
    begin
        if (DocNoFilter = '') and (PostingDateFilter = '') then
            exit;
        if CWIPLedgerEntry.ReadPermission() then begin
            CWIPLedgerEntry.Reset();
            CWIPLedgerEntry.SetCurrentKey("Receipt No.");
            CWIPLedgerEntry.SetFilter("Receipt No.", DocNoFilter);
            CWIPLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::"CWIP Ledger Entry", CWIPLedgerEntry.TableCaption, CWIPLedgerEntry.Count);
        end;
    end;

    //CWIP Approval Starts>>
    [IntegrationEvent(false, false)]
    Procedure OnSendCWIPForApproval(var CWIPHeader: Record "CWIP Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelCWIPForApproval(var CWIPHeader: Record "CWIP Header")
    begin
    end;

    procedure RunworkflowOnSendCheckValueforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendCWIPforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::CWIP, 'OnSendCWIPForApproval', '', true, true)]
    local procedure RunworkflowonsendCWIPForApproval(var CWIPHeader: Record "CWIP Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendCheckValueforApprovalCode(), CWIPHeader);
    end;

    procedure RunworkflowOnCancelCheckValueforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelCWIPForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::CWIP, 'OncancelCWIPForApproval', '', true, true)]

    local procedure RunworkflowonCancelCWIPForApproval(var CWIPHeader: Record "CWIP Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelCheckValueforApprovalCode(), CWIPHeader);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendCheckValueforApprovalCode(), DATABASE::"CWIP Header",
          CopyStr(CheckValuesendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelCheckValueforApprovalCode(), DATABASE::"CWIP Header",
          CopyStr(CheckValuerequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibrary(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelCheckValueforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelCheckValueforApprovalCode(), RunworkflowOnSendCheckValueforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendCheckValueForApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunWorkflowOnSendCheckValueForApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunWorkflowOnSendCheckValueForApprovalCode());
        end;
    end;

    procedure ISCheckCWIPworkflowenabled(var CWIPHeader: Record "CWIP Header"): Boolean
    begin
        if CWIPHeader.Status <> CWIPHeader.Status::open then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(CWIPHeader, RunworkflowOnSendCheckValueforApprovalCode()));
    end;

    Procedure CheckCWIPApprovalsWorkflowEnabled(VAR CWIPHeader: Record "CWIP Header"): Boolean
    begin
        IF not ISCheckCWIPworkflowenabled(CWIPHeader) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        CWIPHeader: Record "CWIP Header";
    begin
        case RecRef.Number() of
            DATABASE::"CWIP Header":
                begin
                    RecRef.SetTable(CWIPHeader);
                    ApprovalEntryArgument."Document No." := FORMAT(CWIPHeader."No.");
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure Onopendocument(RecRef: RecordRef; var Handled: boolean)
    var
        CWIPHeader: Record "CWIP Header";
    begin
        case RecRef.Number() of
            DATABASE::"CWIP Header":
                begin
                    RecRef.SetTable(CWIPHeader);
                    CWIPHeader.Status := CWIPHeader.Status::Open;
                    CWIPHeader.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocument(RecRef: RecordRef; var Handled: boolean)
    var
        CWIPHeader: Record "CWIP Header";
    begin
        case RecRef.Number() of
            DATABASE::"CWIP Header":
                begin
                    RecRef.SetTable(CWIPHeader);
                    CWIPHeader.Status := CWIPHeader.Status::Released;
                    CWIPHeader.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApproval(RecRef: RecordRef; var IsHandled: boolean)
    var
        CWIPHeader: Record "CWIP Header";
    begin
        case RecRef.Number() of
            DATABASE::"CWIP Header":
                begin
                    RecRef.SetTable(CWIPHeader);
                    CWIPHeader.Status := CWIPHeader.Status::"Pending Approval";
                    CWIPHeader.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure Onaddworkflowresponseprodecessorstolibrary(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendCheckValueforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendCheckValueforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelCheckValueforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelCheckValueforApprovalCode());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibrary()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(CWIPCategoryTxt, 1, 20), CopyStr(CWIPCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelations()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::"CWIP Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplate()
    begin
        InsertCWIPApprovalworkflowtemplate();
    end;

    local procedure InsertCWIPApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(IncDocOCRWorkflowCodeTxt, 1, 17), CopyStr(CWIPApprWorkflowDescTxt, 1, 100), CopyStr(CWIPCategoryTxt, 1, 20));
        InsertCWIPApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertCWIPApprovalworkflowDetails(var workflow: record Workflow);
    var
        CWIPHeader: Record "CWIP Header";
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildCWIPtypecondition(CWIPHeader.Status::open), RunworkflowOnSendCheckValueforApprovalCode(), BuildCWIPtypecondition(CWIPHeader.Status::"Pending Approval"), RunworkflowOnCancelCheckValueforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildCWIPtypecondition(status: integer): Text
    var
        CWIPHeader: Record "CWIP Header";
    Begin
        CWIPHeader.SetRange(Status, status);
        exit(StrSubstNo(CWIPTypeCondnTxt, workflowsetup.Encode(CWIPHeader.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure Onaftergetpageid(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageid(RecordRef)
    end;

    local procedure GetConditionalcardPageid(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            DATABASE::"CWIP Header":
                exit(page::CWIP);
        end;
    end;


    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowevenHandling: Codeunit "Workflow Event Handling";
        workflowsetup: codeunit "Workflow Setup";
        CheckValuesendforapprovaleventdescTxt: Label 'Approval of a CWIP is requested';
        CheckValuerequestcanceleventdescTxt: Label 'Approval of a CWIP is Cancelled';
        NoworkfloweableErr: Label 'No Approval workflow for this record type is enabled.';
        CWIPCategoryTxt: Label 'CWIP';
        CWIPCategoryDescTxt: Label 'CWIP';
        CWIPApprWorkflowDescTxt: Label 'CWIP Approval Workflow';
        IncDocOCRWorkflowCodeTxt: Label 'INCDOC-CWIP';
        CWIPTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="CWIP">%1</DataItem></DataItems></ReportParameters>', Comment = '%1 = Data Item Name';
    //CWIP Approval Ends<<

}


