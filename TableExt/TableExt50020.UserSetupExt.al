tableextension 50020 "User Setup Ext" extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Enable Today as Work Date"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Enable Today as Work Date',
                        RUS = 'Включить Сегодня как Рабочую дату';
        }
    }
}