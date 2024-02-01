report 50195 QRReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './QRReport.rdl';
    DefaultLayout = RDLC;
    Caption = 'QR Report';

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            column(No_; "No.")
            { }
            column(Qr_Code; "Qr Code")
            { }
            column(Serial_No_; SerialNoGVar)
            { }
            column(Make_B2B; MakeB2BGvar)
            { }

            column(Model_No_; ModelNoGVar)
            { }
            column(Description; DescriptionGvar)
            { }
            trigger OnAfterGetRecord()
            begin
                "Fixed Asset".CalcFields("Qr Code");
                DescriptionGvar := CopyStr(Description, 1, 30);
                ModelNoGVar := CopyStr("Model No.", 1, 13);
                //MakeB2BGvar := CopyStr("Model No.", 1, 13); //B2BVCon01Feb2024
                MakeB2BGvar := CopyStr(Make_B2B, 1, 13); //B2BVCon01Feb2024
                SerialNoGVar := CopyStr("Serial No.", 1, 13);

            end;
        }
    }
    var
        DescriptionGvar: Text[30];
        ModelNoGVar: Text[15];
        MakeB2BGvar: Text[15];
        SerialNoGVar: Text[15];

}