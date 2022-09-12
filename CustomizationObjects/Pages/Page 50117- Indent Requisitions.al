page 50117 "Indent Requisitions"
{
    // version PH1.0,PO1.0

    // Resource : SM  SivaMohan
    // 
    // SM  PO1.0    05/06/08   ShowDocument fucntion added

    Caption = 'PO Creation';
    DelayedInsert = true;
    Editable = true;
    InsertAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Indent Requisitions";
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater("Controls")
            {
                field("Indent No."; Rec."Indent No.")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Carry out Action"; Rec."Carry out Action")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("Indent Line No."; Rec."Indent Line No.")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field("No.Series"; Rec."No.Series")
                {
                    ApplicationArea = All;
                }
                
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Requisitions")
            {
                Caption = '&Requisitions';
                Visible = true;
                action("Get Requisition Lines")
                {
                    Caption = 'Get Requisition Lines';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        POAutomation.GetIndentLines;
                        CurrPage.UPDATE;
                    end;
                }
                separator("Process")
                {
                }
                action("Create &Enquiry")
                {
                    Caption = 'Create &Enquiry';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        Carry := 0;
                        IF Rec.FIND('-') THEN
                            REPEAT
                                IF Rec."Carry out Action" THEN
                                    Carry += 1;
                            UNTIL Rec.NEXT = 0;
                        IF Carry <= 0 THEN
                            ERROR('Carry out action should not be blank');
                        Rec.RESET;
                        IF Rec.FIND('-') THEN BEGIN
                            IF NOT CONFIRM(Text003) THEN
                                EXIT;
                            CreateIndents.RESET;
                            CreateIndents.SETRANGE("Carry out Action", TRUE);
                            //POAutomation.CreateEnquiries(CreateIndents);//SM "u have to pass  parameters"
                            MESSAGE(text0010);
                        END;
                        Rec.DELETEALL;
                    end;
                }
                action("Create &Quote")
                {
                    Caption = 'Create &Quote';
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        Text001: Label 'Quotes are created successfully.';
                    begin
                        Carry := 0;
                        IF Rec.FIND('-') THEN
                            REPEAT
                                IF Rec."Carry out Action" THEN
                                    Carry += 1;
                            UNTIL Rec.NEXT = 0;
                        IF Carry <= 0 THEN
                            ERROR('Carry out action should not be blank');
                        Rec.RESET;
                        IF Rec.FIND('-') THEN BEGIN
                            IF NOT CONFIRM(Text004) THEN
                                EXIT;
                            CreateIndents.RESET;
                            CreateIndents.SETRANGE("Carry out Action", TRUE);
                            //POAutomation.CreateQuotes(CreateIndents);//SM "u have to pass  parameters"
                            MESSAGE(Text001);
                        END;
                        Rec.DELETEALL;
                    end;
                }
                action("Create &Purchase Order")
                {
                    Caption = 'Create &Purchase Order';
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        Text001: Label 'Orders are created successfully.';
                    begin
                        Carry := 0;
                        IF Rec.FIND('-') THEN
                            REPEAT
                                IF Rec."Carry out Action" THEN BEGIN
                                    Rec.TESTFIELD("Vendor No.");
                                    Rec.TESTFIELD("No.Series");
                                    Carry += 1;
                                END;
                            UNTIL Rec.NEXT = 0;
                        IF Carry <= 0 THEN
                            ERROR('Carry out action should not be blank');
                        Rec.RESET;
                        IF Rec.FIND('-') THEN BEGIN
                            IF NOT CONFIRM(Text005) THEN
                                EXIT;
                            CreateIndents.RESET;
                            CreateIndents.SETRANGE("Carry out Action", TRUE);
                            // POAutomation.CreateOrder(CreateIndents);//SM "u have to pass  parameters"
                            MESSAGE(Text001);
                        END;
                        Rec.DELETEALL;
                    end;
                }
            }
        }
    }

    var
        POAutomation: Codeunit 50026;
        text0010: Label 'Enquiries Created Successfully';
        Text003: Label 'Do you want to create Enquiries?';
        Text004: Label 'Do you want to create Quotations?';
        CreateIndents: Record 50038;
        Indent: Text[1024];
        Text005: Label 'Do you want to create Orders?';
        Carry: Integer;
        PurchaseOrder: Record 38;

    procedure ShowDocument();
    begin
        //<<PO1.0
        PurchaseOrder.RESET;
        PurchaseOrder.SETRANGE("Indent Requisition No", Rec."Document No.");
        //PurchaseOrder.SETRANGE("No.","Order No");
        PAGE.RUNMODAL(0, PurchaseOrder);
        //>>PO1.0
    end;
}

