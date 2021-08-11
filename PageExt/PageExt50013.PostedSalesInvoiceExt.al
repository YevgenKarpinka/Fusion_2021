pageextension 50013 "Posted Sales Invoice Ext." extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Shipping Details")
        {
            group(groupShipStation)
            {
                CaptionML = ENU = 'ShipStation', RUS = 'ShipStation';

                field("ShipStation Carrier"; Rec."ShipStation Carrier")
                {
                    ApplicationArea = All;

                }
                field("ShipStation Service"; Rec."ShipStation Service")
                {
                    ApplicationArea = All;

                }
                field("ShipStation Package"; Rec."ShipStation Package")
                {
                    ApplicationArea = All;

                }
            }
        }
        addfirst(factboxes)
        {
            part(ItemTrackingEntries; "Post.Item Track.Entr.FackBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesInvLines;
                SubPageLink = "Document No." = field("Document No."), "Document Line No." = field("Line No.");
                // SubPageView = where (ad)
            }
        }
        addafter(Closed)
        {
            field("IC Document No."; Rec."IC Document No.")
            {
                ApplicationArea = All;
                Editable = false;
                Importance = Additional;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
            action("Print Invoice Fusion")
            {
                ApplicationArea = All;
                Image = PurchaseInvoice;
                CaptionML = ENU = 'Sales Invoice Fusion', RUS = 'Счет продажи Fusion';

                trigger OnAction()
                var
                    _SalesInvHeader: Record "Sales Invoice Header";
                begin
                    _SalesInvHeader := Rec;
                    CurrPage.SETSELECTIONFILTER(_SalesInvHeader);
                    Report.Run(Report::"Sales Invoice Fusion", true, true, _SalesInvHeader);
                end;
            }
        }
    }
    var
        ShipStationMgt: Codeunit "ShipStation Mgt.";
}