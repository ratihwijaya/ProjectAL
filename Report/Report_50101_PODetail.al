report 50101 PODetail
{
    UsageCategory = Administration;
    ApplicationArea = All;
    CaptionML = ENU = 'Purchase Order Details';
    RDLCLayout = 'ReportLayouts/PODetail.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "Document Type", "Buy-from Vendor No.", "No.", "No. Printed";
            column(No_PurchaseHeader; "No.") { }
            column(PaymentTermsCode_PurchaseHeader; "Payment Terms Code") { }
            column(Company_Name; Company_Name) { }
            column(Company_Address; Company_Address) { }
            column(Company_VATReg; Company_VATReg) { }
            column(CompanyInformation_Picture; CompanyInformation.Picture) { }
            /* column(Vendor_Name; Vendor_Name) { }
             column(Name2_Vendor; Vendor."Name 2") { }
             column(Address_Vendor; Vendor.Address) { }
             column(Address2_Vendor; Vendor."Address 2") { }
             column(City_Vendor; Vendor.City) { }
             column(Country_Vendor; Vendor."Country/Region Code") { }
             column(Contact_Vendor; Vendor.Contact) { }
             column(PhoneNo_Vendor; Vendor."Phone No.") { }
             column(FaxNo_Vendor; Vendor."Fax No.") { }*/

            dataitem(Vendor; Vendor)
            {
                DataItemLinkReference = "Purchase Header";
                PrintOnlyIfDetail = false;
                DataItemLink = "No." = field("Buy-from Vendor No.");
                column(Name_Vendor; Name) { }
                column(Name2_Vendor; "Name 2") { }
                column(Address_Vendor; Address) { }
                column(Address2_Vendor; "Address 2") { }
                column(City_Vendor; City) { }
                column(Country_Vendor; "Country/Region Code") { }
                column(Contact_Vendor; Contact) { }
                column(PhoneNo_Vendor; "Phone No.") { }
                column(FaxNo_Vendor; "Fax No.") { }
            }
        }
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemLinkReference = "Purchase Header";
            DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending);
            PrintOnlyIfDetail = false;
            column(LineNo_PurchaseLine; "Line No.") { }
            column(No_PurchaseLine; "No.") { }
            column(Description_PurchaseLine; Description) { }
            column(Qty_PurchaseLine; Quantity) { }
            column(UOM_PurchaseLine; "Unit of Measure") { }
            column(DirectunitCost_PurchaseLine; "Direct Unit Cost") { }
            column(Disc_PurchaseLine; "Inv. Discount Amount") { }
            column(Amount_PurchaseLine; Amount) { }
            column(PromisedReceiptDate_PurchaseLine; "Promised Receipt Date") { }
            column(AmountIncVAT_PurchaseLine; "Amount Including VAT") { }
            column(VATPsn_PurchaseLine; "VAT %") { }
            column(DiscLine_PurchaseLine; "Line Discount Amount") { }

            trigger OnPreDataItem()
            begin
                //"Purchase Line".SetFilter("Document Type","Purchase Header"."Document Type");
                "Purchase Line".SetFilter("Document No.", "Purchase Header"."No.");
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(HideDetails; HideDetails)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }

            }
        }

    }

    var
        CompanyInformation: Record "Company Information";
        Vendor1: Record "Vendor";
        SegManagement: Codeunit SegManagement;
        MailManagement: Codeunit "Mail Management";
        HideDetails: Boolean;
        LogInteraction: Boolean;
        Company_Name: Text[100];
        Company_Address: Text[250];
        Company_VATReg: Text[100];
        Vendor_Name: Text[100];

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);
        Company_Name := CompanyInformation.Name;
        Company_Address := CompanyInformation.Address;
        Company_VATReg := CompanyInformation."VAT Registration No.";

    end;

    trigger OnPreReport();
    begin
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;
    end;

    trigger OnPostReport()
    begin
        IF LogInteraction AND NOT IsReportInPreviewMode THEN
            IF "Purchase Header".FINDSET THEN
                REPEAT
                    SegManagement.LogDocument(
                       13, "Purchase Header"."No.", 0, 0, DATABASE::Vendor, "Purchase Header"."Buy-from Vendor No.",
                       "Purchase Header"."Purchaser Code", '', "Purchase Header"."Posting Description", '');
                UNTIL "Purchase Header".NEXT = 0;
    end;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
    end;

    local procedure IsReportInPreviewMode(): Boolean;
    begin
        EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    end;
}
