pageextension 50102 PageRcpLineExt extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Interval Inv No.2"; "Interval Inv No. 2")
            {
                ApplicationArea = all;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}