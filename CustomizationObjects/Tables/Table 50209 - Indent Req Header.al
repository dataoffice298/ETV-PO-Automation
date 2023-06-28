table 50209 "Indent Req Header"
{
    // version PH1.0,PO1.0

    LookupPageID = "Indent Requisition List";

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchaseSetup.GET;
                    NoSeriesMgt.TestManual(PurchaseSetup."Indent Req No.");
                    "No.Series" := '';
                END;
            end;
        }
        field(10; "Document Date"; Date)
        {

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(11; "Resposibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center";

            trigger OnValidate();
            begin
                TestStatusOpen;
            end;
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionMembers = " ",Open,Release,"Pending Approval";
        }
        field(13; "No.Series"; Code[20])
        {
            TableRelation = "No. Series";

            trigger OnLookup();
            begin
                PurchaseSetup.GET;
                IF Type = Type::Enquiry THEN
                    Noseries.SETRANGE(Code, PurchaseSetup."Enquiry Nos.")
                ELSE
                    IF Type = Type::Quote THEN
                        Noseries.SETRANGE(Code, PurchaseSetup."Quote Nos.")
                    ELSE
                        Noseries.SETRANGE(Code, PurchaseSetup."Order Nos.");
                IF PAGE.RUNMODAL(458, Noseries) = ACTION::LookupOK THEN
                    "No.Series" := Noseries."Series Code";
            end;
        }
        field(14; Type; Option)
        {
            OptionMembers = Enquiry,Quote,"Order";
        }
        field(15; "Indent Type"; Option)
        {
            Caption = 'Indent Type';
            Description = 'B2BESGOn02Jun2022';
            Editable = false;
            OptionCaption = ' ,IT,Non-IT';
            OptionMembers = " ",IT,"Non-IT";
        }
        field(16; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Description = 'B2BESGOn02Jun2022';
            TableRelation = Currency;
        }
        field(17; "RFQ No."; code[20])
        {
            Caption = 'RFQ No.';
            Description = 'B2BESGOn02Jun2022';
        }
        field(50001; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
            Blocked = CONST(false));

            trigger OnValidate()
            begin
                IndentHdr.Reset();
                IndentHdr.SetRange("No.", "No.");
                IF IndentHdr.FIND('-') THEN BEGIN
                    repeat
                        IndentHdr."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                        IndentHdr.Modify();
                    until IndentHdr.Next = 0;
                end;
            END;
        }
        field(50002; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2), Blocked = CONST(false));
        }
        //B2BSSD20Feb2023<<
        field(50003; "Shortcut Dimension 9 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(9), Blocked = CONST(false));
        }
        //B2BSSD20Feb2023>>

        field(50004; "programme Name"; Code[50])//B2BSSD20MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50005; Purpose; Text[250])//B2BSSD21MAR2023
        {
            DataClassification = CustomerContent;
        }
        field(50006; "Create Purchase Order"; Boolean)//B2BSSD09MAY2023
        {
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnInsert();
    begin
        PurchaseSetup.GET;
        IF "No." = '' THEN BEGIN
            PurchaseSetup.TESTFIELD("Indent Req No.");
            NoSeriesMgt.InitSeries(PurchaseSetup."Indent Req No.", xRec."No.Series", 0D, "No.", "No.Series");
            "No.Series" := ''
        END;
        "Document Date" := TODAY;
    end;

    var
        PurchaseSetup: Record 312;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IndentReq: Record "Indent Req Header";
        OldIndentReq: Record "Indent Req Header";
        Noseries: Record 310;
        IndentHdr: Record "Indent Header";
        IndentLine: Record "Indent Line";

    procedure AssistEdit(OldIndentReq: Record "Indent Req Header"): Boolean;
    begin
        IndentReq := Rec;
        PurchaseSetup.GET;
        PurchaseSetup.TESTFIELD("Indent Req No.");
        IF NoSeriesMgt.SelectSeries(PurchaseSetup."Indent Req No.", OldIndentReq."No.", IndentReq."No.") THEN BEGIN
            PurchaseSetup.GET;
            PurchaseSetup.TESTFIELD("Indent Req No.");
            NoSeriesMgt.SetSeries(IndentReq."No.");
            Rec := IndentReq;
            EXIT(TRUE);
        END;
    end;

    procedure TestStatusOpen();
    begin
        TESTFIELD(Status, Status::Open);
    end;
}

