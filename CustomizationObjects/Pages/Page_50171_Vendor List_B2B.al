page 50171 "Vendor List_B2B"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Vendors';
    PageType = List;
    SourceTable = Vendor;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number that identifies the vendor. You can assign numbers automatically based on a number series or assign them manually.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor''s name that appears on all related documents. For companies, specify the company''s name here, and then add the relevant people as contacts that you link to this vendor.';
                }
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an additional part of the name.';
                    Visible = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code.';
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s fax number.';
                    Visible = false;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = Intercompany;
                    ToolTip = 'Specifies the vendor''s intercompany partner code.';
                    Visible = false;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor.';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                    Visible = false;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    Visible = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                    Visible = false;
                }
                field("Fin. Charge Terms Code"; Rec."Fin. Charge Terms Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the involved finance charges in case of late payment.';
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code that is inserted by default when you create purchase documents or journal lines for the vendor.';
                    Visible = false;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.';
                    Visible = false;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which transactions with the vendor that cannot be processed, for example a vendor that is declared insolvent.';
                    Visible = false;
                }
                field("Privacy Blocked"; Rec."Privacy Blocked")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.';
                    Visible = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the vendor card was last modified.';
                    Visible = false;
                }
                field("Application Method"; Rec."Application Method")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how to apply payments to entries for this vendor.';
                    Visible = false;
                }
                field("Location Code2"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                    Visible = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                    Visible = false;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                    Visible = false;
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a customizable calendar for delivery planning that holds the vendor''s working days and holidays.';
                    Visible = false;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all completed purchase invoices and credit memos.';

                    trigger OnDrillDown()
                    begin
                        OpenVendorLedgerEntries(false);
                    end;
                }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts excluding VAT on all open purchase invoices and credit memos.';

                    trigger OnDrillDown()
                    begin
                        OpenVendorLedgerEntries(true);
                    end;
                }
                field("Payments (LCY)"; Rec."Payments (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sum of payments paid to the vendor.';
                }
                field("Coupled to CRM"; Rec."Coupled to Dataverse")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the vendor is coupled to an account in Dataverse.';
                }
            }
        }
        area(factboxes)
        {
            part(PowerBIEmbeddedReportPart; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::Vendor), "No." = FIELD("No.");
            }
            part(VendorDetailsFactBox; "Vendor Details FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(VendorStatisticsFactBox; "Vendor Statistics FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part(VendorHistBuyFromFactBox; "Vendor Hist. Buy-from FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
            }
            part(VendorHistPayToFactBox; "Vendor Hist. Pay-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            //B2BKMUPG
          /*   part("Power BI Report FactBox"; "Power BI Report FactBox")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
                ObsoleteReason = 'Use the part PowerBIEmbeddedReportPart instead';
                ObsoleteState = Pending;
                ObsoleteTag = '21.0';
            } */
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
    trigger OnOpenPage()
    begin
        CurrPage.Editable(true);
    end;

    procedure SetSelection(var Vendor: Record Vendor)
    begin
        CurrPage.SetSelectionFilter(Vendor);
    end;

}