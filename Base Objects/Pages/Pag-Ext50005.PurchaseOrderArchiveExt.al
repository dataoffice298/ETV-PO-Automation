pageextension 50046 "Purchase Order Archive Ext" extends "Purchase Order Archive"
{
    layout
    {
        addafter(Status)
        {

            field(Regularization; Rec.Regularization)
            {
                ApplicationArea = All;
                Caption = 'Regularization';
                ToolTip = 'Specify The Document Regularization';
            }
        }
    }
    actions
    {
        addafter("Ver&sion")
        {
            action(PrintAmendementCumRegularization)
            {
                ApplicationArea = Suite;
                Caption = 'Print Ammendement Cum Order';
                Ellipsis = true;
                Image = PrintReport;
                ToolTip = 'Prepare to print the Ammendement Cum Order document. The report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    PurchaseHeaderArchive: Record "Purchase Header Archive";
                    RegErr: Label 'This is not a Ammendement Cum order';
                begin
                    if not Rec.Regularization then
                        Error(RegErr);
                    PurchaseHeaderArchive.Reset();
                    PurchaseHeaderArchive.SetRange("Document Type", Rec."Document Type");
                    PurchaseHeaderArchive.SetRange("No.", Rec."No.");
                    PurchaseHeaderArchive.SetRange("Version No.", Rec."Version No.");
                    Report.RunModal(Report::"Ammendement Cum Regularization", true, false, PurchaseHeaderArchive);
                end;
            }
            action(AmmendementOrder)
            {
                ApplicationArea = Suite;
                Caption = 'Print Ammendement Order';
                Ellipsis = true;
                Image = PrintReport;
                ToolTip = 'Prepare to print the Purchase Order. The report request window for the document opens where you can specify what to include on the print-out.';
                trigger OnAction()
                var
                    PurchaseHeaderArchive: Record "Purchase Header Archive";
                begin
                    PurchaseHeaderArchive.Reset();
                    PurchaseHeaderArchive.SetRange("Document Type", Rec."Document Type");
                    PurchaseHeaderArchive.SetRange("No.", Rec."No.");
                    PurchaseHeaderArchive.SetRange("Version No.", Rec."Version No.");
                    Report.RunModal(Report::"Ammendement Order", true, false, PurchaseHeaderArchive);
                end;
            }
        }
    }
}
