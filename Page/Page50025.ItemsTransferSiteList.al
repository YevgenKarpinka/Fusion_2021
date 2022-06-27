page 50025 "Items Transfer Site List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Item Transfer Site";
    InsertAllowed = false;
    Editable = false;
    CaptionML = ENU = 'Items Transfer Site List',
                RUS = 'Items Transfer Site List';

    layout
    {
        area(Content)
        {
            repeater(ItemsTransferSite)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}