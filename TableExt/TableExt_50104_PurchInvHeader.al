tableextension 50104 PurchInvHeaderExt extends "Purch. Inv. Header"
{
    fields
    {
        // Add changes to table fields here
        field(123456711; "Interval Inv No. 2"; Code[20])
        {
            Caption = 'Interval Inv No.(2)';
        }
    }


    var
        myInt: Integer;
}