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
    }
}