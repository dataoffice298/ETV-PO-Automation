page 50188 CWIP
{
    PageType = Document;
    UsageCategory = None;
    SourceTable = "CWIP Header";
    Caption = 'CWIP';
    PromotedActionCategories = 'New,Process,Report,Approvals';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = Rec.Status = Rec.Status::Open;
                Caption = 'General';
                field("No.";
                Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Caption = 'No.';
                    ApplicationArea = All;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                    Caption = 'Vendor No.';
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                    Caption = 'Vendor Name';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Item Name"; Rec."Item Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Name field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                    Caption = 'Posting Date';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    Caption = 'Created By';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                    Caption = 'Shortcut Dimension 2 Code';
                }
            }
            part(CWIPLines; "CWIP Subform")
            {
                ApplicationArea = all;
                Caption = 'CWIP Lines';
                SubPageLink = "Document No." = field("No.");
                Editable = Rec.Status = Rec.Status::Open;
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action("Get Lines")
                {
                    ApplicationArea = All;
                    Image = GetLines;
                    ToolTip = 'Executes the Get Lines action.';
                    Caption = 'Get Lines';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        Rec.GetLedgerEntries();
                    end;
                }
                action("Create Fixed Assets")
                {
                    ApplicationArea = All;
                    Caption = 'Create Fixed Assets';
                    ToolTip = 'Executes the Create Fixed Assets action.';
                    Image = ExecuteBatch;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.CreateFixedAssetsFromLines();
                    end;
                }

                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'Post';
                    Image = Post;
                    ToolTip = 'Executes the Post action.';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        Rec.PostDocument();
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim();
                        CurrPage.SaveRecord();
                    end;
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                action("Re-Open")
                {
                    ApplicationArea = All;
                    Image = ReOpen;
                    ToolTip = 'Executes the Re-Open action.';
                    Caption = 'Re-Open';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        Rec.ReOpenDocument();
                    end;
                }
                action("Release")
                {
                    ApplicationArea = All;
                    Image = ReleaseDoc;
                    ToolTip = 'Executes the Release action.';
                    Caption = 'Release';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        Rec.ReleaseDocument();
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = All;
                    Image = Action;
                    Visible = OpenAppEntrExistsForCurrUser;
                    ToolTip = 'Executes the Approve action.';
                    Caption = 'Approve';
                    Promoted = true;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    begin
                        ApprovalMgt.ApproveRecordApprovalRequest(Rec.RecordId());
                    end;
                }

                action("Send Approval Request")
                {
                    ApplicationArea = All;
                    Image = SendApprovalRequest;
                    Visible = Not OpenApprEntrEsists and CanrequestApprovForFlow;
                    ToolTip = 'Executes the Send Approval Request action.';
                    Caption = 'Send Approval Request';
                    Promoted = true;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    begin
                        IF CWIPApproval.CheckCWIPApprovalsWorkflowEnabled(Rec) then
                            CWIPApproval.OnSendCWIPForApproval(Rec);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = All;
                    Image = CancelApprovalRequest;
                    Visible = CanCancelapprovalforrecord or CanCancelapprovalforflow;
                    ToolTip = 'Executes the Cancel Approval Request action.';
                    Caption = 'Cancel Approval Request';
                    Promoted = true;
                    PromotedCategory = Category4;
                    trigger OnAction()
                    begin
                        CWIPApproval.OnCancelCWIPForApproval(rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OpenAppEntrExistsForCurrUser := ApprovalMgt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId());
        OpenApprEntrEsists := ApprovalMgt.HasOpenApprovalEntries(Rec.RecordId());
        CanCancelapprovalforrecord := ApprovalMgt.CanCancelApprovalForRecord(Rec.RecordId());
        workflowwebhookmangt.GetCanRequestAndCanCancel(Rec.RecordId(), CanrequestApprovForFlow, CanCancelapprovalforflow);
    end;

    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        CWIPApproval: Codeunit CWIP;
        workflowwebhookmangt: Codeunit "Workflow Webhook Management";
        OpenAppEntrExistsForCurrUser: Boolean;
        OpenApprEntrEsists: Boolean;
        CanCancelapprovalforrecord: Boolean;
        CanCancelapprovalforflow: Boolean;
        CanrequestApprovForFlow: Boolean;
}