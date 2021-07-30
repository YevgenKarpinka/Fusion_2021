codeunit 50007 "Find Same Lot No"
{
    Permissions = tabledata "Posted Whse. Receipt Line" = r, tabledata "Put-away Template Line" = r,
    tabledata "Bin Content" = rm, tabledata "Warehouse Activity Line" = r, tabledata "Warehouse Activity Header" = rm;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnFindBinContent', '', true, true)]
    local procedure CreatePutawayOnFindBinContent(PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; PutAwayTemplateLine: Record "Put-away Template Line"; var BinContent: Record "Bin Content")
    begin
        if PutAwayTemplateLine."Find Same Lot No." then
            BinContent.SetRange("Lot No.", PostedWhseReceiptLine."Lot No.")
    end;

    [EventSubscriber(ObjectType::Table, 7354, 'OnBeforeCheckWhseClass', '', true, true)]
    local procedure CreateShipmentOnBeforeCheckWhseClass(Bin: Record Bin; var IsHandled: Boolean; var ResultValue: Boolean)
    var
        locLocation: Record Location;
    begin
        if locLocation.Get(Bin."Location Code")
        and locLocation."Ignore Class Code In Shipment"
        and (locLocation."Shipment Bin Code" = Bin.Code) then begin
            ResultValue := true;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 7302, 'OnBeforeCheckWhseClass', '', true, true)]
    local procedure BinContentOnBeforeCheckWhseClass(var BinContent: Record "Bin Content"; var IsHandled: Boolean; var Result: Boolean)
    var
        locLocation: Record Location;
    begin
        if locLocation.Get(BinContent."Location Code")
        and locLocation."Ignore Class Code In Shipment"
        and (locLocation."Shipment Bin Code" = BinContent."Bin Code") then begin
            Result := true;
            IsHandled := true;
        end;
    end;

    // OnAfterInsertWhseEntry
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnAfterInsertWhseEntry', '', true, true)]
    local procedure RegisterWhseJnlOnAfterInsertWhseEntry(var WarehouseEntry: Record "Warehouse Entry")
    var
        BinContent: Record "Bin Content";
    begin
        if BinContent.Get(WarehouseEntry."Location Code", WarehouseEntry."Bin Code", WarehouseEntry."Item No.",
                        WarehouseEntry."Variant Code", WarehouseEntry."Unit of Measure Code") then begin
            BinContent."Lot No." := WarehouseEntry."Lot No.";
            BinContent.Modify();
        end;

    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnUpdateDefaultBinContentOnBeforeBinContentModify', '', true, true)]
    local procedure RegisterWhseJnlOnCreateBinContent(var BinContent: Record "Bin Content")
    var
        WhseEntry: Record "Warehouse Entry";
    begin
        WhseEntry.SetCurrentKey("Location Code", "Bin Code", "Item No.", "Variant Code", "Unit of Measure Code");
        WhseEntry.SetRange("Location Code", BinContent."Location Code");
        WhseEntry.SetRange("Bin Code", BinContent."Bin Code");
        WhseEntry.SetRange("Item No.", BinContent."Item No.");
        WhseEntry.SetRange("Variant Code", BinContent."Variant Code");
        WhseEntry.SetRange("Unit of Measure Code", BinContent."Unit of Measure Code");
        if WhseEntry.FindFirst() then begin
            BinContent."Lot No." := WhseEntry."Lot No.";
            BinContent.Modify();
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnUpdateDefaultBinContentOnBeforeBinContent2Modify', '', true, true)]
    local procedure RegisterWhseJnlOnCreateBinContent2(var BinContent: Record "Bin Content")
    var
        WhseEntry: Record "Warehouse Entry";
    begin
        WhseEntry.SetCurrentKey("Location Code", "Bin Code", "Item No.", "Variant Code", "Unit of Measure Code");
        WhseEntry.SetRange("Location Code", BinContent."Location Code");
        WhseEntry.SetRange("Bin Code", BinContent."Bin Code");
        WhseEntry.SetRange("Item No.", BinContent."Item No.");
        WhseEntry.SetRange("Variant Code", BinContent."Variant Code");
        WhseEntry.SetRange("Unit of Measure Code", BinContent."Unit of Measure Code");
        if WhseEntry.FindFirst() then begin
            BinContent."Lot No." := WhseEntry."Lot No.";
            BinContent.Modify();
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", 'OnBeforeBinContentInsert', '', true, true)]
    local procedure RegisterWhseJnlOnInsertBinContent(var BinContent: Record "Bin Content"; WarehouseEntry: Record "Warehouse Entry")
    begin
        BinContent."Lot No." := WarehouseEntry."Lot No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Put-away", 'OnCreateBinContentOnBeforeNewBinContentInsert', '', true, true)]
    local procedure CreatePutawayOnCreateBinContent(PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; var BinContent: Record "Bin Content")
    begin
        BinContent."Lot No." := PostedWhseReceiptLine."Lot No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnAfterSplitPostedWhseReceiptLine', '', true, true)]
    local procedure UpdateSourceDocumentIntoHeader(var TempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary)
    var
        locTempPostedWhseRcptLine: Record "Posted Whse. Receipt Line" temporary;
        locLocation: Record Location;
        LineNo: Integer;
    begin
        if locLocation.Get(TempPostedWhseRcptLine."Location Code")
        and locLocation."Sorting by Expired Date" then begin
            TempPostedWhseRcptLine.SetCurrentKey("Location Code", "Item No.", "Lot No.", "Expiration Date");
            if TempPostedWhseRcptLine.FindSet() then
                repeat
                    LineNo += 10000;
                    locTempPostedWhseRcptLine := TempPostedWhseRcptLine;
                    if locTempPostedWhseRcptLine."Line No." <> LineNo then
                        locTempPostedWhseRcptLine."Line No." := LineNo;
                    locTempPostedWhseRcptLine.Insert();
                until TempPostedWhseRcptLine.Next() = 0;

            TempPostedWhseRcptLine.DeleteAll();
            if locTempPostedWhseRcptLine.FindSet() then
                repeat
                    TempPostedWhseRcptLine := locTempPostedWhseRcptLine;
                    TempPostedWhseRcptLine.Insert();
                until locTempPostedWhseRcptLine.Next() = 0;
        end;
    end;
}