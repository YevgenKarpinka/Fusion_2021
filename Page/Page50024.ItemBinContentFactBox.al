page 50024 "Item Bin Content FactBox"
{
    PageType = ListPart;
    ApplicationArea = Basic, Suite;
    UsageCategory = History;
    SourceTable = "Bin Content";
    // SourceTableTemporary = true;
    CaptionML = ENU = 'Item Bin Contents', RUS = 'Содержимое ячеек по товару';
    AccessByPermission = tabledata "Bin Content" = r;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Item Bin Content")
            {
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field(ExpirationDate; WhseEntry."Expiration Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expiration Date';
                }
                field(CalcQtyAvailToTakeUOM; Rec.CalcQtyAvailToTakeUOM)
                {
                    ApplicationArea = All;
                    Caption = 'Available Qty. to Take';
                    DecimalPlaces = 0 : 5;
                }
                // field("Remaining Quantity"; Rec."Remaining Quantity")
                // {
                //     ApplicationArea = All;
                // }
                // field(Quantity; Rec.Quantity)
                // {
                //     ApplicationArea = All;
                // }
            }
        }
    }

    var
        WhseEntry: Record "Warehouse Entry";
        BinContent: Record "Bin Content";
        BinType: Record "Bin Type";
        BinTypeFilter: Text[250];

    trigger OnOpenPage()
    begin
        BinType.CreateBinTypeFilter(BinTypeFilter, 2);
        Rec.SetFilter("Bin Type Code", BinTypeFilter);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        NextRecNotFound: Boolean;
    begin
        if not Rec.Find(Which) then
            exit(false);

        if ShowRecord() then
            exit(true);

        repeat
            NextRecNotFound := Rec.Next <= 0;
            if ShowRecord() then
                exit(true);
        until NextRecNotFound;

        exit(false);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        NewStepCount: Integer;
    begin
        repeat
            NewStepCount := Rec.Next(Steps);
        until (NewStepCount = 0) or ShowRecord();

        exit(NewStepCount);
    end;

    trigger OnAfterGetRecord()
    begin
        ClearAll();
        WhseEntry.SetCurrentKey("Bin Code");
        WhseEntry.SetRange("Bin Code", Rec."Bin Code");
        if WhseEntry.FindFirst() then;
    end;

    local procedure ShowRecord(): Boolean
    begin
        exit(Rec.CalcQtyAvailToTakeUOM() > 0);
    end;
}