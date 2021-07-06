codeunit 50010 "Purchase Document Mgt."
{
    trigger OnRun()
    begin

    end;

    procedure SplitPurchaseLine(purchaseLine: Record "Purchase Line")
    var
        locPurchaseLine: Record "Purchase Line";
        lastPurchaseLine: Record "Purchase Line";
        lineNo: Integer;
        quantity: Decimal;
    begin
        if purchaseLine."Line No." = 0 then exit;

        // copy line to next Line No
        locPurchaseLine.TransferFields(purchaseLine);
        lastPurchaseLine.SetCurrentKey("Line No.");
        lastPurchaseLine.SetRange("Document Type", purchaseLine."Document Type");
        lastPurchaseLine.SetRange("Document No.", purchaseLine."Document No.");
        lastPurchaseLine.FindFirst();
        lastPurchaseLine.Get(purchaseLine."Document Type", purchaseLine."Document No.", purchaseLine."Line No.");
        if lastPurchaseLine.Next() = 0 then
            LineNo := locPurchaseLine."Line No." + 10000
        else
            LineNo := (lastPurchaseLine."Line No." + locPurchaseLine."Line No.") div 2;

        locPurchaseLine."Line No." := LineNo;
        locPurchaseLine.Insert();

        // Split Quantity to Half
        quantity := locPurchaseLine.Quantity div 2;
        locPurchaseLine.Validate(Quantity, quantity);
        locPurchaseLine.Modify();
        locPurchaseLine.Next(-1);
        locPurchaseLine.Validate(Quantity, locPurchaseLine.Quantity - quantity);
        locPurchaseLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnBeforeUpdateReceiptLine', '', false, false)]
    local procedure WhseCreateSourceDocumentOnBeforeWhseReceiptLineInsert(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var IsHandled: Boolean)
    var
        locLocation: Record Location;
        locItem: Record Item;
        locBin: Record Bin;
        cod: Codeunit "Whse.-Create Source Document";
    begin
        if locLocation.Get(WarehouseReceiptHeader."Location Code")
        and locLocation."Find Bin by Class Code"
        and locItem.Get(WarehouseReceiptLine."Item No.")
        and locBin.Get(WarehouseReceiptHeader."Location Code", WarehouseReceiptHeader."Bin Code")
        and (locItem."Warehouse Class Code" <> locBin."Warehouse Class Code") then begin
            locBin.SetCurrentKey("Location Code", "Zone Code", "Warehouse Class Code");
            locBin.SetRange("Location Code", WarehouseReceiptHeader."Location Code");
            locBin.SetRange("Zone Code", WarehouseReceiptHeader."Zone Code");
            locBin.SetRange("Warehouse Class Code", locItem."Warehouse Class Code");
            if locBin.FindFirst() then begin
                WarehouseReceiptHeader."Bin Code" := locBin.Code;
                // >> standart
                if WarehouseReceiptHeader."Zone Code" <> '' then
                    WarehouseReceiptLine.Validate("Zone Code", WarehouseReceiptHeader."Zone Code");
                if WarehouseReceiptHeader."Bin Code" <> '' then
                    WarehouseReceiptLine.Validate("Bin Code", WarehouseReceiptHeader."Bin Code");
                if WarehouseReceiptHeader."Cross-Dock Zone Code" <> '' then
                    WarehouseReceiptLine.Validate("Cross-Dock Zone Code", WarehouseReceiptHeader."Cross-Dock Zone Code");
                if WarehouseReceiptHeader."Cross-Dock Bin Code" <> '' then
                    WarehouseReceiptLine.Validate("Cross-Dock Bin Code", WarehouseReceiptHeader."Cross-Dock Bin Code");
                // << standart
                IsHandled := true;
            end;
        end;
    end;

}