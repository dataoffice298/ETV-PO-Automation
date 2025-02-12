page 50201 "Cancelled Purchase Order"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Header";
    CardPageId = "Purchase Order";
    Caption = 'Cancelled Purchase Order';
    SourceTableView = where("Document Type" = CONST(Order), "Cancelled Order" = const(true));
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a unique number that identifies the purchase order. The number can be generated automatically from a number series, or you can number each of them manually.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor who will deliver the goods or services. Each vendor has a unique number to help you track related documents. The number can come from a number series or be added manually.';
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the vendor that you’re buying from. By default, the same vendor is suggested as the pay-to vendor. If needed, you can specify a different pay-to vendor on the document.';
                }
                field("Vendor Authorization No."; Rec."Vendor Authorization No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the compensation agreement identification number, sometimes referred to as the RMA No. (Returns Materials Authorization).';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the record is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sum of amounts on all the lines in the document. This will include invoice discounts.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sum of amounts, including VAT, on all the lines in the document. This will include invoice discounts.';
                }

            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}