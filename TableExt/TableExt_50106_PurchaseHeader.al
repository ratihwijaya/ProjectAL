tableextension 50106 PurchHeaderExt extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(123456711; "Interval Inv No. 2"; Code[20])
        {
            Caption = 'Interval Inv No.(2)';
        }
        field(123456712; "Ket"; Text[100])
        {
            Caption = 'Keterangan';
        }

        field(123456713; "Req Date"; Date)
        {

        }

        field(123456714; "Requesters"; Text[50])
        {

        }

        modify("Document Type")
        {
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Purchase Requisition';
        }
    }


    var
        myInt: Integer;
}