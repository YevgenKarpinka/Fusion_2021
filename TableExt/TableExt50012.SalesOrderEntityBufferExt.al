tableextension 50012 "Sales Order Entity Buffer Ext." extends "Sales Order Entity Buffer"
{
    fields
    {
        // Add changes to table fields here
        field(50007; "ShipStation Shipment Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'ShipStation Shipment Amount', RUS = 'Сума отгрузки ShipStation';
        }
        field(50010; "ShipStation Carrier"; Text[30])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'ShipStation Carrier', RUS = 'Перевозчик ShipStation';
        }
        field(50011; "ShipStation Service"; Text[100])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'ShipStation Service', RUS = 'Услуга ShipStation';
        }
        field(50012; "ShipStation Package"; Text[100])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'ShipStation Package', RUS = 'Пакет ShipStation';
        }
    }
}