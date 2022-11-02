report 50182 "Regularization Order"
{
    Caption = 'Regularization Order';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './RegularizationOrder.rdl';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Line_No_; "Line No.")
                { }
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }




    var
        CompanyInfo: Record "Company Information";
}