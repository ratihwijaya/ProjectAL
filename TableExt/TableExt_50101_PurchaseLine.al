tableextension 50101 PurchLineExt extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        field(123456711; "Interval Inv No. 2"; Code[20])
        {
            Caption = 'Interval Inv No.(2)';
        }
        field(123456712; "Qty Taken (PO)"; Decimal)
        {
            Caption = 'Qty Taken (PO)';
        }

        field(123456713; "Purchase Req. No2"; Code[20])
        {

        }

        field(123456714; "Purchase Req. Line No. 2"; Integer)
        {

        }

        modify("Document Type")
        {
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Purchase Requisition';
        }

    }

    var
        TempPurchLine: Record "Purchase Line";
        PurchInvHeader: Record "Purchase Header";
        PurchOrderHeader: Record "Purchase Header";

        PurchOrderLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        Currency: Record Currency;

        TransferOldExtLines: Codeunit "Transfer Old Ext. Text Lines";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        NextLineNo: Integer;
        ExtTextLine: Boolean;
        CurrencyRead: Boolean;
        DocumentTypePR: Option;


    procedure InsertInvLineFromRcptLine(VAR PurchLine: Record "Purchase Line")
    begin

        SETRANGE("Document No.", "Document No.");

        TempPurchLine := PurchLine;
        IF PurchLine.FIND('+') THEN
            NextLineNo := PurchLine."Line No." + 10000
        ELSE
            NextLineNo := 10000;

        IF PurchInvHeader."No." <> TempPurchLine."Document No." THEN
            PurchInvHeader.GET(TempPurchLine."Document Type", TempPurchLine."Document No.");

        TransferOldExtLines.ClearLineNumbers;

        REPEAT
            ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

            IF PurchOrderLine.GET("Document Type",
                 Rec."Document No.", Rec."Line No.") AND
            NOT ExtTextLine
            THEN BEGIN
                IF //(PurchOrderHeader."Document Type" <> PurchOrderLine."Document Type"::"Purchase Requisition") OR
                    (PurchOrderHeader."No." <> PurchOrderLine."Document No.")
                THEN
                    PurchOrderHeader.GET(rec."Document Type", rec."Document No.");

                InitCurrency("Currency Code");

                IF PurchInvHeader."Prices Including VAT" THEN BEGIN
                    IF NOT PurchOrderHeader."Prices Including VAT" THEN
                        PurchOrderLine."Direct Unit Cost" :=
                        ROUND(
                            PurchOrderLine."Direct Unit Cost" * (1 + PurchOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                END ELSE BEGIN
                    IF PurchOrderHeader."Prices Including VAT" THEN
                        PurchOrderLine."Direct Unit Cost" :=
                        ROUND(
                            PurchOrderLine."Direct Unit Cost" / (1 + PurchOrderLine."VAT %" / 100),
                            Currency."Unit-Amount Rounding Precision");
                END;
            END ELSE BEGIN
                IF ExtTextLine THEN BEGIN
                    PurchOrderLine.INIT;
                    PurchOrderLine."Line No." := "Order Line No.";
                    PurchOrderLine.Description := Description;
                    PurchOrderLine."Description 2" := "Description 2";
                END ELSE
                    ERROR('The program cannot find this purchase requisition.');
            END;
            PurchLine := PurchOrderLine;
            PurchLine."Line No." := NextLineNo;
            PurchLine."Document Type" := TempPurchLine."Document Type";
            PurchLine."Document No." := TempPurchLine."Document No.";
            PurchLine.VALIDATE("Buy-from Vendor No.", PurchInvHeader."Buy-from Vendor No.");
            PurchLine.VALIDATE("Pay-to Vendor No.", PurchInvHeader."Pay-to Vendor No.");
            PurchLine.VALIDATE(Type, PurchOrderLine.Type);
            PurchLine.VALIDATE(Description, PurchOrderLine.Description);
            PurchLine.VALIDATE("Unit of Measure", PurchOrderLine."Unit of Measure");
            PurchLine.VALIDATE("No.", PurchOrderLine."No.");
            PurchLine.VALIDATE(Quantity, (PurchOrderLine.Quantity - "Qty Taken (PO)"));
            PurchLine.VALIDATE("Location Code", PurchOrderLine."Location Code");
            PurchLine."Variant Code" := "Variant Code";
            PurchLine."Drop Shipment" := FALSE;
            PurchLine."Special Order Sales No." := '';
            PurchLine."Special Order Sales Line No." := 0;
            PurchLine."Special Order" := FALSE;
            PurchLine."Purchase Req. No2" := "Document No.";
            PurchLine."Purchase Req. Line No. 2" := "Line No.";
            PurchLine."Appl.-to Item Entry" := 0;

            PurchLine.VALIDATE("Line Discount Amount", PurchOrderLine."Line Discount Amount");
            PurchLine."Line Discount %" := PurchOrderLine."Line Discount %";
            PurchLine.UpdatePrePaymentAmounts;

            PurchLine."Attached to Line No." :=
            TransferOldExtLines.TransferExtendedText(
              "Line No.",
              NextLineNo,
              "Attached to Line No.");

            IF "Sales Order No." = '' THEN
                PurchLine."Drop Shipment" := FALSE
            ELSE
                PurchLine."Drop Shipment" := TRUE;



            //OnBeforeInsertInvLineFromRcptLine(Rec,PurchLine,PurchOrderLine);
            PurchLine.INSERT;
            //OnAfterInsertInvLineFromRcptLine(PurchLine,PurchOrderLine,NextLineNo);

            ItemTrackingMgt.CopyHandledItemTrkgToInvLine(PurchOrderLine, PurchLine);

            NextLineNo := NextLineNo + 10000;
            IF "Attached to Line No." = 0 THEN
                SETRANGE("Attached to Line No.", "Line No.");

        UNTIL (NEXT = 0) OR ("Attached to Line No." = 0);
    end;

    local procedure InitCurrency(CurrencyCode: Code[10])
    begin
        IF (Currency.Code = CurrencyCode) AND CurrencyRead THEN
            EXIT;

        IF CurrencyCode <> '' THEN
            Currency.GET(CurrencyCode)
        ELSE
            Currency.InitRoundingPrecision;
        CurrencyRead := TRUE;
    end;




}