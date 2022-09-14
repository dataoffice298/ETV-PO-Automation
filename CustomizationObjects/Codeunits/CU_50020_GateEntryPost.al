codeunit 50020 "Gate Entry- Post Yes/No"
{
    // version NAVIN7.10

    TableNo = "Gate Entry Header_B2B";

    trigger OnRun();
    begin
        GateEntryHeader.COPY(Rec);
        Code;
        Rec := GateEntryHeader;
    end;

    var
        Text16500: Label 'Do you want to Post the Gate Entry?';
        GateEntryHeader: Record "Gate Entry Header_B2B";
        GateEntryPost: Codeunit "Gate Entry- Post";
        Text16501: Label 'Gate Entry Posted successfully.';
        PostdGatEntHdr: Record "Posted Gate Entry Header_B2B";
        printReport: Boolean;

    local procedure "Code"();
    var
        PostedGateEntryHeader: Record "Posted Gate Entry Header_B2B";
    begin
        if not CONFIRM(Text16500, false) then
            exit;
        GateEntryPost.RUN(GateEntryHeader);
        if printReport then begin
            PostedGateEntryHeader.Reset();
            PostedGateEntryHeader.SetRange("Entry Type", GateEntryHeader."Entry Type");
            PostedGateEntryHeader.SetRange("Gate Entry No.", GateEntryHeader."No.");
            if PostedGateEntryHeader.FindLast() then
                Report.Run(50047, false, true, PostedGateEntryHeader);
        end;
        COMMIT;
        Message(Text16501);
    end;

    procedure SetValues(Print: Boolean)
    begin
        printReport := Print;
    end;


}

