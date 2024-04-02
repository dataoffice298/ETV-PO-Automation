codeunit 50018 "Approvals MGt 4"
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    Procedure OnSendQuoteComparisionCusForApproval(var QuoteComparisionCus: Record QuotCompHdr)
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelQuoteComparisionCusForApproval(var QuoteComparisionCus: Record QuotCompHdr)
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendQuoteComparisionCusforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendQuoteComparisionCusforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 4", 'OnSendQuoteComparisionCusForApproval', '', true, true)]
    local procedure RunworkflowonsendQuoteComparisionCusForApproval(var QuoteComparisionCus: Record QuotCompHdr)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendQuoteComparisionCusforApprovalCode(), QuoteComparisionCus);
    end;

    procedure RunworkflowOnCancelQuoteComparisionCusforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelQuoteComparisionCusForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 4", 'OnCancelQuoteComparisionCusForApproval', '', true, true)]

    local procedure RunworkflowonCancelQuoteComparisionCusForApproval(var QuoteComparisionCus: Record QuotCompHdr)
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelQuoteComparisionCusforApprovalCode(), QuoteComparisionCus);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryQuoteComparisionCus();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendQuoteComparisionCusforApprovalCode(), DATABASE::QuotCompHdr,
          CopyStr(QuoteComparisionCussendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelQuoteComparisionCusforApprovalCode(), DATABASE::QuotCompHdr,
          CopyStr(QuoteComparisionCusrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryQuoteComparisionCus(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelQuoteComparisionCusforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelQuoteComparisionCusforApprovalCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
        end;
    end;

    procedure ISQuoteComparisionCusworkflowenabled(var QuoteComparisionCus: Record QuotCompHdr): Boolean
    begin
        if (QuoteComparisionCus.Status <> QuoteComparisionCus.Status::Open) then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(QuoteComparisionCus, RunworkflowOnSendQuoteComparisionCusforApprovalCode()));
    end;

    Procedure CheckQuoteComparisionCusApprovalsWorkflowEnabled(var QuoteComparisionCus: Record QuotCompHdr): Boolean
    begin
        IF not ISQuoteComparisionCusworkflowenabled(QuoteComparisionCus) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentQuoteComparisionCus(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        QuoteComparisionCus: Record QuotCompHdr;
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparisionCus);
                    ApprovalEntryArgument."Document No." := FORMAT(QuoteComparisionCus."No.");
                end;
        end;
    end;

    //Handling workflow response

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentQuoteComparisionCus(RecRef: RecordRef; var Handled: boolean)
    var
        QuoteComparisionCus: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparisionCus);
                    QuoteComparisionCus.SetRange("No.", QuoteComparisionCus."No.");
                    QuoteComparisionCus.Status := QuoteComparisionCus.Status::Open;
                    QuoteComparisionCus.Modify();

                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionCus.RFQNumber);
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::Open);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentQuoteComparisionCus(RecRef: RecordRef; var Handled: boolean)
    var
        QuoteComparisionCus: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparisionCus);
                    QuoteComparisionCus.SetRange("No.", QuoteComparisionCus."No.");
                    QuoteComparisionCus.Status := QuoteComparisionCus.Status::Released;
                    QuoteComparisionCus.Modify();
                    //QuoteComparisionCus.ModifyAll("Approval Status", QuoteComparisionCus."Approval Status"::Released);
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionCus.RFQNumber);
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::Released);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalQuoteComparisionCus(RecRef: RecordRef; var IsHandled: boolean)
    var
        QuoteComparisionCus: Record QuotCompHdr;
        PurchaseHeader: Record "Purchase Header";
    begin
        case RecRef.Number() of
            Database::QuotCompHdr:
                begin
                    RecRef.SetTable(QuoteComparisionCus);
                    QuoteComparisionCus.SetRange("No.", QuoteComparisionCus."No.");
                    QuoteComparisionCus.Status := QuoteComparisionCus.Status::"Pending Approval";
                    QuoteComparisionCus.Modify();
                    //QuoteComparisionCus.ModifyAll("Approval Status", QuoteComparisionCus."Approval Status"::"Pending Approval");
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("RFQ No.", QuoteComparisionCus.RFQNumber);
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Quote);
                    if PurchaseHeader.FindSet() then
                        PurchaseHeader.ModifyAll("Approval Status", PurchaseHeader."Approval Status"::"Pending Approval");
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryQuoteComparisionCus(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendQuoteComparisionCusforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelQuoteComparisionCusforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelQuoteComparisionCusforApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryQuoteComparisionCus()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(QuoteComparisionCusCategoryTxt, 1, 20), CopyStr(QuoteComparisionCusCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsQuoteComparisionCus()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::QuotCompHdr, 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateQuoteComparisionCus()
    begin
        InsertQuoteComparisionCusApprovalworkflowtemplate();
    end;



    local procedure InsertQuoteComparisionCusApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(QuoteComparisionCusDocOCRWorkflowCodeTxt, 1, 17), CopyStr(QuoteComparisionCusApprWorkflowDescTxt, 1, 100), CopyStr(QuoteComparisionCusCategoryTxt, 1, 20));
        InsertQuoteComparisionCusApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertQuoteComparisionCusApprovalworkflowDetails(var workflow: record Workflow);
    var
        QuoteComparisionCus: Record QuotCompHdr;
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildQuoteComparisionCustypecondition(QuoteComparisionCus.Status::Open), RunworkflowOnSendQuoteComparisionCusforApprovalCode(), BuildQuoteComparisionCustypecondition(QuoteComparisionCus.Status::"Pending Approval"), RunworkflowOnCancelQuoteComparisionCusforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildQuoteComparisionCustypecondition(status: integer): Text
    var
        QuoteComparisionCus: Record QuotCompHdr;
    Begin
        QuoteComparisionCus.SetRange(Status, status);
        exit(StrSubstNo(QuoteComparisionCusTypeCondnTxt, workflowsetup.Encode(QuoteComparisionCus.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidQuoteComparisionCus(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidQuoteComparisionCus(RecordRef)
    end;

    local procedure GetConditionalcardPageidQuoteComparisionCus(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::QuotCompHdr:
                exit(page::"Quotation Comparision Doc");
        end;
    end;

    //Add QC QuoteComparisionCus Approval End  <<
    //b2besg  End

    //Indent Header Approvals Start --- B2BMSOn09Sep2022>>
    [IntegrationEvent(false, false)]
    Procedure OnSendIndentDocForApproval(var IndentDoc: Record "Indent Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelIndentDocForApproval(var IndentDoc: Record "Indent Header")
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendIndentDocforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendIndentDocforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 4", 'OnSendIndentDocForApproval', '', true, true)]
    local procedure RunworkflowonsendIndentDocForApproval(var IndentDoc: Record "Indent Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendIndentDocforApprovalCode(), IndentDoc);
    end;

    procedure RunworkflowOnCancelIndentDocforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelIndentDocForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 4", 'OnCancelIndentDocForApproval', '', true, true)]

    local procedure RunworkflowonCancelIndentDocForApproval(var IndentDoc: Record "Indent Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelIndentDocforApprovalCode(), IndentDoc);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryIndentDoc();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendIndentDocforApprovalCode(), DATABASE::"Indent Header",
          CopyStr(IndentDocsendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelIndentDocforApprovalCode(), DATABASE::"Indent Header",
          CopyStr(IndentDocrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryIndentDoc(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelIndentDocforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelIndentDocforApprovalCode(), RunworkflowOnSendIndentDocforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendIndentDocforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendIndentDocforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendIndentDocforApprovalCode());
        end;
    end;

    procedure ISIndentDocworkflowenabled(var IndentDoc: Record "Indent Header"): Boolean
    begin
        if (IndentDoc."Released Status" <> IndentDoc."Released Status"::Open) then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(IndentDoc, RunworkflowOnSendIndentDocforApprovalCode()));
    end;

    Procedure CheckIndentDocApprovalsWorkflowEnabled(var IndentDoc: Record "Indent Header"): Boolean
    begin
        IF not ISIndentDocworkflowenabled(IndentDoc) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentIndentDoc(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        IndentDoc: Record "Indent Header";
    begin
        case RecRef.Number() of
            Database::"Indent Header":
                begin
                    RecRef.SetTable(IndentDoc);
                    ApprovalEntryArgument."Document No." := FORMAT(IndentDoc."No.");
                end;
        end;
    end;

    //Handling workflow response

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentIndentDoc(RecRef: RecordRef; var Handled: boolean)
    var
        IndentDoc: Record "Indent Header";
        IndentLine: Record "Indent Line";
    begin
        case RecRef.Number() of
            Database::"Indent Header":
                begin
                    RecRef.SetTable(IndentDoc);
                    IndentDoc.SetRange("No.", IndentDoc."No.");
                    IndentDoc."Released Status" := IndentDoc."Released Status"::Open;
                    IndentDoc."Last Modified Date" := WorkDate();
                    IndentDoc.Modify();

                    IndentLine.RESET;
                    IndentLine.SETRANGE("Document No.", IndentDoc."No.");
                    IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
                    IF IndentLine.FIND('-') THEN
                        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Open);
                    Handled := true;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentIndentDoc(RecRef: RecordRef; var Handled: boolean)
    var
        IndentDoc: Record "Indent Header";
        IndentLine: Record "Indent Line";
        UserSetup: Record "User Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Recipiants: List of [Text];
        Body: Text;
        Text001: Label 'Please find Indent Number: %1 dt. %2 is raised for the purpose %3 has been approved by your HOD.';
        Sub: Label 'Request for Indent Approval';
    begin
        case RecRef.Number() of
            Database::"Indent Header":
                begin
                    RecRef.SetTable(IndentDoc);
                    IndentDoc.SetRange("No.", IndentDoc."No.");
                    IndentDoc."Released Status" := IndentDoc."Released Status"::Released;
                    IndentDoc."Last Modified Date" := WORKDATE;
                    IndentDoc.Modify();
                    if UserSetup.Get(IndentDoc."User Id") then begin
                        UserSetup.TestField("E-Mail");
                        Recipiants.Add(UserSetup."E-Mail");
                        Body += StrSubstNo(Text001, IndentDoc."No.", IndentDoc."Document Date", IndentDoc.Purpose);
                        EmailMessage.Create(Recipiants, Sub, '', true);
                        EmailMessage.AppendToBody('Dear Indenter,');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody(Body);
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('<BR></BR>');
                        EmailMessage.AppendToBody('This is auto generated mail by system for information.');
                        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                    end;


                    IndentLine.RESET;
                    IndentLine.SETRANGE("Document No.", IndentDoc."No.");
                    IF IndentLine.FINDSET THEN
                        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::Released);

                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalIndentDoc(RecRef: RecordRef; var IsHandled: boolean)
    var
        IndentDoc: Record "Indent Header";
        IndentLine: Record "Indent Line";
    begin
        case RecRef.Number() of
            Database::"Indent Header":
                begin
                    RecRef.SetTable(IndentDoc);
                    IndentDoc.SetRange("No.", IndentDoc."No.");
                    IndentDoc."Released Status" := IndentDoc."Released Status"::"Pending Approval";
                    IndentDoc."Last Modified Date" := WorkDate();
                    IndentDoc.Modify();

                    IndentLine.RESET;
                    IndentLine.SETRANGE("Document No.", IndentDoc."No.");
                    IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
                    IF IndentLine.FIND('-') THEN
                        IndentLine.MODIFYALL("Release Status", IndentLine."Release Status"::"Pending Approval");
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryIndentDoc(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendIndentDocforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendIndentDocforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelIndentDocforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelIndentDocforApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryIndentDoc()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(IndentDocCategoryTxt, 1, 20), CopyStr(IndentDocCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsIndentDoc()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::"Indent Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateIndentDoc()
    begin
        InsertIndentDocApprovalworkflowtemplate();
    end;



    local procedure InsertIndentDocApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(IndentDocDocOCRWorkflowCodeTxt, 1, 17), CopyStr(IndentDocApprWorkflowDescTxt, 1, 100), CopyStr(IndentDocCategoryTxt, 1, 20));
        InsertIndentDocApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertIndentDocApprovalworkflowDetails(var workflow: record Workflow);
    var
        IndentDoc: Record "Indent Header";
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildIndentDoctypecondition(IndentDoc."Released Status"::Open), RunworkflowOnSendIndentDocforApprovalCode(), BuildIndentDoctypecondition(IndentDoc."Released Status"::"Pending Approval"), RunworkflowOnCancelIndentDocforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildIndentDoctypecondition(status: integer): Text
    var
        IndentDoc: Record "Indent Header";
    Begin
        IndentDoc.SetRange("Released Status", status);
        exit(StrSubstNo(IndentDocTypeCondnTxt, workflowsetup.Encode(IndentDoc.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidIndentDoc(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidIndentDoc(RecordRef)
    end;

    local procedure GetConditionalcardPageidIndentDoc(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::"Indent Header":
                exit(page::"Indent Header");
        end;
    end;
    //Indent Header Approvals End --- B2BMSOn09Sep2022<<




    //1
    //Indent Header Approvals Start --- B2BMSOn09Sep2022>>
    [IntegrationEvent(false, false)]
    Procedure OnSendIndentRequisitionDoc1ForApproval(var IndentRequisitionDoc1: Record "Indent Req Header")
    begin
    end;
    //2
    [IntegrationEvent(false, false)]
    Procedure OnCancelIndentRequisitionDoc1ForApproval(var IndentRequisitionDoc1: Record "Indent Req Header")
    begin
    end;
    //3
    //Create events for workflow
    procedure RunworkflowOnSendIndentRequisitionDoc1forApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendIndentRequisitionDoc1forApproval'), 1, 128));
    end;
    //4

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 4", 'OnSendIndentRequisitionDoc1ForApproval', '', true, true)]
    local procedure RunworkflowonsendIndentRequisitionDoc1ForApproval(var IndentRequisitionDoc1: Record "Indent Req Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendIndentRequisitionDoc1forApprovalCode(), IndentRequisitionDoc1);
    end;
    //5
    procedure RunworkflowOnCancelIndentRequisitionDoc1forApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelIndentRequisitionDoc1ForApproval'), 1, 128));
    end;
    //6
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals MGt 4", 'OnCancelIndentRequisitionDoc1ForApproval', '', true, true)]

    local procedure RunworkflowonCancelIndentRequisitionDoc1ForApproval(var IndentRequisitionDoc1: Record "Indent Req Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelIndentRequisitionDoc1forApprovalCode(), IndentRequisitionDoc1);
    end;

    //Add events to library
    //7
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryIndentRequisitionDoc1();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendIndentRequisitionDoc1forApprovalCode(), DATABASE::"Indent Req Header",
          CopyStr(IndentRequisitionDoc1sendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelIndentRequisitionDoc1forApprovalCode(), DATABASE::"Indent Req Header",
          CopyStr(IndentRequisitionDoc1requestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;
    //8
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryIndentRequisitionDoc1(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelIndentRequisitionDoc1forApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelIndentRequisitionDoc1forApprovalCode(), RunworkflowOnSendIndentRequisitionDoc1forApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendIndentRequisitionDoc1forApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendIndentRequisitionDoc1forApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendIndentRequisitionDoc1forApprovalCode());
        end;
    end;
    //9
    procedure ISIndentRequisitionDoc1workflowenabled(var IndentRequisitionDoc1: Record "Indent Req Header"): Boolean
    begin
        if (IndentRequisitionDoc1.Status <> IndentRequisitionDoc1.Status::Open) then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(IndentRequisitionDoc1, RunworkflowOnSendIndentRequisitionDoc1forApprovalCode()));
    end;
    //10
    Procedure CheckIndentRequisitionDoc1ApprovalsWorkflowEnabled(var IndentRequisitionDoc1: Record "Indent Req Header"): Boolean
    begin
        IF not ISIndentRequisitionDoc1workflowenabled(IndentRequisitionDoc1) then
            Error((NoworkfloweableErr));
        exit(true);
    end;
    //11
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnpopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentIndentRequisitionDoc1(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        IndentRequisitionDoc1: Record "Indent Req Header";
    begin
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(IndentRequisitionDoc1);
                    ApprovalEntryArgument."Document No." := IndentRequisitionDoc1."No.";
                end;
        end;
    end;

    //Handling workflow response
    //12
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onopendocument', '', true, true)]
    local procedure OnopendocumentIndentRequisitionDoc1(RecRef: RecordRef; var Handled: boolean)
    var
        IndentRequisitionDoc1: Record "Indent Req Header";
        IndentRequisitionLine: Record "Indent Requisitions";
    begin
        /* case RecRef.Number() of
             Database::"Indent Req Header":
                 begin
                     RecRef.SetTable(IndentRequisitionDoc1);
                     IndentRequisitionDoc1.SetRange("No.", IndentRequisitionDoc1."No.");
                     IndentRequisitionDoc1.Status := IndentRequisitionDoc1.Status::Open;
                     //  IndentRequisitionDoc1."Last Modified Date" := WorkDate();
                     IndentRequisitionDoc1.Modify();

                     IndentRequisitionLine.RESET;
                     IndentRequisitionLine.SETRANGE("Document No.", IndentRequisitionDoc1."No.");
                     // IndentRequisitionLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Indent);
                     IF IndentRequisitionLine.FindSet() THEN
                         IndentRequisitionLine.MODIFYALL("Release Status", IndentRequisitionLine."Release Status"::Open);
                     Handled := true;
                 end;
         end;*/
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(IndentRequisitionDoc1);
                    IndentRequisitionDoc1."Status" := IndentRequisitionDoc1."Status"::Open;
                    IndentRequisitionDoc1.Modify();
                    Handled := true;
                end;
        end;
    end;
    //13
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnreleaseDocument', '', true, true)]
    local procedure OnReleasedocumentIndentRequisitionDoc1(RecRef: RecordRef; var Handled: boolean)
    var
        IndentRequisitionDoc1: Record "Indent Req Header";
        IndentrequisitionLine: Record "Indent Requisitions";
    begin
        /* case RecRef.Number() of
             Database::"Indent Req Header":
                 begin
                     RecRef.SetTable(IndentRequisitionDoc1);
                     IndentRequisitionDoc1.SetRange("No.", IndentRequisitionDoc1."No.");
                     IndentRequisitionDoc1.Status := IndentRequisitionDoc1.Status::Release;
                     //    IndentRequisitionDoc1."Last Modified Date" := WORKDATE;
                     IndentRequisitionDoc1.Modify();

                     IndentRequisitionLine.RESET;
                     IndentRequisitionLine.SETRANGE("Document No.", IndentRequisitionDoc1."No.");
                     IF IndentRequisitionLine.FINDSET THEN
                         IndentRequisitionLine.MODIFYALL("Release Status", IndentRequisitionLine."Release Status"::Released);

                     Handled := true;
                 end;
         end;*/
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(IndentRequisitionDoc1);
                    IndentRequisitionDoc1."Status" := IndentRequisitionDoc1."Status"::Release;
                    IndentRequisitionDoc1.Modify();
                    Handled := true;
                end;
        end;
    end;
    //14
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'Onsetstatustopendingapproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalIndentRequisitionDoc1(RecRef: RecordRef; var IsHandled: boolean)
    var
        IndentRequisitionDoc1: Record "Indent Req Header";
        IndentRequisitionLine: Record "Indent Requisitions";
    begin
        /* case RecRef.Number() of
             Database::"Indent Req Header":
                 begin
                     RecRef.SetTable(IndentRequisitionDoc1);
                     IndentRequisitionDoc1.SetRange("No.", IndentRequisitionDoc1."No.");
                     IndentRequisitionDoc1.Status := IndentRequisitionDoc1.Status::"Pending Approval";
                     // IndentRequisitionDoc1."Last Modified Date" := WorkDate();
                     IndentRequisitionDoc1.Modify();

                     IndentRequisitionLine.RESET;
                     IndentRequisitionLine.SETRANGE("Document No.", IndentRequisitionDoc1."No.");
                     IndentRequisitionLine.SETRANGE("Indent Status", IndentRequisitionLine."Indent Status"::Indent);
                     IF IndentRequisitionLine.FindSet() THEN
                         IndentRequisitionLine.MODIFYALL("Release Status", IndentRequisitionLine."Release Status"::"Pending Approval");
                     IsHandled := true;
                 end;
         end;*/
        case RecRef.Number() of
            Database::"Indent Req Header":
                begin
                    RecRef.SetTable(IndentRequisitionDoc1);
                    IndentRequisitionDoc1."Status" := IndentRequisitionDoc1."Status"::"Pending Approval";
                    IndentRequisitionDoc1.Modify();
                    IsHandled := true;
                end;
        end;
    end;
    //15
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'Onaddworkflowresponsepredecessorstolibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryIndentRequisitionDoc1(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendIndentRequisitionDoc1forApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendIndentRequisitionDoc1forApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelIndentRequisitionDoc1forApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelIndentRequisitionDoc1forApprovalCode());
        end;
    end;

    //Setup workflow
    //16
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddworkflowcategoriestolibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryIndentRequisitionDoc1()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(IndentRequisitionDoc1CategoryTxt, 1, 20), CopyStr(IndentRequisitionDoc1CategoryDescTxt, 1, 100));
    end;
    //17
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Onafterinsertapprovalstablerelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsIndentRequisitionDoc1()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::"Indent Req Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;
    //18
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'Oninsertworkflowtemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateIndentRequisitionDoc1()
    begin
        InsertIndentRequisitionDoc1Approvalworkflowtemplate();
    end;
    //19


    local procedure InsertIndentRequisitionDoc1Approvalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(IndentRequisitionDoc1DocOCRWorkflowCodeTxt, 1, 17), CopyStr(IndentRequisitionDoc1ApprWorkflowDescTxt, 1, 100), CopyStr(IndentRequisitionDoc1CategoryTxt, 1, 20));
        InsertIndentRequisitionDoc1ApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertIndentRequisitionDoc1ApprovalworkflowDetails(var workflow: record Workflow);
    var
        IndentRequisitionDoc1: Record "Indent Req Header";
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildIndentRequisitionDoc1typecondition(IndentRequisitionDoc1.Status::Open), RunworkflowOnSendIndentRequisitionDoc1forApprovalCode(), BuildIndentRequisitionDoc1typecondition(IndentRequisitionDoc1.Status::"Pending Approval"), RunworkflowOnCancelIndentRequisitionDoc1forApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildIndentRequisitionDoc1typecondition(status: integer): Text
    var
        IndentRequisitionDoc1: Record "Indent Req Header";
    Begin
        IndentRequisitionDoc1.SetRange(status, status);
        exit(StrSubstNo(IndentRequisitionDoc1TypeCondnTxt, workflowsetup.Encode(IndentRequisitionDoc1.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'Onaftergetpageid', '', true, true)]
    local procedure OnaftergetpageidIndentRequisitionDoc1(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidIndentRequisitionDoc1(RecordRef)
    end;

    local procedure GetConditionalcardPageidIndentRequisitionDoc1(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::"Indent Req Header":
                exit(page::"Indent Requisition Document");
        end;
    end;
    //Indent Header Approvals End --- B2BMSOn09Sep2022<<
    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowevenHandling: Codeunit "Workflow Event Handling";
        workflowsetup: codeunit "Workflow Setup";

        //b2besg  Start Variables for QC
        QuoteComparisionCussendforapprovaleventdescTxt: Label 'Approval of a QuoteComparisionCus Document is requested';
        QuoteComparisionCusCategoryDescTxt: Label 'QuoteComparisionCusDocuments';
        QuoteComparisionCusTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=QuoteComparisionCus>%1</DataItem></DataItems></ReportParameters>';
        QuoteComparisionCusrequestcanceleventdescTxt: Label 'Approval of a QuoteComparisionCus Document is Cancelled';
        QuoteComparisionCusCategoryTxt: Label 'QuoteComparisionCus specifications';
        QuoteComparisionCusDocOCRWorkflowCodeTxt: Label 'QC QuoteComparisionCus';
        QuoteComparisionCusApprWorkflowDescTxt: Label 'QuoteComparisionCus Approval Workflow';
        NoworkfloweableErr: Label 'No work flows enabled';
        //b2besg  End Variables for QC

        //Indent Header Approvals Variables Start --- B2BMSOn09Sep2022>>
        IndentDocsendforapprovaleventdescTxt: Label 'Approval of a IndentDoc Document is requested';
        IndentDocCategoryDescTxt: Label 'IndentDocDocuments';
        IndentDocTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=IndentDoc>%1</DataItem></DataItems></ReportParameters>';
        IndentDocrequestcanceleventdescTxt: Label 'Approval of a IndentDoc Document is Cancelled';
        IndentDocCategoryTxt: Label 'IndentDoc specifications';
        IndentDocDocOCRWorkflowCodeTxt: Label 'QC IndentDoc';
        IndentDocApprWorkflowDescTxt: Label 'IndentDoc Approval Workflow';
        //Indent Header Approvals Variables End --- B2BMSOn09Sep2022<<


        //IndentRequisition Header Approvals Variables Start --- B2BMSOn09Sep2022>>
        IndentRequisitionDoc1sendforapprovaleventdescTxt: Label 'Approval of a IndentRequisitionDoc Document is requested';
        IndentRequisitionDoc1CategoryDescTxt: Label 'IndentRequisitionDocDocuments';
        IndentRequisitionDoc1TypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=IndentRequisitionDoc>%1</DataItem></DataItems></ReportParameters>';
        IndentRequisitionDoc1requestcanceleventdescTxt: Label 'Approval of a IndentRequisitionDoc Document is Cancelled';
        IndentRequisitionDoc1CategoryTxt: Label 'IndentRequisitionDoc specifications';
        IndentRequisitionDoc1DocOCRWorkflowCodeTxt: Label 'IndentRequisitionDoc';
        IndentRequisitionDoc1ApprWorkflowDescTxt: Label 'IndentRequisitionDoc Approval Workflow';
    //IndentRequisition Header Approvals Variables End --- B2BMSOn09Sep2022<<
}