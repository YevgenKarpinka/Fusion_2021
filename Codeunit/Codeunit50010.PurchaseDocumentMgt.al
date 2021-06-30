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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnPurchLine2ReceiptLineOnAfterInitNewLine', '', false, false)]
    local procedure WhseCreateSourceDocumentOnBeforeWhseReceiptLineInsert(var WhseReceiptLine: Record "Warehouse Receipt Line"; WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        locLocation: Record Location;
        locItem: Record Item;
        locBin: Record Bin;
    begin
        if locLocation.Get(WhseReceiptHeader."Location Code")
        and locLocation."Find Bin by Class Code"
        and locItem.Get(WhseReceiptLine."Item No.")
        and locBin.Get(locLocation.Code, WhseReceiptHeader."Bin Code")
        and (locItem."Warehouse Class Code" <> locBin."Warehouse Class Code") then begin
            locBin.SetCurrentKey("Location Code", "Zone Code", "Warehouse Class Code");
            locBin.SetRange("Location Code", WhseReceiptHeader."Location Code");
            locBin.SetRange("Zone Code", WhseReceiptHeader."Zone Code");
            locBin.SetRange("Warehouse Class Code", locItem."Warehouse Class Code");
            if locBin.FindFirst() then begin
                WhseReceiptHeader."Bin Code" := locBin.Code;
                WhseReceiptHeader.Modify();
            end;
        end;
    end;
}