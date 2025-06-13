
page 50187 "CWIP Details"

{
    Caption = 'CWIP Details';
    PageType = List;
    SourceTable = "CWIP Details";
    UsageCategory = None;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    Visible = false;
                    Caption = 'Document No.';
                    ApplicationArea = All;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ToolTip = 'Specifies the value of the Document Line No. field.';
                    Visible = false;
                    Caption = 'Document Line No.';
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    Visible = false;
                    Caption = 'Line No.';
                    ApplicationArea = All;
                }
                field(Make; Rec.Make)
                {
                    ToolTip = 'Specifies the value of the Make field.';
                    Caption = 'Make';
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.';
                    Caption = 'Model';
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial No. field.';
                    Caption = 'Serial No.';
                    ApplicationArea = All;
                }
            }
        }
    }
    // >>B2BSCM 30/04/2025
    actions
    {
        area(Processing)
        {
            action(Posted)
            {
                ApplicationArea = All;
                Image = Post;
                Caption = 'Posted';
                trigger OnAction()
                begin
                    if Rec.Posted then begin
                        Rec.Posted := false;
                        Rec.Modify()
                    end
                    else begin
                        Rec.Posted := true;
                        Rec.Modify()
                    end;


                end;
            }
        }
    }
    // <<B2BSCM 30/04/2025
}

