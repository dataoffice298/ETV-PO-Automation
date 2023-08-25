table 50227 "Location Wise User" //B2BSSD29MAR2023
{
    DataClassification = CustomerContent;
    Caption = 'Location Wise User';
    LookupPageId = "Location Wise Users";
    fields
    {
        field(50000; "Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(50001; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
        }
        field(50002; Indent; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50003; RGPInward; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50004; RGPOutward; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50006; NRGPOutward; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50007; "Transfer Indent Header"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50008; "Transfer Order"; Boolean)//B2BSSD03APR2023
        {
            DataClassification = CustomerContent;
        }
        field(50009; "Item issue"; Boolean)//B2BSCM23AUG2023
        {
            Caption = 'Item Issue';
            DataClassification = CustomerContent;
        }
        field(50010; "Item Return"; Boolean)//B2BSCM23AUG2023
        {
            Caption = 'Item Return';
            DataClassification = CustomerContent;
        }
        field(50011; "PO Posting"; Boolean)//B2BSCM24AUG2023
        {
            Caption = 'PO Posting';
            DataClassification = CustomerContent;
            
        }
    }

    keys
    {
        key(PK; "Location Code", "User ID")
        {
            Clustered = true;
        }
    }
}