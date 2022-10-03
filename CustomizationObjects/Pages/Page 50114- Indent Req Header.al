page 50114 "Indent Req Header"
{
    // version PO1.0,REP1.0

    Caption = 'Indent Requisition';
    PageType = ListPlus;
    SourceTable = "Indent Req Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit();
                    begin
                        Rec.AssistEdit(Rec);
                    end;
                }
                field("Resposibility Center"; Rec."Resposibility Center")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No.Series"; Rec."No.Series")
                {
                    ApplicationArea = All;
                }
            }
            part("Purchase Req Line"; 50117)
            {
                //SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("Enquiry/ Quote/ Order")
                {
                    Caption = 'Enquiry/ Quote/ Order';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        CurrPage."Purchase Req Line".PAGE.ShowDocument;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Get Requisition Lines")
                {
                    Caption = 'Get Requisition Lines';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        // SM 05/06/08
                        /*
                        IndentReqLines.GetValue("No.","Resposibility Center");
                        IndentReqLines.RUN;
                        *///REP1.0

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
                        Rec.TESTFIELD(Status, Rec.Status::Release);
                        Rec.TESTFIELD(Type, Rec.Type::Enquiry);
                        Carry := 0;
                        IndentReqLine.RESET;
                        IndentReqLine.SETRANGE("Document No.", Rec."No.");
                        IF IndentReqLine.FIND('-') THEN
                            REPEAT
                                IF IndentReqLine."Carry out Action" THEN
                                    Carry += 1;
                            UNTIL IndentReqLine.NEXT = 0;
                        IF Carry <= 0 THEN
                            ERROR('Carry out action should not be blank');
                        IF IndentReqLine.FIND('-') THEN BEGIN
                            IF NOT CONFIRM(Text003) THEN
                                EXIT;
                            CreateIndents.RESET;
                            CreateIndents.SETRANGE("Document No.", Rec."No.");
                            CreateIndents.SETRANGE("Carry out Action", TRUE);
                            CLEAR(VendorList);
                            VendorList.LOOKUPMODE(TRUE);
                            VendorList.RUNMODAL;
                            VendorList.SetSelection(Vendor);
                            IF Vendor.COUNT >= 1 THEN BEGIN
                                POAutomation.CreateEnquiries(CreateIndents, Vendor, Rec."No.Series");
                                MESSAGE(text0010)
                            END ELSE
                                EXIT;
                        END;
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
                        Rec.TESTFIELD(Status, Rec.Status::Release);
                        Rec.TESTFIELD(Type, Rec.Type::Quote);
                        Carry := 0;
                        IndentReqLine.RESET;
                        IndentReqLine.SETRANGE("Document No.", Rec."No.");
                        IF IndentReqLine.FIND('-') THEN
                            REPEAT
                                IF IndentReqLine."Carry out Action" THEN
                                    Carry += 1;
                            UNTIL IndentReqLine.NEXT = 0;
                        IF Carry <= 0 THEN
                            ERROR('Carry out action should not be blank');
                        IF IndentReqLine.FIND('-') THEN BEGIN
                            IF NOT CONFIRM(Text004) THEN
                                EXIT;
                            CreateIndents.RESET;
                            CreateIndents.SETRANGE("Document No.", Rec."No.");
                            CreateIndents.SETRANGE("Carry out Action", TRUE);
                            CLEAR(VendorList);
                            VendorList.LOOKUPMODE(TRUE);
                            VendorList.RUNMODAL;
                            VendorList.SetSelection(Vendor);
                            IF Vendor.COUNT >= 1 THEN BEGIN
                                POAutomation.CreateQuotes(CreateIndents, Vendor, Rec."No.Series");
                                MESSAGE(text0011)
                            END ELSE
                                EXIT;
                        END;
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
                        Rec.TESTFIELD(Status, Rec.Status::Release);
                        Rec.TESTFIELD(Type, Rec.Type::Order);
                        Carry := 0;
                        IndentReqLine.RESET;
                        IndentReqLine.SETRANGE("Document No.", Rec."No.");
                        IndentReqLine.SETRANGE(IndentReqLine."Order No", '');
                        IF IndentReqLine.FIND('-') THEN
                            REPEAT
                                IF IndentReqLine."Carry out Action" THEN
                                    Carry += 1;
                            UNTIL IndentReqLine.NEXT = 0;
                        IF Carry <= 0 THEN
                            ERROR('Carry out action should not be blank or Orders already created');
                        IF IndentReqLine.FIND('-') THEN BEGIN
                            IF NOT CONFIRM(Text005) THEN
                                EXIT;
                            CreateIndents.RESET;
                            CreateIndents.SETRANGE("Document No.", Rec."No.");
                            CreateIndents.SETRANGE("Carry out Action", TRUE);
                            CLEAR(VendorList);
                            VendorList.LOOKUPMODE(TRUE);
                            VendorList.RUNMODAL;
                            VendorList.SetSelection(Vendor);
                            IF Vendor.COUNT >= 1 THEN BEGIN
                                POAutomation.CreateOrder(CreateIndents, Vendor, Rec."No.Series");
                                MESSAGE(Text001);
                            END ELSE
                                EXIT;
                        END;
                    end;
                }
                separator("Process1")
                {
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Document Date");
                        IF Rec.Status = Rec.Status::Release THEN
                            EXIT
                        ELSE BEGIN
                            Rec.Status := Rec.Status::Release;
                            Rec.MODIFY;
                        END;
                    end;
                }
                action("Re&Open")
                {
                    Caption = 'Re&Open';
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        IF Rec.Status = Rec.Status::Open THEN
                            EXIT
                        ELSE BEGIN
                            IndentReqLine.RESET;
                            IndentReqLine.SETRANGE("Document No.", Rec."No.");
                            IndentReqLine.SETFILTER("Order No", '%1', '');
                            IF IndentReqLine.FINDFIRST THEN BEGIN
                                Rec.Status := Rec.Status::Open;
                                Rec.MODIFY;
                            END;
                        END
                    end;
                }
            }
        }
    }

    var
        Carry: Integer;
        IndentReqHeader: Record 50045;
        IndentReqLine: Record 50038;
        POAutomation: Codeunit 50026;
        CreateIndents: Record 50038;
        text0010: Label 'Enquiries Created Successfully';
        Text003: Label 'Do you want to create Enquiries?';
        Text004: Label 'Do you want to create Quotations?';
        Text005: Label 'Do you want to create Orders?';
        Vendor: Record 23;
        VendorList: Page 27;
        text0011: Label 'Quotes Created Successfully';
        PurchaseOrder: Record 38;
        Usermgt: Codeunit 5700;
}

