page 50102 PurchReqLine
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Type"; "Type")
                {
                    ApplicationArea = All;

                }
                field("No"; "No.")
                {
                    ApplicationArea = All;

                }
                field("Description"; "Description")
                {
                    ApplicationArea = All;

                }
                field("Description2"; "Description 2")
                {
                    ApplicationArea = All;

                }
                field("Quantity"; "Quantity")
                {
                    ApplicationArea = All;

                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;

                }
                field("Qty Taken PO"; "Qty Taken (PO)")
                {
                    ApplicationArea = All;
                    Enabled = False;

                }
                field("Qty Received"; "Quantity Received")
                {
                    ApplicationArea = All;
                    Enabled = False;

                }
                field("UOM"; "Unit of Measure")
                {
                    ApplicationArea = All;

                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var





}