page 50017 "ShipStation Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ShipStation Setup";
    CaptionML = ENU = 'ShipStation Setup', RUS = 'ShipStation настройка';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(ShipStation)
            {
                field("ShipStation Integration Enable"; Rec."ShipStation Integration Enable")
                {
                    ToolTip = 'Specifies the value of the ShipStation Integration Enable field.';
                    ApplicationArea = All;
                }
                field("Order Status Update"; Rec."Order Status Update")
                {
                    ToolTip = 'Specifies the value of the Order Status Update field.';
                    ApplicationArea = All;
                }
                field("Show Error"; Rec."Show Error")
                {
                    ToolTip = 'Specifies the value of the Show Error field.';
                    ApplicationArea = All;
                }
                field("Insert Item Charge On Release"; Rec."Insert Item Charge On Release")
                {
                    ToolTip = 'Specifies the value of the Insert Item Charge On Release field.';
                    ApplicationArea = All;
                }
                field("Posting Type Shipment Cost"; Rec."Posting Type Shipment Cost")
                {
                    ToolTip = 'Specifies the value of the Posting Type Shipment Cost field.';
                    ApplicationArea = All;
                }
                field("Sales No. Shipment Cost"; Rec."Sales No. Shipment Cost")
                {
                    ToolTip = 'Specifies the value of the Sales No. Shipment Cost field.';
                    ApplicationArea = All;
                }
                field("Insert State TAX On Release"; Rec."Insert State TAX On Release")
                {
                    ToolTip = 'Specifies the value of the Insert State TAX On Release field.';
                    ApplicationArea = All;
                }
                field("G/L Account State TAX"; Rec."G/L Account State TAX")
                {
                    ToolTip = 'Specifies the value of the G/L Account State TAX field.';
                    ApplicationArea = All;
                }
            }
            group(CRM)
            {
                field("CRM Integration Enable"; Rec."CRM Integration Enable")
                {
                    ToolTip = 'Specifies the value of the CRM Integration Enable field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateCarriers)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Update Carriers and Services',
                            RUS = 'Обновить услуги доставки';

                trigger OnAction()
                begin
                    ShipStationMgt.UpdateCarriersAndServices();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        isEditable := Rec."ShipStation Integration Enable" in [Rec."ShipStation Integration Enable"::"Sales Order", Rec."ShipStation Integration Enable"::Package];
    end;

    var
        ShipStationMgt: Codeunit "ShipStation Mgt.";
        isEditable: Boolean;
}