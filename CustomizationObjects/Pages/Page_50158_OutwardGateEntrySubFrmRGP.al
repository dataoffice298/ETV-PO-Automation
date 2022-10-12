page 50158 "Outward Gate Entry SubFrm-RGP"
{
    Caption = 'RGP-OUTWARD Subform';
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Gate Entry Line_B2B";

    layout
    {
        area(content)
        {
            repeater(Control1500000)
            {
                field("Challan No."; "Challan No.")
                {
                    ApplicationArea = ALL;
                }
                field("Challan Date"; "Challan Date")
                {
                    ApplicationArea = ALL;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = ALL;
                    OptionCaption = ' ,Sales Shipment,Sales Return Order,Purchase Order,Purchase Return Shipment,Transfer Receipt,Transfer Shipment,Item,Fixed Asset,Others';

                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = ALL;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FA: record "Fixed Asset";
                        ItemLRec: record Item;
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                    begin
                        case "Source Type" of
                            "Source Type"::"Fixed Asset":
                                begin
                                    FA.Reset();
                                    FA.SetRange(Blocked, false);
                                    FA.FilterGroup(0);
                                    if PAGE.RUNMODAL(0, FA) = ACTION::LookupOK then begin
                                        "Source No." := FA."No.";
                                        "Source Name" := FA.Description;
                                        Description := FA.Description;
                                    end;
                                end;
                            "Source Type"::Item:
                                begin
                                    ItemLRec.Reset();
                                    ItemLRec.SetRange(Blocked, false);
                                    ItemLRec.FilterGroup(0);
                                    if PAGE.RUNMODAL(0, ItemLRec) = ACTION::LookupOK then begin
                                        "Source No." := ItemLRec."No.";
                                        "Source Name" := ItemLRec.Description;
                                        Description := ItemLRec.Description;
                                        "Unit of Measure" := ItemLRec."Base Unit of Measure";
                                    end;
                                end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        SalesShipHeader: Record "Sales Shipment Header";
                        SalesHeader: Record "Sales Header";
                        PurchHeader: Record "Purchase Header";
                        ReturnShipHeader: Record "Return Shipment Header";
                        TransHeader: Record "Transfer Header";
                        TransShptHeader: Record "Transfer Shipment Header";
                        Text16500: Label 'Source Type must not be blank in %1 %2.';
                    BEGIN
                        if "Source Type" = 0 then
                            ERROR(Text16500, FIELDCAPTION("Line No."), "Line No.");
                        if "Source No." <> xRec."Source No." then
                            "Source Name" := '';
                        if "Source No." = '' then begin
                            "Source Name" := '';
                            exit;
                        end;
                    end;
                }
                field("Source Name"; "Source Name")
                {
                    ApplicationArea = ALL;
                }
                field(Description; Description)
                {
                    ApplicationArea = ALL;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    ApplicationArea = all;
                }
                field("Source Line No."; "Source Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }
    var
        GatEntHdrGRec: Record "Gate Entry Header_B2B";
}

