codeunit 50014 "Approvals MGt 3"

{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    Procedure OnSendIndentRequHdrForApproval(var IndentRequHdr: Record "Indent Req Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelIndentRequHdrForApproval(var IndentRequHdr: Record "Indent Req Header")
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendIndentRequHdrforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendIndentRequHdrforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 3", 'OnSendIndentRequHdrForApproval', '', true, true)]
    local procedure RunworkflowonsendIndentRequHdrForApproval(var IndentRequHdr: Record "Indent Req Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendIndentRequHdrforApprovalCode(), IndentRequHdr);
    end;

    procedure RunworkflowOnCancelIndentRequHdrforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelIndentRequHdrForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 3", 'OnCancelIndentRequHdrForApproval', '', true, true)]

    local procedure RunworkflowonCancelIndentRequHdrForApproval(var IndentRequHdr: Record "Indent Req Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelIndentRequHdrforApprovalCode(), IndentRequHdr);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryIndentRequHdr();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendIndentRequHdrforApprovalCode(), DATABASE::"Indent Req Header",
          CopyStr(IndentRequHdrsendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelIndentRequHdrforApprovalCode(), DATABASE::"Indent Req Header",
          CopyStr(IndentRequHdrrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryIndentRequHdr(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelIndentRequHdrforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelIndentRequHdrforApprovalCode(), RunworkflowOnSendIndentRequHdrforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendIndentRequHdrforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendIndentRequHdrforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendIndentRequHdrforApprovalCode());
        end;
    end;

    procedure ISIndentRequHdrworkflowenabled(var IndentRequHdr: Record "Indent Req Header"): Boolean
    begin
        if IndentRequHdr.status <> IndentRequHdr.status::Open then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(IndentRequHdr, RunworkflowOnSendIndentRequHdrforApprovalCode()));
    end;

    Procedure CheckIndentRequHdrApprovalsWorkflowEnabled(var IndentRequHdr: Record "Indent Req Header"): Boolean
    begin
        IF not ISIndentRequHdrworkflowenabled(IndentRequHdr) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentIndentRequHdr(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        IndentRequHdr: Record "Indent Req Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(IndentRequHdr);
                    ApprovalEntryArgument."Document No." := FORMAT(IndentRequHdr."No.");
                end;
        end;
    end;

    //Handling workflow response

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentIndentRequHdr(RecRef: RecordRef; var Handled: boolean)
    var
        IndentRequHdr: Record "Indent Req Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(IndentRequHdr);
                    IndentRequHdr.status := IndentRequHdr.status::Open;
                    IndentRequHdr.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentIndentRequHdr(RecRef: RecordRef; var Handled: boolean)
    var
        IndentRequHdr: Record "Indent Req Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(IndentRequHdr);
                    IndentRequHdr.status := IndentRequHdr.status::Release;
                    IndentRequHdr.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalIndentRequHdr(RecRef: RecordRef; var IsHandled: boolean)
    var
        IndentRequHdr: Record "Indent Req Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(IndentRequHdr);
                    IndentRequHdr.status := IndentRequHdr.status::"Pending Approval";
                    IndentRequHdr.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryIndentRequHdr(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendIndentRequHdrforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendIndentRequHdrforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelIndentRequHdrforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelIndentRequHdrforApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryIndentRequHdr()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(IndentRequHdrCategoryTxt, 1, 20), CopyStr(IndentRequHdrCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsIndentRequHdr()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::"Indent Req Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateIndentRequHdr()
    begin
        InsertIndentRequHdrApprovalworkflowtemplate();
    end;



    local procedure InsertIndentRequHdrApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(IndentRequHdrDocOCRWorkflowCodeTxt, 1, 17), CopyStr(IndentRequHdrApprWorkflowDescTxt, 1, 100), CopyStr(IndentRequHdrCategoryTxt, 1, 20));
        InsertIndentRequHdrApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertIndentRequHdrApprovalworkflowDetails(var workflow: record Workflow);
    var
        IndentRequHdr: Record "Indent Req Header";
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.PopulateWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildIndentRequHdrtypecondition(IndentRequHdr.status::Open), RunworkflowOnSendIndentRequHdrforApprovalCode(), BuildIndentRequHdrtypecondition(IndentRequHdr.status::"Pending Approval"), RunworkflowOnCancelIndentRequHdrforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildIndentRequHdrtypecondition(status: integer): Text
    var
        IndentRequHdr: Record "Indent Req Header";
    Begin
        IndentRequHdr.SetRange(status, status);
        exit(StrSubstNo(IndentRequHdrTypeCondnTxt, workflowsetup.Encode(IndentRequHdr.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidIndentRequHdr(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidIndentRequHdr(RecordRef)
    end;

    local procedure GetConditionalcardPageidIndentRequHdr(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::"Indent Req Header":
                exit(page::"Indent Requisition Document");
        end;
    end;

    //Add  IndentRequHdr Approval End  <<
    //B2BMS  End


    var
        myInt: Integer;
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowevenHandling: Codeunit "Workflow Event Handling";
        workflowsetup: codeunit "Workflow Setup";

        //B2BMS  Start Variables for 
        IndentRequHdrsendforapprovaleventdescTxt: Label 'Approval of a  IndentRequHdr Document is requested';
        IndentRequHdrCategoryDescTxt: Label 'IndentRequHdrDocuments';
        IndentRequHdrTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=IndentRequHdr>%1</DataItem></DataItems></ReportParameters>';
        IndentRequHdrrequestcanceleventdescTxt: Label 'Approval of a  IndentRequHdr Document is Cancelled';
        IndentRequHdrCategoryTxt: Label 'IndentRequHdrpecifications';
        IndentRequHdrDocOCRWorkflowCodeTxt: Label ' IndentRequHdr';
        IndentRequHdrApprWorkflowDescTxt: Label 'IndentRequHdr Approval Workflow';
        NoworkfloweableErr: Label 'No work flows enabled';



    //B2BMS  End Variables for 

}
