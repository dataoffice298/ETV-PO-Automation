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
            column(Serial_No_; "Serial No.")
            { }
            column(Make_B2B; Make_B2B)
            { }
            column(Model_No_; "Model No.")
            { }
            column(Description; Description)
            { }
            trigger OnAfterGetRecord()
            begin
                "Fixed Asset".CalcFields("Qr Code");
            end;
        }
    }

}