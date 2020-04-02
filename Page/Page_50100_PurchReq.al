page 50100 PurchReqList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = FILTER('Purchase Requisition'));
    CardPageId = PurchReqHeader;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field("Keterangan"; "Ket")
                {
                    ApplicationArea = All;

                }
                field("Request Date"; "Req Date")
                {
                    ApplicationArea = All;

                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;

                }

                field("Status"; "Status")
                {
                    ApplicationArea = All;

                }
                field("Requester"; "Requesters")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
