table 50224 "PO Terms And Conditions"
{
    DataClassification = CustomerContent;
    Caption = 'PO Terms And Conditions';

    fields
    {
        field(1; DocumentType; Enum "Purchase Document Type")
        {
            DataClassification = CustomerContent;
        }
        field(2; DocumentNo; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; LineNo; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; LineType; Code[50])
        {
            //B2BSSD13MAR2023<<
            TableRelation = TechnicalSpecOption;
            Caption = 'LineType';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if TechSPecOp.Get(LineType) then
                    Description := TechSPecOp.Description;
            end;
            //B2BSSD13MAR2023>>
        }
        Field(5; Description; Text[500])
        {
            DataClassification = CustomerContent;
        }

        field(7; Sequence; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Location Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
            trigger onvalidate()
            var
                LocationRec: Record Location;
                State: Record State;
                CountryRegion: Record "Country/Region";
            begin
                //if LineType = LineType::"Delivery Address" then begin
                LocationRec.Get("Location Code");
                if State.Get(LocationRec."State Code") then;
                if CountryRegion.Get(LocationRec."Country/Region Code") then;
                if LocationRec."Address 3" = '' then
                    Description := ': ' + LocationRec.Address + LocationRec."Address 2" + ', ' + LocationRec.City + ', ' + LocationRec."Post Code" + ', ' + State.Description + ', ' + CountryRegion.Name + '.'
                else
                    Description := ': ' + LocationRec.Address + LocationRec."Address 2" + ', ' + LocationRec."Address 3" + ', ' + LocationRec.City + ', ' + LocationRec."Post Code" + ', ' + State.Description + ', ' + CountryRegion.Name + '.'
            end;
            //end;
        }
    }

    keys
    {
        key(Pk; DocumentNo, DocumentType, LineNo)
        {
            Clustered = true;
        }
    }
    var
        TechSPecOp: Record TechnicalSpecOption;
}