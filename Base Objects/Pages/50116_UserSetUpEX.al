pageextension 50116 UserSetUpExt_B2B extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {
            field(UserLocation; Rec."User Location")
            {
                ApplicationArea = All;
                Caption = 'User Location';
                TableRelation = Location;
            }
            field("User Signature"; Rec."User Signature")
            {
                ApplicationArea = All;

            }
            field(Stores; Rec.Stores)
            {
                ApplicationArea = all;
            }
            field(Specifications; Specifications)
            {
                ApplicationArea = all;
            }
            field("Accept/Reject"; "Accept/Reject")
            {
                ApplicationArea = all;
            }
            /*  field("FA Class"; "FA Class")
              {
                  ApplicationArea = all;
              }
              field("FA Sub Class"; "FA Sub Class")
              {
                  ApplicationArea = all;
              }*/
            field("QR Code"; Rec."QR Code")
            {
                ApplicationArea = All;
            }
            field(Designation; Designation)
            {
                ApplicationArea = All;
            }
            field("Import Signature"; "Import Signature")
            {
                ApplicationArea = All;
            }
        }
    }
    //B2BKM29APR2024 <<
    actions
    {
        addfirst(Processing)
        {
            action(UploadContent)
            {
                ApplicationArea = All;
                Image = MoveUp;
                Caption = 'Upload';
                ToolTip = 'Upload';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    ImportOpenFileDialogMethod()
                end;
            }

            action(DownloadContent)
            {
                ApplicationArea = All;
                Image = MoveDown;
                Caption = 'Download';
                ToolTip = 'Download';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    DownloadContent();
                end;
            }
        }
    }
    procedure ImportOpenFileDialogMethod()
    var
        FromFileName: Text;
        InstreamPic: InStream;
    begin
        if UploadIntoStream('Import', '', 'ALL FILES (*.*)|*.*', FromFileName, InstreamPic) then begin
            Rec."User Signature".ImportStream(InstreamPic, FromFileName);
            Rec.Modify();
        end;
        if not Rec."Import Signature" then
            Rec."Import Signature" := true;
    end;

    procedure DownloadContent()
    var
        FileManagement: Codeunit "File Management";
        VarOutStream: OutStream;
        VarInStream: InStream;
        FileName: Text;
        TempBlob: Codeunit "Temp Blob";
    begin
        if not Rec."User Signature".HasValue() then
            exit;
        TempBlob.CreateOutStream(VarOutStream);
        Rec."User Signature".ExportStream(VarOutStream);
        TempBlob.CreateInStream(VarInStream);
        //FileName := Rec.Description;
        DownloadFromStream(VarInStream, DownloadTitleLbl, '', FileFilterLbl, FileName);
    end;

    var
        FileFilterLbl: Label 'Image file(*.PNG)|*.PNG', Locked = true;
        PDFExtLbl: Label '.PNG', Locked = true;
        UploadTitleLbl: Label 'Upload Signiture File';
        DownloadTitleLbl: Label 'Download Signiture File';
    //B2BKM29APR2024 >>
}