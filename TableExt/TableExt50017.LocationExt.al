tableextension 50017 "Location Ext." extends Location
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Create Move"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Create Move', RUS = 'Создать передвижение';
        }
        field(50001; "Sorting by Expired Date"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Sorting by Expired Date', RUS = 'Сортировка по сроку годности';
        }
        field(50002; "Find Bin by Class Code"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Find Bin by Class Code', RUS = 'Искать ячейку по коду класса';
        }
        field(50003; "Ignore Class Code In Shipment"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Ignore Class Code In Shipment', RUS = 'Игнорировать код класса в отгрузке';
        }
        field(50004; "Expired Items Not Reserve"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Expired Items Not Reserve', RUS = 'Не резервировать просроченный товар';
        }
    }
}