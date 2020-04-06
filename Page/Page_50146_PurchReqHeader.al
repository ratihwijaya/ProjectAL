page 50146 PurchReqHeader
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purchase Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;

                }
                field("Request Date"; "Req Date")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Requisition Date';

                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;

                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Gudang Peminta';

                }
                field("Keterangan"; "Ket")
                {
                    ApplicationArea = All;

                }
                field("Requester"; "Requesters")
                {
                    ApplicationArea = All;

                }
                field("Status"; "Status")
                {
                    ApplicationArea = All;

                }
                part(PurchReqLine; PurchReqLine)
                {
                    SubPageLink = "Document Type" = Field("Document Type"), "Document No." = field("No.");
                }
            }

        }

    }

    actions
    {
        area(Processing)
        {

            action(Release)
            {
                ApplicationArea = All;
                Image = ReleaseDoc;
                trigger OnAction();
                begin
                    ReleasePurchDoc.PerformManualRelease(Rec);
                end;
            }
            action(ReOpen)
            {
                ApplicationArea = All;
                Image = ReOpen;
                trigger OnAction();
                begin
                    ReleasePurchDoc.PerformManualReopen(Rec);
                end;
            }
        }
    }

    var
        ReleasePurchDoc: Codeunit "Release Purchase Document";
}