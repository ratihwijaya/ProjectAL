codeunit 50101 GetReceiptPR
{
    TableNo = "Purchase Line";
    trigger OnRun()
    begin
        RunGetPR(Rec);
    end;

    local procedure RunGetPR(var POLine: Record "Purchase Line")
    begin
        PurchHeader.GET(POLine."Document Type", POLine."Document No.");
        PurchHeader.TESTFIELD("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.TESTFIELD(Status, PurchHeader.Status::Open);

        PurchOrderLine.SETRANGE("Document Type"::"Purchase Requisition");
        PurchOrderLine.SETFILTER(Quantity, '<>0');


        GetReceipts2.SETTABLEVIEW(PurchOrderLine);
        GetReceipts2.LOOKUPMODE := TRUE;
        GetReceipts2.SetPurchHeader(PurchHeader);
        GetReceipts2.RUNMODAL;
    end;


    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        GetReceipts2: Page GetPR;
        TransferLine: Boolean;

    procedure SetPurchHeader(Var PurchHeader2: Record "Purchase Header")
    begin
        PurchHeader.GET(PurchHeader2."Document Type", PurchHeader2."No.");
        PurchHeader.TESTFIELD("Document Type", PurchHeader."Document Type"::Order)
    end;

    procedure CreatePOLines(VAR PurchRcptLine2: Record "Purchase Line")
    begin
        WITH PurchRcptLine2 DO BEGIN
            SETFILTER(Quantity, '<>0');
            IF FIND('-') THEN BEGIN
                PurchLine.LOCKTABLE;
                PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
                PurchLine.SETRANGE("Document No.", PurchHeader."No.");
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine."Document No." := PurchHeader."No.";

                //OnBeforeInsertLines(PurchHeader);
                REPEAT
                    IF PurchOrderHeader."No." <> "Document No." THEN BEGIN
                        PurchOrderHeader.GET(PurchLine."Document Type", PurchLine."Document No.");
                        TransferLine := TRUE;
                        //OnBeforeTransferLineToPurchaseDoc2(PurchOrderHeader,PurchRcptLine2,PurchHeader,TransferLine);
                    END;
                    IF TransferLine THEN BEGIN
                        PurchOrderLine := PurchRcptLine2;

                        PurchOrderLine.InsertInvLineFromRcptLine(PurchLine);
                        //OnUpdatePurchReq(PurchLine);
                        CODEUNIT.RUN(CODEUNIT::UpdatePR, PurchLine);
                    END;
                UNTIL NEXT = 0;
                //OnAfterInsertLines(PurchHeader);

                //CalcInvoiceDiscount(PurchLine);
                //OnAfterCalcInvoiceDiscount(PurchHeader);

                //IF TransferLine THEN
                //AdjustPrepmtAmtToDeductRounding(PurchLine,PrepmtAmtToDeductRounding);
            END;
        end;
    end;


}