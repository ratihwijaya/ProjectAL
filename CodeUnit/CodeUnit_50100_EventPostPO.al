codeunit 50100 EventPO
{
    // EventSubscriberInstance = Manual;
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', True, True)]
    local procedure OnAfterPostPurchaseDocSub(VAR PurchaseHeader: Record "Purchase Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PurchHeader: Record "Purchase Header";
        PostRcpHeader: Record "Purch. Rcpt. Header";
        PostRcpLine: Record "Purch. Rcpt. Line";
        IntervalInvNoValue: Code[20];
        PostInvHeader: Record "Purch. Inv. Header";
        PostInvLine: Record "Purch. Inv. Line";
    begin
        PurchHeader := PurchaseHeader;
        WITH PurchHeader DO BEGIN
            SetRange("Document Type", "Document Type"::Order);


            PostRcpHeader.SETRANGE("Order No.", PurchHeader."No.");
            IF PostRcpHeader.FINDSET THEN
                IntervalInvNoValue := PurchHeader."Interval Inv No. 2" + '_2';

            if PostRcpHeader."Interval Inv No. 2" = '' then begin
                PostRcpHeader."Interval Inv No. 2" := IntervalInvNoValue;
                PostRcpHeader.MODIFY;
            end;

            PostRcpLine.RESET;
            PostRcpLine.SETRANGE("Document No.", PostRcpHeader."No.");
            IF PostRcpLine.FINDSET THEN BEGIN
                REPEAT
                    PostRcpLine."Interval Inv No. 2" := IntervalInvNoValue;
                    PostRcpLine.MODIFY;
                UNTIL PostRcpLine.NEXT = 0;
            END;


            PostInvLine.RESET;
            PostInvLine.SETRANGE("Order No.", PurchHeader."No.");
            IF PostInvLine.FINDSET THEN BEGIN
                REPEAT
                    PostInvLine."Interval Inv No. 2" := IntervalInvNoValue;
                    PostInvLine.MODIFY;
                UNTIL PostInvLine.NEXT = 0;
            END;

        END;
        COMMIT;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostLines', '', True, true)]
    local procedure OnBeforePostLinesSub(VAR PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        POLINE: Record "Purchase Line";
        PRLIne: Record "Purchase Line";
    begin
        POLINE := PurchLine;
        POLINE.SetRange("Document No.", POLINE."Document No.");
        if POLINE.FindSet THEN begin
            repeat
                PRLIne.Reset();
                PRLine.SetRange(PRLIne."Document No.", POLINE."Purchase Req. No2");
                PRLine.SetRange(PRLIne."Line No.", POLINE."Purchase Req. Line No. 2");
                if PRLIne.FindSet() then
                    repeat
                        PRLine."Quantity Received" := POLINE."Quantity";
                        PRLine.Modify();
                    until PRLIne.Next = 0;
            until POLINE.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnBeforeInsertInvLineFromRcptLine', '', True, True)]
    local procedure OnBeforeInsertInvLineFromRcptLineSub(VAR PurchRcptLine: Record "Purch. Rcpt. Line"; VAR PurchLine: Record "Purchase Line"; PurchOrderLine: Record "Purchase Line")
    var
        POLine: Record "Purchase Line";
        PRcpLine: Record "Purch. Rcpt. Line";
        PurchOrderHeader: Record "Purchase Header";
    begin
        PRcpLine := PurchRcptLine;
        PRcpLine.SetRange("Document No.", PRcpLine."Document No.");
        if PRcpLine.FindSet() then begin
            PurchOrderLine.Reset();
            PurchOrderLine.SetRange("Receipt No.", PRcpLine."Document No.");
            PurchOrderLine.SetRange("Receipt Line No.", PRcpLine."Line No.");
            if PurchOrderLine.FindSet() then
                repeat
                    Message(PRcpLine."Interval Inv No. 2");
                    PurchOrderLine."Interval Inv No. 2" := PRcpLine."Interval Inv No. 2";
                    PurchOrderLine.Modify();
                    Message(PurchOrderLine."Interval Inv No. 2");
                until PurchOrderLine.Next = 0;
        end;
    end;
}