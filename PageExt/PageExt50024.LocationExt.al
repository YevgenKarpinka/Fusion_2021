pageextension 50024 "Location Ext." extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Pick According to FEFO")
        {
            field("Create Move"; Rec."Create Move")
            {
                ApplicationArea = Warehouse;

                ToolTipML = ENU = 'Specifies that a move line is created, if an appropriate zone and bin from which to pick the item cannot be found.',
                            RUS = 'Указывает, что создается линия перемещения, если не удается найти подходящую зону и корзину, из которой можно выбрать товар.';
            }
            field("Sorting by Expired Date"; Rec."Sorting by Expired Date")
            {
                ApplicationArea = Warehouse;

                ToolTipML = ENU = 'Specifies sorting by expired date in posted warehouse receipt lines.',
                            RUS = 'Указывает сортировку по сроку годности для учтенных строк приемки.';
            }
        }
    }
}