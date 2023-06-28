tableextension 50250 TransferHeaderExt extends "Transfer Header"//B2BSSD20MAR2023
{
    fields
    {
        field(50014; "Shortcut Dimension 9 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(9), Blocked = CONST(false));

            //B2BSSD28APR2023>>
            trigger OnValidate()
            var
                TempDimSetEntry: Record "Dimension Set Entry" temporary;
                DimMgnt: Codeunit DimensionManagement;
                DimensionValue: Record "Dimension Value";
                GLSetup: Record "General Ledger Setup";
            begin
                //ValidateShortcutDimCode(9, "Shortcut Dimension 9 Code");
                if "Shortcut Dimension 9 Code" <> '' then begin
                    GLSetup.Get();
                    TempDimSetEntry.RESET;
                    TempDimSetEntry.DELETEALL;
                    DimensionValue.GET(GLSetup."Shortcut Dimension 9 Code", "Shortcut Dimension 9 Code");
                    DimMgnt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
                    TempDimSetEntry.RESET;
                    TempDimSetEntry.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 9 Code");
                    IF TempDimSetEntry.FINDFIRST THEN
                        TempDimSetEntry.DELETE;
                    TempDimSetEntry.INIT;
                    TempDimSetEntry.VALIDATE("Dimension Code", DimensionValue."Dimension Code");
                    TempDimSetEntry.VALIDATE("Dimension Value Code", DimensionValue.Code);
                    TempDimSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                    TempDimSetEntry.INSERT(TRUE);
                    "Dimension Set ID" := DimMgnt.GetDimensionSetID(TempDimSetEntry);
                end else begin
                    GLSetup.Get();
                    TempDimSetEntry.RESET;
                    TempDimSetEntry.DELETEALL;
                    DimMgnt.GetDimensionSet(TempDimSetEntry, "Dimension Set ID");
                    TempDimSetEntry.RESET;
                    TempDimSetEntry.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 9 Code");
                    IF TempDimSetEntry.FINDFIRST THEN
                        TempDimSetEntry.DELETE;
                    "Dimension Set ID" := DimMgnt.GetDimensionSetID(TempDimSetEntry);
                end;
            end;
            //B2BSSD28APR2023<<
        }
        field(50002; "Programme Name"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Programme Name';
        }
        field(50003; Purpose; Code[250])//B2BSSD23MAR2023
        {
            DataClassification = CustomerContent;
        }
    }
}