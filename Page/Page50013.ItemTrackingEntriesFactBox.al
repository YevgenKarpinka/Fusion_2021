page 50013 "Item Tracking Entries FactBox"
{
    PageType = ListPart;
    ApplicationArea = Basic, Suite;
    UsageCategory = History;
    SourceTable = "Item Ledger Entry";
    CaptionML = ENU = 'Item Tracking Entries', RUS = 'Операции трассировки товара';
    AccessByPermission = tabledata "Item Ledger Entry" = r;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Item Tracking List")
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
                field(BinCode; BinCode)
                {
                    ApplicationArea = All;
                    Caption = 'Bin Code';
                }
                field(CalcQtyAvailToTakeUOM; CalcQtyAvailToTakeUOM)
                {
                    ApplicationArea = All;
                    Caption = 'Available Qty. to Take';
                    DecimalPlaces = 0 : 5;
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        BinContent: Record "Bin Content";
        CalcQtyAvailToTakeUOM: Decimal;
        txtBinCode: Text;
        BinCode: Code[150];

    trigger OnAfterGetRecord()
    begin
        ClearAll();
        BinContent.SetCurrentKey("Location Code", "Item No.", "Variant Code", "Unit of Measure Code", "Lot No.");
        BinContent.SetRange("Location Code", Rec."Location Code");
        BinContent.SetRange("Item No.", Rec."Item No.");
        BinContent.SetRange("Variant Code", Rec."Variant Code");
        BinContent.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        BinContent.SetRange("Lot No.", Rec."Lot No.");
        if BinContent.FindSet() then
            repeat
                txtBinCode += '|' + BinContent."Bin Code";
                CalcQtyAvailToTakeUOM += BinContent.CalcQtyAvailToTakeUOM();
            until BinContent.Next() = 0;

        if StrLen(txtBinCode) > 0 then
            BinCode := CopyStr(txtBinCode, 2, MaxStrLen(BinCode) + 1);
    end;
}