pageextension 50101 PO extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Control71)
        {
            field("Interval Invoice No-2"; "Interval Inv No. 2")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(SendCustom)
        {
            action(PrintDetail)
            {
                ApplicationArea = All;
                Image = Print;
                CaptionML = ENU = 'Print PO';
                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PurchaseHeader);
                    myreport.SETTABLEVIEW(PurchaseHeader);
                    myreport.Run;
                end;
            }
        }

    }




    var
        Myreport: Report PODetail;
        PurchaseHeader: Record "Purchase Header";
}