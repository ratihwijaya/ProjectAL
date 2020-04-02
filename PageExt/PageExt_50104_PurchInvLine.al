pageextension 50104 PurchInvExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Interval Inv No. 2"; "Interval Inv No. 2")
            {
                ApplicationArea = All;
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