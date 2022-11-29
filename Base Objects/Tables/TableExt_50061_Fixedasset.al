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
    }

}