pageextension 50024 "Location Card Ext" extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Pick According to FEFO")
        {
            field("Create Move"; Rec."Create Move")
            {
                ApplicationArea = Warehouse;
                Visible = false;

                ToolTipML = ENU = 'Specifies that a move line is created, if an appropriate zone and bin from which to pick the item cannot be found.',
                            RUS = 'Указывает, что создается линия перемещения, если не удается найти подходящую зону и корзину, из которой можно выбрать товар.';
            }
            field("Sorting by Expired Date"; Rec."Sorting by Expired Date")
            {
                ApplicationArea = Warehouse;

                ToolTipML = ENU = 'Specifies sorting by expired date in posted warehouse receipt lines.',
                            RUS = 'Указывает сортировку по сроку годности для учтенных строк приемки.';
            }
            field("Find Bin by Class Code"; Rec."Find Bin by Class Code")
            {
                ApplicationArea = Warehouse;

                ToolTipML = ENU = 'Specifies find bin by class code to warehouse receipt lines.',
                            RUS = 'Указывает поиск ячейки по коду класса для строк приемки.';
            }
            field("Ignore Class Code In Shipment"; Rec."Ignore Class Code In Shipment")
            {
                ApplicationArea = Warehouse;

                ToolTipML = ENU = 'Specifies ignore class code to warehouse shipment lines.',
                            RUS = 'Указывает bигнорировать код класса для строк отгрузки.';
            }
            field("Expired Items Not Reserve"; Rec."Expired Items Not Reserve")
            {
                ApplicationArea = Warehouse;

                ToolTipML = ENU = 'Prohibits reservation of expired items.',
                            RUS = 'Запрещает резервирование просроченного товара.';
            }
        }
    }
}