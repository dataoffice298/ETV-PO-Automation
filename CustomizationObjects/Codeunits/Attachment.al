codeunit 50027 Attachments //B2BSSD02Feb2023
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', true, true)]
    procedure "Document Attachment Factbox_OnBeforeDrillDown"
    (
        DocumentAttachment: Record "Document Attachment";
        var RecRef: RecordRef
    )
    var
        Technicalspec: Record "Technical Specifications";
        IndentLine: Record "Indent Line";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Technical Specifications":
                begin
                    RecRef.Open(DATABASE::"Technical Specifications");
                    if Technicalspec.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(Technicalspec);
                end;
            DATABASE::"Indent Line":
                begin
                    RecRef.Open(DATABASE::"Indent Line");
                    if IndentLine.Get(DocumentAttachment."No.", DocumentAttachment."Line No.") then
                        RecRef.GetTable(IndentLine);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Technical Specifications":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Indent Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    FieldRef := RecRef.Field(2);
                    LineNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Line No.", LineNo);
                end;
        end;
    end;

    /* [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
     procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
     var
         FieldRef: FieldRef;
         RecNo: Code[20];
         LineNo: Integer;
     begin
         case RecRef.Number of
             DATABASE::"Technical Specifications":
                 begin
                     FieldRef := RecRef.Field(1);
                     RecNo := FieldRef.Value;
                     DocumentAttachment.Validate("No.", RecNo);
                 end;
         end;
     end;*/
}