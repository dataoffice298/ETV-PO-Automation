pageextension 50111 PostedPurchRcptSubform extends "Posted Purchase Rcpt. Subform"
{
    Editable = false;
    layout
    {
        addafter(Description)
        {
            //B2BVCOn03Oct22>>>
            field("Ref. Posted Gate Entry"; Rec."Ref. Posted Gate Entry")
            {
                ApplicationArea = all;
            }
            //B2BVCOn03Oct22<<<
            field("Rejection Comments B2B"; "Rejection Comments B2B")
            {
                ApplicationArea = all;
            }
            field("Spec Id"; rec."Spec Id")
            {
                ApplicationArea = all;
            }
            field("Indentor Description"; Rec."Indentor Description")//B2BSSD07Feb2023
            {
                ApplicationArea = All;
                Caption = 'Indentor Description';
            }
            field(warranty; Rec.warranty)//B2BSSD10Feb2023
            {
                ApplicationArea = All;
                Caption = 'warranty';
            }
        }
    }
    //B2BSSD10Feb2023<<
    actions
    {
        addafter(ItemInvoiceLines)
        {
            action("Item TechnicalSpec")
            {
                ApplicationArea = All;
                Image = Import;
                Caption = 'Specification';
                RunObject = page TechnicalSpecifications;
                RunPageLink = "Document No." = field("Indent No."), "Line No." = field("Indent Line No."),
                "Item No." = field("No.");
                trigger OnAction()
                var
                begin

                end;
            }
        }
    }
    //B2BSSD10Feb2023>>


    // //B2BSSD07Feb2023<<
    // actions
    // {
    //     addlast("&Line")
    //     {
    //         action("Import&Export")
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Import & Export';
    //             Image = ImportExport;
    //             trigger OnAction()
    //             var
    //                 PostedPurchReceip: Record "Purch. Rcpt. Line";
    //             begin
    //                 PostedPurchReceip.Reset();
    //                 PostedPurchReceip.SetRange("Document No.", Rec."Document No.");
    //                 Xmlport.Run(50500, true, false, PostedPurchReceip);
    //             end;
    //         }
    //     }
    // }
    // //B2BSSD07Feb2023>>
    var
        myInt: Integer;
}