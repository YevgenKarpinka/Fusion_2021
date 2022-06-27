table 50005 "ShipStation Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
            CaptionML = ENU = 'Primary Key', RUS = 'Первичный ключ';
        }
        field(2; "ShipStation Integration Enable"; Enum "ShipStation Integration Type")
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'ShipStation Integration Enable', RUS = 'Интегрировать с ShipStation';
        }
        field(3; "Order Status Update"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Order Status Update', RUS = 'Обновлять статус заказа';
        }
        field(4; "Show Error"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Show Error', RUS = 'Показывать ошибку';
        }
        field(5; "CRM Integration Enable"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'CRM Integration Enable', RUS = 'Интегрировать с CRM';
        }
        field(6; "Posting Type Shipment Cost"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Type Shipment Cost';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";

            trigger OnValidate()
            begin
                if "Posting Type Shipment Cost" <> xRec."Posting Type Shipment Cost" then
                    "Sales No. Shipment Cost" := '';
            end;
        }
        field(7; "Sales No. Shipment Cost"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales No. Shipment Cost';
            TableRelation = IF ("Posting Type Shipment Cost" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Posting Type Shipment Cost" = CONST(Item)) Item
            ELSE
            IF ("Posting Type Shipment Cost" = CONST(Resource)) Resource
            ELSE
            IF ("Posting Type Shipment Cost" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Posting Type Shipment Cost" = CONST("Charge (Item)")) "Item Charge";
        }
        field(8; "G/L Account State TAX"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'G/L Account State TAX', RUS = 'Счет НДС Штата';
            TableRelation = "G/L Account";
        }
        field(10; "Insert Item Charge On Release"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Insert Item Charge On Release', RUS = 'Добавлять издержки при Выпуске';
        }
        field(11; "Insert State TAX On Release"; Boolean)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Insert State TAX On Release', RUS = 'Добавлять НДС Штата при Выпуске';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        isEditable: Boolean;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

enum 50001 "ShipStation Integration Type"
{
    Extensible = true;

    value(0; "")
    {
        Caption = '';
    }
    value(1; "Sales Order")
    {
        Caption = 'Sales Order';
    }
    value(2; "Package")
    {
        Caption = 'Package';
    }
}