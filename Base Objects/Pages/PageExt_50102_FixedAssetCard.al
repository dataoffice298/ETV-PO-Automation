pageextension 50102 FixedAssetCard extends "Fixed Asset Card"
{
    layout
    {
        addbefore("Serial No.")
        {
            field("Model No."; Rec."Model No.")
            {
                ApplicationArea = all;
            }
            field(Make_B2B; Rec.Make_B2B)
            {
                Caption = 'Make';
                ApplicationArea = all;
            }
        }
        addafter(FixedAssetPicture)
        {
            part("Fixed Asset QR Code"; "Fixed Asset QR Code")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Fixed Asset QR Code';
                SubPageLink = "No." = FIELD("No.");
            }
        }
        //B2BVCOn19Dec22>>>
        addafter("Responsible Employee")
        {
            group(QC)
            {
                Caption = 'QC';
                field("QC Enabled B2B"; Rec."QC Enabled B2B")
                {
                    ApplicationArea = all;
                }
            }
        }
        //B2BVCOn19Dec22<<<
        addafter(Acquired)//B2BSSD202APR2023
        {
            field("available/Unavailable"; Rec."available/Unavailable")
            {
                ApplicationArea = All;
                Caption = 'Avail / Unavail';
            }
        }
        addafter("FA Location Code")//B2BSS15JUN2023
        {
            field("FA Sub Location"; Rec."FA Sub Location")
            {
                ApplicationArea = All;
                Caption = 'FA Sub Location';
            }
        }
        modify(FAPostingGroup)
        {
            ShowMandatory = true;//B2BSCM11SEP2023
        }


    }

    actions
    {
        addafter(Attachments)
        {
            action("Generate QR Code")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    QRGenerator: Codeunit "QR Generator";
                    TempBlob: Codeunit "Temp Blob";
                    FixedAsset: Record "Fixed Asset";
                    IndentLine: Record "Indent Line";
                    FieldRef: FieldRef;
                    RecRef: RecordRef;
                    CF: Char;
                    LF: Char;
                    QRText: Text;
                    QRDescription: Text;
                begin
                    if FixedAsset.Get(Rec."No.") then begin
                        RecRef.GetTable(FixedAsset);
                        CF := 150;
                        LF := 200;
                        QRText := FixedAsset."No." + ',' + 'Description : ' + FixedAsset.Description + ',' + 'Model No. : ' + FixedAsset."Model No." + ',' + 'Serial No. : ' + FixedAsset."Serial No." + ',' + 'Make. :' + FixedAsset.Make_B2B;//B2BSSD13JUN2023
                        QRGenerator.GenerateQRCodeImage(QRText, TempBlob);
                        FieldRef := RecRef.Field(FixedAsset.FieldNo("QR Code"));
                        TempBlob.ToRecordRef(RecRef, FixedAsset.FieldNo("QR Code"));
                        RecRef.Modify();
                    end;
                end;
            }
        }
        addafter("Ledger E&ntries")
        {
            action(OpenFAMovementEntries)
            {
                ApplicationArea = ALL;
                Caption = 'FA Movement Entries';
                Image = Entries;
                trigger onaction()
                var
                    FAMovement: Record "Fixed Asset Movements";
                BEGIN
                    FAMovement.Reset();
                    FAMovement.SetRange("FA No.", Rec."No.");
                    if FAMovement.FindSet() then
                        Page.Run(0, FAMovement);
                END;
            }
        }
        //B2BSSD11JUL2023>>
        addafter(Details)
        {
            action("QR Print")
            {
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Report;
                Caption = 'QR Print';
                trigger OnAction()
                var
                    Fixedasset: Record "Fixed Asset";
                begin
                    Fixedasset.Reset();
                    Fixedasset.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::QRReport, true, false, Fixedasset);
                end;
            }
        }
        //B2BSSD11JUL2023<<
    }
    var
        myInt: Integer;
}