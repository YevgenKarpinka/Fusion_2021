page 50015 "Item Tracking Line FactBox"
{
    PageType = ListPart;
    ApplicationArea = Basic, Suite;
    UsageCategory = History;
    SourceTable = "Reservation Entry";
    CaptionML = ENU = 'Reservation Line', RUS = 'Резерв строки';
    AccessByPermission = tabledata "Reservation Entry" = r;
    // SourceTableView = where("Lot No." = filter(<> ''));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater("Reservation Line")
            {
                // field(BinCode; BinCode)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Bin Code';
                // }
                field("Lot No."; ReservEntryLotNo."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; itemTrackingMgt.GetItemTrackingExpirationDateByLotNo(ReservEntryLotNo."Lot No.", ReservEntryLotNo."Item No."))
                {
                    ApplicationArea = All;
                }
                field(Quantity; ReservEntryLotNo.Quantity)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    var
        ReservEntryLotNo: Record "Reservation Entry";
        itemTrackingMgt: Codeunit "Item Tracking Mgt.";
    // BinContent: Record "Bin Content";
    // BinType: Record "Bin Type";
    // txtBinCode: Text;
    // BinCode: Code[150];
    // BinTypeFilter: Text[250];

    trigger OnAfterGetRecord()
    begin
        ClearAll();
        if ReservEntryLotNo.Get(Rec."Entry No.", true) then begin
            // BinContent.Reset();
            // BinContent.SetCurrentKey("Bin Code", "Location Code", "Item No.", "Variant Code", "Lot No.", "Bin Type Code");
            // // BinContent.SetAscending("Bin Ranking", false);
            // BinContent.SetRange("Location Code", ReservEntryLotNo."Location Code");
            // BinContent.SetRange("Item No.", ReservEntryLotNo."Item No.");
            // BinContent.SetRange("Variant Code", ReservEntryLotNo."Variant Code");
            // BinContent.SetRange("Lot No. Filter", ReservEntryLotNo."Lot No.");
            // BinType.CreateBinTypeFilter(BinTypeFilter, 2);
            // BinContent.SetFilter("Bin Type Code", BinTypeFilter);
            // txtBinCode := '';
            // if BinContent.FindSet() then
            //     repeat
            //         if BinContent.CalcQtyAvailToTakeUOM() > 0 then begin
            //             txtBinCode := BinContent."Bin Code";
            //         end;
            //     until (BinContent.Next() = 0) or (txtBinCode <> '');
        end;

    end;
}