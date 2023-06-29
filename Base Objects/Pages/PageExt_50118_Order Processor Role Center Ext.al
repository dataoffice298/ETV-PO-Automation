pageextension 50118 OrderRoleCenterExt extends "Order Processor Role Center"//B2BSSD12APR2023
{

    actions
    {
        addafter("India Taxation")
        {
            group("ETV PO AUTOMATION")
            {
                action(CurrentStockReport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Current Stock Report';
                    Image = "Report";
                    RunObject = Report "Current Stock Report";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action(MaterialIssueSlip)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Material Issue Slip';
                    Image = "Report";
                    RunObject = Report "Material Issue Slip";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action(INWARDRECEIPT)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'INWARD RECEIPT';
                    Image = "Report";
                    RunObject = Report "INWARD RECEIPT";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action(GRNRECEIPT)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'GRN RECEIPT';
                    Image = "Report";
                    RunObject = Report "GRN RECEIPT";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action(PurchaseEnquiry)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Purchase Enquiry';
                    Image = "Report";
                    RunObject = Report "Purchase Enquiry B2B";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action(QuotationComparison)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quotation Comparison';
                    Image = "Report";
                    RunObject = Report "Quotation Comparision";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action(Indent)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Indent';
                    Image = "Report";
                    RunObject = Report Indent;
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Aging of Items Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Aging of Items Report';
                    Image = "Report";
                    RunObject = Report "Aging of Items Report";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Issuance Report(Consumption)")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Issuance Report(Consumption)';
                    Image = "Report";
                    RunObject = Report "Issuance Report";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action(POReport)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'PO Report';
                    Image = "Report";
                    RunObject = Report "Po Report";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("OPen Po Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'OPen Po Report';
                    Image = "Report";
                    RunObject = Report "OPen Po Report";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("User Indent Status Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Indent Status Report';
                    Image = "Report";
                    RunObject = Report "User Indent Status Report";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Inward Receipt Details")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inward Receipt Details';
                    Image = "Report";
                    RunObject = Report "Inward Receipt Details";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("QC Pending GRN Pending Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'QC Pending GRN Pending Report';
                    Image = "Report";
                    RunObject = Report "QC Pending GRN Pending Report";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Sub Store Transfer")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sub Store Transfer';
                    Image = "Report";
                    RunObject = Report "Sub Store Transfer";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("In Transit")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'In Transit Report';
                    Image = "Report";
                    RunObject = Report "In Transit";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Non Returnable Gatepass_50181")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Non Returnable Gatepass';
                    Image = "Report";
                    RunObject = Report "Non Returnable Gatepass";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Regularization Order_50182")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Regularization Order';
                    Image = "Report";
                    RunObject = Report "Non Returnable Gatepass";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Returnable Gatepass_50183")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Returnable Gatepass';
                    Image = "Report";
                    RunObject = Report "Returnable Gatepass";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Returnable Gatepass Return Receipt_50184")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Returnable Gatepass Return Receipt';
                    Image = "Report";
                    RunObject = Report "Return Gatepass Return Rcpt";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Return Receipt Gatepass-F6")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Return Receipt Gatepass-F6';
                    Image = "Report";
                    RunObject = Report "Return Receipt Gatepass";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("NonReturnable Gatepass-F4")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'NonReturnable Gatepass-F4';
                    Image = "Report";
                    RunObject = Report "NonReturnable Gatepass";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Returnable Gatepass-F2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Returnable Gatepass-F2';
                    Image = "Report";
                    RunObject = Report "Returnable Gatepass Reg";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Assets Tracking Status_50190")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Assets Tracking Status_50190';
                    Image = "Report";
                    RunObject = Report "FixedAssets&Item LocationWise";//B2BSSD23MAY2023
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("PO FORMAT")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'PO FORMAT';
                    Image = "Report";
                    RunObject = Report "PO FORMAT";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Shortage Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Shortage Report';
                    Image = "Report";
                    RunObject = Report "Shortage Report";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
                action("Quant Explo of BOM In Indent")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quant Explo of BOM In Indent';
                    Image = "Report";
                    RunObject = Report "Quant Explo of BOM In Indent";
                    ToolTip = 'View your company''s assets, liabilities, and equity.';
                }
            }
        }
    }
    var
        myInt: Integer;
}