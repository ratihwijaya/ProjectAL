codeunit 50102 UpdatePR
{
    TableNo = "Purchase Line";
    trigger OnRun()
    begin
        UpdatePurchReq(Rec);
    end;

    local procedure UpdatePurchReq(VAR PurchLine: Record "Purchase Line")
    begin
        PurchReqLine.RESET;
        PurchReqLine.SETRANGE("Document No.", PurchLine."Purchase Req. No2");
        PurchReqLine.SETRANGE("Line No.", PurchLine."Purchase Req. Line No. 2");
        IF PurchReqLine.FINDSET THEN
            REPEAT
                PurchReqLine."Order No." := PurchLine."Document No.";
                PurchReqLine."Order Line No." := PurchLine."Line No.";
                PurchReqLine."Qty Taken (PO)" := PurchLine.Quantity;
                PurchReqLine.MODIFY;
            UNTIL PurchReqLine.NEXT = 0;
        COMMIT;
    end;


    var
        PurchReqLine: Record "Purchase Line";

}