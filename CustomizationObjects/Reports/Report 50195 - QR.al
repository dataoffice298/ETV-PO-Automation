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
            column(Qr_Code; "Qr Code")
            { }
            column(FANoANDDescription; FANoANDDescription)
            { }
            trigger OnAfterGetRecord()
            begin
                FANoANDDescription := "Fixed Asset"."No.";
                "Fixed Asset".CalcFields("Qr Code");
            end;
        }
    }
    var
        FixedAssetsNoCapLbl: Label 'Fixed Asset No.';
        FANoANDDescription: Text[50];

}