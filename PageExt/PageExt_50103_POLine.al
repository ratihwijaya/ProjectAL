pageextension 50103 POLineExt extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast("F&unctions")
        {
            action(GetPurchPR)
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Get Item PR';
                Image = ReceiptLines;
                trigger OnAction()
                begin
                    CODEUNIT.RUN(CODEUNIT::GetReceiptPR, Rec);
                end;

            }
        }
    }

    var
        myInt: Integer;
}