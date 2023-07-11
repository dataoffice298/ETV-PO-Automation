tableextension 50061 FixedAssetExtPOAuto extends "Fixed Asset"
{
    fields
    {
        field(50050; "Qr Code"; Blob)
        {
            Subtype = Bitmap;
            Caption = 'QR Code';
            DataClassification = CustomerContent;
        }
        field(50051; "Model No."; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(50052; Make_B2B; Text[250])
        {
            Caption = 'Make';
            DataClassification = CustomerContent;
        }
        //B2BVCOn19Dec22>>>
        field(50053; "QC Enabled B2B"; Boolean)
        {
            Caption = 'QC Enabled';
            DataClassification = CustomerContent;
        }
        //B2BVCOn19Dec22<<<
        field(50054; "available/Unavailable"; Boolean)//B2BSSD13APR2023
        {
            DataClassification = CustomerContent;
            Editable = false;//B2BSSD30MAY2023
        }
        field(50055; "FA Sub Location"; Code[20])//B2BSSD15JUN2023
        {
            DataClassification = CustomerContent;
            TableRelation = "FA Sub Location"."Sub Location Code" where("Location Code" = field("FA Location Code"));
            /*trigger OnLookup()
            var
                FAsublocation: Record "FA Sub Location";
            begin
                FAsublocation.Reset();
                FAsublocation.FilterGroup(2);
                FAsublocation.SetRange("Location Code", "FA Location Code");
                FAsublocation.FilterGroup(0);
                if Page.RunModal(Page::"FA Sub Locations", FAsublocation) = Action::LookupOK then
                    "FA Sub Location" := FAsublocation."Sub Location Code";
            end;*/
        }
    }

}