table 50057 "Posted Gate Entry Header_B2B"
{
    // version NAVIN9.00.00.45778

    DataClassification = CustomerContent;
    LookupPageID = "PostedInwardGateEntryList-NRGP";

    fields
    {
        field(1; "Entry Type"; Enum GateEntryInOutWard)
        {
            DataClassification = CustomerContent;

        }
        field(2; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(4; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Document Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(8; Description; Text[120])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Item Description"; Text[120])
        {
            DataClassification = CustomerContent;
        }
        field(10; "LR/RR No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(11; "LR/RR Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(12; "Vehicle No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Station From/To"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(15; Comment; Boolean)
        {
            /* CalcFormula = Exist ("Gate Entry Comment Line" WHERE("Gate Entry Type" = FIELD("Entry Type"),
                                                                  "No." = FIELD("No.")));

             FieldClass = FlowField;*/
        }
        field(17; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Posting Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(19; "Gate Entry No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");//TEST
            end;
        }
        field(23; "Type"; Enum GateEntryType)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Transporter No."; Code[20])
        {
            DataClassification = CustomerContent;


        }
        field(25; "Transporter Name"; text[100])
        {
            DataClassification = CustomerContent;

        }
        field(26; StaffNo; code[20])
        {
            DataClassification = CustomerContent;


        }
        field(27; "Staff Name"; code[250])
        {
            DataClassification = CustomerContent;

        }

        field(28; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(29; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(30; "Comments"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(31; "Vendor No"; code[20])
        {
            DataClassification = CustomerContent;

        }
        field(32; "Vendor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(33; "Vend Type"; enum PurchaseType)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(35; "No. Printed"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;//b2bpksalecorr12//b2bpksalecorr13
        }

    }

    keys
    {
        key(Key1; "Entry Type", "Type", "No.")
        {
        }
        key(Key2; "Location Code", "Posting Date", "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

