page 50148 GetPR
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = Filter('Purchase Requisition'), "Qty Taken (PO)" = Filter(0));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                    Visible = False;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;

                }
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field("Description"; Description)
                {
                    ApplicationArea = All;

                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;

                }
                field("Quantity"; Quantity)
                {
                    ApplicationArea = All;

                }
                field("UOM"; "Unit of Measure")
                {
                    ApplicationArea = All;

                }
                field("Qty taken PO"; "Qty Taken (PO)")
                {
                    ApplicationArea = All;

                }
                field("Qty Received"; "Quantity Received")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    procedure SetPurchHeader(Var PurchHeader2: Record "Purchase Header")
    begin
        PurchHeader.GET(PurchHeader2."Document Type", PurchHeader2."No.");
        PurchHeader.TESTFIELD("Document Type", PurchHeader."Document Type"::Order)
    end;

    local procedure DocumentNoOnFormat()
    begin
        IF NOT IsFirstDocLine THEN
            DocumentNoHideValue := TRUE;
    end;

    LOCAL procedure CreateLines()
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
        GetReceipts.SetPurchHeader(PurchHeader);
        GetReceipts.CreatePOLines(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        DocumentNoHideValue := FALSE;
        DocumentNoOnFormat;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            CreateLines;
    end;

    var
        PurchHeader: Record "Purchase Header";

        GetReceipts: Codeunit GetReceiptPR;
        DocumentNoHideValue: Boolean;
        IsFirstDocLine: Boolean;

}