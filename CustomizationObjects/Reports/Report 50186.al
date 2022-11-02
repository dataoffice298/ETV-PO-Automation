report 50186 MyReport
{
    RDLCLayout = './NonReturnableGatepass.rdl';
    Caption = 'Non Returnable Gatepass_50181';
    ApplicationArea = Manufacturing;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        myInt: Integer;
}